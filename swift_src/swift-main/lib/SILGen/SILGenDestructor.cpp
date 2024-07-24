//===--- SILGenDestructor.cpp - SILGen for destructors --------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

#include "ArgumentScope.h"
#include "RValue.h"
#include "SILGenFunction.h"
#include "SILGenFunctionBuilder.h"
#include "SwitchEnumBuilder.h"
#include "swift/AST/Decl.h"
#include "swift/AST/GenericSignature.h"
#include "swift/AST/SubstitutionMap.h"
#include "swift/SIL/SILBuilder.h"
#include "swift/SIL/SILLinkage.h"
#include "swift/SIL/SILMoveOnlyDeinit.h"
#include "swift/SIL/SILValue.h"
#include "swift/SIL/TypeLowering.h"
#include "llvm/ADT/SmallSet.h"

using namespace swift;
using namespace Lowering;

void SILGenFunction::emitDestroyingDestructor(DestructorDecl *dd) {
  MagicFunctionName = DeclName(SGM.M.getASTContext().getIdentifier("deinit"));

  RegularLocation Loc(dd);
  if (dd->isImplicit())
    Loc.markAutoGenerated();

  if (dd->requiresUnavailableDeclABICompatibilityStubs())
    emitApplyOfUnavailableCodeReached();

  auto cd = cast<ClassDecl>(dd->getDeclContext()->getSelfNominalTypeDecl());
  auto &C = cd->getASTContext();
  SILValue selfValue = emitSelfDeclForDestructor(dd->getImplicitSelfDecl());

  // Create a basic block to jump to for the implicit destruction behavior
  // of releasing the elements and calling the superclass destructor.
  // We won't actually emit the block until we finish with the destructor body.
  prepareEpilog(dd, std::nullopt, std::nullopt, CleanupLocation(Loc));

  auto cleanupLoc = CleanupLocation(Loc);

  SILBasicBlock *deinitBodyBB = nullptr;
  SILBasicBlock *finishBB = nullptr;
  if (cd->isDistributedActor()) {
    auto remoteBB = createBasicBlock("remoteActorDeinitBB");
    finishBB = createBasicBlock("finishDeinitBB");
    deinitBodyBB = createBasicBlock("deinitBodyBB");

    // FIXME: what should the type of management be for this?
    auto managedSelf = ManagedValue::forBorrowedRValue(selfValue);

    auto selfTy = F.mapTypeIntoContext(cd->getDeclaredInterfaceType());
    emitDistributedIfRemoteBranch(
        SILLocation(Loc),
        managedSelf, selfTy,
        /*if remote=*/remoteBB,
        /*if local=*/deinitBodyBB);

    {
      B.emitBlock(remoteBB);

      // Note that we do NOT execute user-declared the deinit body.
      // They would be free to access state which does not exist in a remote DA

      // we are a remote instance,
      // the only properties we can destroy are the id and system properties.
      for (VarDecl *vd : cd->getStoredProperties()) {
        if (getActorIsolation(vd) == ActorIsolation::ActorInstance)
          continue;

        // Just to double-check, we only want to destroy `id` and `actorSystem`
        if (vd->getBaseIdentifier() == C.Id_id ||
            vd->getBaseIdentifier() == C.Id_actorSystem) {
          destroyClassMember(cleanupLoc, managedSelf, vd);
        }
      }

      B.createBranch(SILLocation(Loc), finishBB);
    }
  }

  // Emit the destructor body.
  if (deinitBodyBB)
    B.emitBlock(deinitBodyBB);

  emitProfilerIncrement(dd->getTypecheckedBody());
  emitStmt(dd->getTypecheckedBody());

  std::optional<SILValue> maybeReturnValue;
  SILLocation returnLoc(Loc);
  std::tie(maybeReturnValue, returnLoc) = emitEpilogBB(Loc);

  if (!maybeReturnValue)
    return;

  // If we have a superclass, invoke its destructor.
  SILValue resultSelfValue;
  SILType objectPtrTy = SILType::getNativeObjectType(F.getASTContext());
  SILType classTy = selfValue->getType();
  if (cd->hasSuperclass() && !cd->isNativeNSObjectSubclass()) {
    Type superclassTy =
      dd->mapTypeIntoContext(cd->getSuperclass());
    ClassDecl *superclass = superclassTy->getClassOrBoundGenericClass();
    auto superclassDtorDecl = superclass->getDestructor();
    SILDeclRef dtorConstant =
      SILDeclRef(superclassDtorDecl, SILDeclRef::Kind::Destroyer);
    SILType baseSILTy = getLoweredLoadableType(superclassTy);
    SILValue baseSelf = B.createUpcast(cleanupLoc, selfValue, baseSILTy);
    ManagedValue dtorValue;
    SILType dtorTy;
    auto subMap
      = superclassTy->getContextSubstitutionMap(SGM.M.getSwiftModule(),
                                                superclass);
    std::tie(dtorValue, dtorTy)
      = emitSiblingMethodRef(cleanupLoc, baseSelf, dtorConstant, subMap);

    resultSelfValue = B.createApply(cleanupLoc, dtorValue.forward(*this),
                                    subMap, baseSelf);
  } else {
    resultSelfValue = selfValue;
  }

  ArgumentScope S(*this, Loc);
  ManagedValue borrowedValue = B.borrowObjectRValue(
      *this, cleanupLoc, resultSelfValue, ManagedValue::ScopeKind::Lexical);

  if (classTy != borrowedValue.getType()) {
    borrowedValue =
        B.createUncheckedRefCast(cleanupLoc, borrowedValue, classTy);
  }

  // A distributed actor must invoke `actorSystem.resignID` as it deinits.
  if (cd->isDistributedActor()) {
    // This must only be called by a *local* distributed actor (not a remote proxy).
    // Since this call is emitted after the user-declared body of the deinit,
    // just before returning; this is guaranteed to only be executed in the local
    // actor case - because the body is never executed for a remote proxy either.
    emitDistributedActorSystemResignIDCall(
        cleanupLoc, cd, ManagedValue::forBorrowedRValue(selfValue));
  }

  // Release our members.
  emitClassMemberDestruction(borrowedValue, cd, cleanupLoc, finishBB);

  S.pop();

  if (resultSelfValue->getType() != objectPtrTy) {
    resultSelfValue =
        B.createUncheckedRefCast(cleanupLoc, resultSelfValue, objectPtrTy);
  }
  if (resultSelfValue->getOwnershipKind() != OwnershipKind::Owned) {
    assert(resultSelfValue->getOwnershipKind() == OwnershipKind::Guaranteed);
    resultSelfValue = B.createUncheckedOwnershipConversion(
        cleanupLoc, resultSelfValue, OwnershipKind::Owned);
  }
  B.createReturn(returnLoc, resultSelfValue);
}

void SILGenFunction::emitDeallocatingDestructor(DestructorDecl *dd) {
  auto *nom = dd->getDeclContext()->getSelfNominalTypeDecl();
  if (isa<ClassDecl>(nom))
    return emitDeallocatingClassDestructor(dd);
  assert(!nom->canBeCopyable());
  return emitDeallocatingMoveOnlyDestructor(dd);
}

void SILGenFunction::emitDeallocatingClassDestructor(DestructorDecl *dd) {
  MagicFunctionName = DeclName(SGM.M.getASTContext().getIdentifier("deinit"));

  // The deallocating destructor is always auto-generated.
  RegularLocation loc(dd);
  loc.markAutoGenerated();

  if (dd->requiresUnavailableDeclABICompatibilityStubs())
    emitApplyOfUnavailableCodeReached();

  // Emit the prolog.
  SILValue initialSelfValue =
      emitSelfDeclForDestructor(dd->getImplicitSelfDecl());

  // Form a reference to the destroying destructor.
  SILDeclRef dtorConstant(dd, SILDeclRef::Kind::Destroyer);
  auto classTy = initialSelfValue->getType();
  auto classDecl = classTy.getASTType()->getAnyNominal();
  ManagedValue dtorValue;
  SILType dtorTy;
  auto subMap = classTy.getASTType()
    ->getContextSubstitutionMap(SGM.M.getSwiftModule(),
                                classDecl);
  std::tie(dtorValue, dtorTy)
    = emitSiblingMethodRef(loc, initialSelfValue, dtorConstant, subMap);

  // Call the destroying destructor.
  SILValue selfForDealloc;
  {
    FullExpr CleanupScope(Cleanups, CleanupLocation(loc));
    ManagedValue borrowedSelf = emitManagedBeginBorrow(loc, initialSelfValue);
    selfForDealloc = B.createApply(loc, dtorValue.forward(*this), subMap,
                                   borrowedSelf.getUnmanagedValue());
  }

  // Balance out the +1 from the self argument using end_lifetime.
  //
  // The issue here is that:
  //
  // 1. Self is passed into deallocating deinits at +1.
  // 2. Destroying deinits take in self as a +0 value that is then returned at
  // +1.
  //
  // This means that the lifetime of self can not be modeled statically in a
  // deallocating deinit without analyzing the body of the destroying deinit
  // (something that violates semantic sil). Thus we add an artificial destroy of
  // self before the actual destroy of self so that the verifier can understand
  // that self is being properly balanced.
  B.createEndLifetime(loc, initialSelfValue);

  // Deallocate the object.
  selfForDealloc = B.createUncheckedRefCast(loc, selfForDealloc, classTy);
  B.createDeallocRef(loc, selfForDealloc);

  // Return.
  B.createReturn(loc, emitEmptyTuple(loc));
}

void SILGenFunction::emitDeallocatingMoveOnlyDestructor(DestructorDecl *dd) {
  MagicFunctionName = DeclName(SGM.M.getASTContext().getIdentifier("deinit"));

  RegularLocation loc(dd);
  if (dd->isImplicit())
    loc.markAutoGenerated();

  if (dd->requiresUnavailableDeclABICompatibilityStubs())
    emitApplyOfUnavailableCodeReached();

  // Emit the prolog.
  auto selfValue = emitSelfDeclForDestructor(dd->getImplicitSelfDecl());

  // Create a basic block to jump to for the implicit destruction behavior
  // of releasing the elements and calling the superclass destructor.
  // We won't actually emit the block until we finish with the destructor body.
  prepareEpilog(dd, std::nullopt, std::nullopt, CleanupLocation(loc));

  auto cleanupLoc = CleanupLocation(loc);

  emitProfilerIncrement(dd->getTypecheckedBody());
  emitStmt(dd->getTypecheckedBody());

  std::optional<SILValue> maybeReturnValue;
  SILLocation returnLoc(loc);
  std::tie(maybeReturnValue, returnLoc) = emitEpilogBB(loc);

  // Clean up our members, consuming our +1 self value as we do it.
  emitMoveOnlyMemberDestruction(selfValue,
                                dd->getDeclContext()->getSelfNominalTypeDecl(),
                                cleanupLoc);

  if (auto *ddi = dyn_cast<DropDeinitInst>(selfValue)) {
    if (auto *mu =
            dyn_cast<MarkUnresolvedNonCopyableValueInst>(ddi->getOperand())) {
      if (auto *asi = dyn_cast<AllocStackInst>(mu->getOperand())) {
        B.createDeallocStack(loc, asi);
      }
    }
  }

  // Return.
  B.createReturn(loc, emitEmptyTuple(loc));
}

void SILGenFunction::emitIVarDestroyer(SILDeclRef ivarDestroyer) {
  auto cd = cast<ClassDecl>(ivarDestroyer.getDecl());
  RegularLocation loc(cd);
  loc.markAutoGenerated();

  ManagedValue selfValue;
  {
    SILValue rawSelfValue =
        emitSelfDeclForDestructor(cd->getDestructor()->getImplicitSelfDecl());
    if (rawSelfValue->getOwnershipKind() == OwnershipKind::Unowned) {
      selfValue = ManagedValue::forUnownedObjectValue(rawSelfValue);
    } else {
      selfValue = ManagedValue::forBorrowedRValue(rawSelfValue);
    }
  }
  assert(selfValue);

  auto cleanupLoc = CleanupLocation(loc);
  prepareEpilog(cd, std::nullopt, std::nullopt, cleanupLoc);
  {
    Scope S(*this, cleanupLoc);
    // Self is effectively guaranteed for the duration of any destructor.  For
    // ObjC classes, self may be unowned. A conversion to guaranteed is required
    // to access its members.
    if (selfValue.getOwnershipKind() != OwnershipKind::Guaranteed) {
      // %guaranteedSelf = unchecked_ownership_conversion %self to @guaranteed
      // ...
      // end_borrow %guaranteedSelf
      auto guaranteedSelf = B.createUncheckedOwnershipConversion(
        cleanupLoc, selfValue.forward(*this), OwnershipKind::Guaranteed);
      selfValue = emitManagedBorrowedRValueWithCleanup(guaranteedSelf);
    }
    emitClassMemberDestruction(selfValue, cd, cleanupLoc, /*finishBB=*/nullptr);
  }

  B.createReturn(loc, emitEmptyTuple(loc));
  emitEpilog(loc);
}

void SILGenFunction::destroyClassMember(SILLocation cleanupLoc,
                                        ManagedValue selfValue, VarDecl *D) {
  const TypeLowering &ti = getTypeLowering(D->getTypeInContext());
  if (!ti.isTrivial()) {
    SILValue addr =
        B.createRefElementAddr(cleanupLoc, selfValue.getValue(), D,
                               ti.getLoweredType().getAddressType());
    addr = B.createBeginAccess(
        cleanupLoc, addr, SILAccessKind::Deinit, SILAccessEnforcement::Static,
        false /*noNestedConflict*/, false /*fromBuiltin*/);
    B.createDestroyAddr(cleanupLoc, addr);
    B.createEndAccess(cleanupLoc, addr, false /*is aborting*/);
  }
}

/// Finds stored properties that have the same type as `cd` and thus form
/// a recursive structure.
///
/// Example:
///
///   class Node<T> {
///     let element: T
///     let next: Node<T>?
///   }
///
/// In the above example `next` is a recursive link and would be recognized
/// by this function and added to the result set.
static void findRecursiveLinks(ClassDecl *cd,
                               llvm::SmallSetVector<VarDecl *, 4> &result) {
  auto selfTy = cd->getDeclaredInterfaceType();

  // Collect all stored properties that would form a recursive structure,
  // so we can remove the recursion and prevent the call stack from
  // overflowing.
  for (VarDecl *vd : cd->getStoredProperties()) {
    auto Ty = vd->getInterfaceType()->getOptionalObjectType();
    if (Ty && Ty->getCanonicalType() == selfTy->getCanonicalType()) {
      result.insert(vd);
    }
  }

  // NOTE: Right now we only optimize linear recursion, so if there is more
  // than one stored property of the same type, clear out the set and don't
  // perform any recursion optimization.
  if (result.size() > 1) {
    result.clear();
  }
}

void SILGenFunction::emitRecursiveChainDestruction(ManagedValue selfValue,
                                                   ClassDecl *cd,
                                                   VarDecl *recursiveLink,
                                                   CleanupLocation cleanupLoc) {
  auto selfTy = F.mapTypeIntoContext(cd->getDeclaredInterfaceType());

  auto selfTyLowered = getTypeLowering(selfTy).getLoweredType();

  SILBasicBlock *cleanBB = createBasicBlock();
  SILBasicBlock *noneBB = createBasicBlock();
  SILBasicBlock *notUniqueBB = createBasicBlock();
  SILBasicBlock *uniqueBB = createBasicBlock();
  SILBasicBlock *someBB = createBasicBlock();
  SILBasicBlock *loopBB = createBasicBlock();

  // var iter = self.link
  // self.link = nil
  auto Ty = getTypeLowering(F.mapTypeIntoContext(recursiveLink->getInterfaceType())).getLoweredType();
  auto optionalNone = B.createOptionalNone(cleanupLoc, Ty);
  SILValue varAddr =
    B.createRefElementAddr(cleanupLoc, selfValue.getValue(), recursiveLink,
                           Ty.getAddressType());
  auto *iterAddr = B.createAllocStack(cleanupLoc, Ty);
  SILValue addr = B.createBeginAccess(
    cleanupLoc, varAddr, SILAccessKind::Modify, SILAccessEnforcement::Static,
    true /*noNestedConflict*/, false /*fromBuiltin*/);
  SILValue iter = B.createLoad(cleanupLoc, addr, LoadOwnershipQualifier::Take);
  B.createStore(cleanupLoc, optionalNone, addr, StoreOwnershipQualifier::Init);
  B.createEndAccess(cleanupLoc, addr, false /*is aborting*/);
  B.createStore(cleanupLoc, iter, iterAddr, StoreOwnershipQualifier::Init);

  B.createBranch(cleanupLoc, loopBB);

  // while iter != nil {
  {
    B.emitBlock(loopBB);
    auto iterBorrow = ManagedValue::forBorrowedAddressRValue(iterAddr);
    SwitchEnumBuilder switchBuilder(B, cleanupLoc, iterBorrow);
    switchBuilder.addOptionalSomeCase(someBB);
    switchBuilder.addOptionalNoneCase(noneBB);
    std::move(switchBuilder).emit();
  }

  // if isKnownUniquelyReferenced(&iter) {
  {
    B.emitBlock(someBB);
    auto isUnique = B.createIsUnique(cleanupLoc, iterAddr);
    B.createCondBranch(cleanupLoc, isUnique, uniqueBB, notUniqueBB);
  }

  // we have a uniquely referenced link, so we need to deinit
  {
    B.emitBlock(uniqueBB);

    // let tail = iter.unsafelyUnwrapped.next
    // iter = tail
    SILValue iterBorrow = B.createLoadBorrow(cleanupLoc, iterAddr);
    auto *link = B.createUncheckedEnumData(
        cleanupLoc, iterBorrow, getASTContext().getOptionalSomeDecl(),
        selfTyLowered);

    varAddr = B.createRefElementAddr(cleanupLoc, link, recursiveLink,
                                     Ty.getAddressType());

    addr = B.createBeginAccess(
        cleanupLoc, varAddr, SILAccessKind::Read, SILAccessEnforcement::Static,
        true /* noNestedConflict */, false /*fromBuiltin*/);

    // The deinit of `iter` will decrement the ref count of the field
    // containing the next element and potentially leading to its
    // deinitialization, causing the recursion. The prevent that,
    // we `load [copy]` here to ensure the object stays alive until
    // we explicitly release it in the next step of the iteration.
    iter = B.createLoad(cleanupLoc, addr, LoadOwnershipQualifier::Copy);
    B.createEndAccess(cleanupLoc, addr, false /*is aborting*/);
    B.createEndBorrow(cleanupLoc, iterBorrow);

    B.createStore(cleanupLoc, iter, iterAddr, StoreOwnershipQualifier::Assign);

    B.createBranch(cleanupLoc, loopBB);
  }

  // the next link in the chain is not unique, so we are done here
  {
    B.emitBlock(notUniqueBB);
    B.createBranch(cleanupLoc, cleanBB);
  }

  // we reached the end of the chain
  {
    B.emitBlock(noneBB);
    B.createBranch(cleanupLoc, cleanBB);
  }

  {
    B.emitBlock(cleanBB);
    B.createDestroyAddr(cleanupLoc, iterAddr);
    B.createDeallocStack(cleanupLoc, iterAddr);
  }
}

void SILGenFunction::emitClassMemberDestruction(ManagedValue selfValue,
                                                ClassDecl *cd,
                                                CleanupLocation cleanupLoc,
                                                SILBasicBlock *finishBB) {
  assert(selfValue.getOwnershipKind() == OwnershipKind::Guaranteed);

  // Before we destroy all fields, we check if any of them are
  // recursively the same type as `self`, so we can iteratively
  // deinitialize them, to prevent deep recursion and potential
  // stack overflows.

  llvm::SmallSetVector<VarDecl *, 4> recursiveLinks;
  findRecursiveLinks(cd, recursiveLinks);

  /// Destroy all members.
  {
    for (VarDecl *vd : cd->getStoredProperties()) {
      if (recursiveLinks.contains(vd))
        continue;
      destroyClassMember(cleanupLoc, selfValue, vd);
    }

    if (!recursiveLinks.empty()) {
      assert(recursiveLinks.size() == 1 && "Only linear recursion supported.");
      emitRecursiveChainDestruction(selfValue, cd, recursiveLinks[0], cleanupLoc);
    }

    if (finishBB)
      B.createBranch(cleanupLoc, finishBB);
  }

  {
    if (finishBB)
      B.emitBlock(finishBB);

    if (cd->isRootDefaultActor()) {
      auto builtinName = getASTContext().getIdentifier(
          getBuiltinName(BuiltinValueKind::DestroyDefaultActor));
      auto resultTy = SGM.Types.getEmptyTupleType();

      B.createBuiltin(cleanupLoc, builtinName, resultTy, /*subs*/{},
                      { selfValue.getValue() });
    }
  }
}

void SILGenFunction::emitMoveOnlyMemberDestruction(SILValue selfValue,
                                                   NominalTypeDecl *nom,
                                                   CleanupLocation cleanupLoc) {
  if (!isa<DropDeinitInst>(selfValue)) {
    // drop_deinit invalidates any user-defined struct/enum deinit
    // before the individual members are destroyed.
    selfValue = B.createDropDeinit(cleanupLoc, selfValue);
  }
  if (selfValue->getType().isObject()) {
    // A destroy value that uses the result of a drop_deinit implicitly performs
    // memberwise destruction.
    B.emitDestroyValueOperation(cleanupLoc, selfValue);
    return;
  }
  // self has been stored into a temporary
  assert(!selfValue->getType().isObject());
  if (auto *structDecl = dyn_cast<StructDecl>(nom)) {
    for (VarDecl *vd : nom->getStoredProperties()) {
      const TypeLowering &ti = getTypeLowering(vd->getTypeInContext());
      if (ti.isTrivial())
        continue;

      SILValue addr = B.createStructElementAddr(
          cleanupLoc, selfValue, vd, ti.getLoweredType().getAddressType());
      addr = B.createBeginAccess(
          cleanupLoc, addr, SILAccessKind::Deinit, SILAccessEnforcement::Static,
          false /*noNestedConflict*/, false /*fromBuiltin*/);
      B.createDestroyAddr(cleanupLoc, addr);
      B.createEndAccess(cleanupLoc, addr, false /*is aborting*/);
    }
  } else {
    auto *origBlock = B.getInsertionBB();
    auto *enumDecl = cast<EnumDecl>(nom);
    SmallVector<std::pair<EnumElementDecl *, SILBasicBlock *>, 8> caseCleanups;
    auto *contBlock = createBasicBlock();

    for (auto *enumElt : enumDecl->getAllElements()) {
      auto *enumBlock = createBasicBlock();
      SILBuilder builder(enumBlock, enumBlock->begin());

      if (enumElt->hasAssociatedValues()) {
        auto *take = builder.createUncheckedTakeEnumDataAddr(
            cleanupLoc, selfValue, enumElt);
        builder.createDestroyAddr(cleanupLoc, take);
      }

      // Branch to the continue trampoline block.
      builder.createBranch(cleanupLoc, contBlock);
      caseCleanups.emplace_back(enumElt, enumBlock);

      // Set the insertion point to after this enum block so we insert the
      // next new block after this block.
      B.setInsertionPoint(enumBlock);
    }

    B.setInsertionPoint(origBlock);
    B.createSwitchEnumAddr(cleanupLoc, selfValue, nullptr, caseCleanups);
    B.setInsertionPoint(contBlock);
  }
}

void SILGenFunction::emitObjCDestructor(SILDeclRef dtor) {
  auto dd = cast<DestructorDecl>(dtor.getDecl());
  auto cd = cast<ClassDecl>(dd->getDeclContext()->getImplementedObjCContext());
  MagicFunctionName = DeclName(SGM.M.getASTContext().getIdentifier("deinit"));

  RegularLocation loc(dd);
  if (dd->isImplicit())
    loc.markAutoGenerated();

  if (dd->requiresUnavailableDeclABICompatibilityStubs())
    emitApplyOfUnavailableCodeReached();

  SILValue selfValue = emitSelfDeclForDestructor(dd->getImplicitSelfDecl());

  // Create a basic block to jump to for the implicit destruction behavior
  // of releasing the elements and calling the superclass destructor.
  // We won't actually emit the block until we finish with the destructor body.
  prepareEpilog(dd, std::nullopt, std::nullopt, CleanupLocation(loc));

  emitProfilerIncrement(dd->getTypecheckedBody());
  // Emit the destructor body.
  emitStmt(dd->getTypecheckedBody());

  std::optional<SILValue> maybeReturnValue;
  SILLocation returnLoc(loc);
  std::tie(maybeReturnValue, returnLoc) = emitEpilogBB(loc);

  if (!maybeReturnValue)
    return;

  auto cleanupLoc = CleanupLocation(loc);

  // Note: the ivar destroyer is responsible for destroying the
  // instance variables before the object is actually deallocated.

  // Form a reference to the superclass -dealloc.
  Type superclassTy = dd->mapTypeIntoContext(cd->getSuperclass());
  assert(superclassTy && "Emitting Objective-C -dealloc without superclass?");
  ClassDecl *superclass = superclassTy->getClassOrBoundGenericClass();
  auto superclassDtorDecl = superclass->getDestructor();
  auto superclassDtor = SILDeclRef(superclassDtorDecl,
                                   SILDeclRef::Kind::Deallocator)
    .asForeign();
  auto superclassDtorType =
      SGM.Types.getConstantType(getTypeExpansionContext(), superclassDtor);
  SILValue superclassDtorValue = B.createObjCSuperMethod(
                                   cleanupLoc, selfValue, superclassDtor,
                                   superclassDtorType);

  // Call the superclass's -dealloc.
  SILType superclassSILTy = getLoweredLoadableType(superclassTy);
  SILValue superSelf = B.createUpcast(cleanupLoc, selfValue, superclassSILTy);
  assert(superSelf->getOwnershipKind() == OwnershipKind::Owned);

  auto subMap
    = superclassTy->getContextSubstitutionMap(SGM.M.getSwiftModule(),
                                              superclass);

  B.createApply(cleanupLoc, superclassDtorValue, subMap, superSelf);

  // We know that the given value came in at +1, but we pass the relevant value
  // as unowned to the destructor. Create a fake balance for the verifier to be
  // happy.
  B.createEndLifetime(cleanupLoc, superSelf);

  // Return.
  B.createReturn(returnLoc, emitEmptyTuple(cleanupLoc));
}