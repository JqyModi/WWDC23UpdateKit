sil_stage raw

import Builtin
import Swift
import SwiftShims

protocol ProtocolA {
}

extension ProtocolA {
  func test1()
}

struct StructB {
  init()
}

extension StructB : ProtocolA {
  func test1()
}

@_hasStorage @_hasInitialValue let p1: any ProtocolA { get }

@_hasStorage @_hasInitialValue let s1: StructB { get }

// p1
sil_global hidden [let] @$s8dispatch2p1AA9ProtocolA_pvp : $any ProtocolA

// s1
sil_global hidden [let] @$s8dispatch2s1AA7StructBVvp : $StructB

// main
sil [ossa] @main : $@convention(c) (Int32, UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>) -> Int32 {
bb0(%0 : $Int32, %1 : $UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>):
  alloc_global @$s8dispatch2p1AA9ProtocolA_pvp    // id: %2
  %3 = global_addr @$s8dispatch2p1AA9ProtocolA_pvp : $*any ProtocolA // users: %15, %7
  %4 = metatype $@thin StructB.Type               // user: %6
  // function_ref StructB.init()
  %5 = function_ref @$s8dispatch7StructBVACycfC : $@convention(method) (@thin StructB.Type) -> StructB // user: %6
  %6 = apply %5(%4) : $@convention(method) (@thin StructB.Type) -> StructB // user: %8
  %7 = init_existential_addr %3 : $*any ProtocolA, $StructB // user: %8
  store %6 to [trivial] %7 : $*StructB            // id: %8
  alloc_global @$s8dispatch2s1AA7StructBVvp       // id: %9
  %10 = global_addr @$s8dispatch2s1AA7StructBVvp : $*StructB // users: %18, %14
  %11 = metatype $@thin StructB.Type              // user: %13
  // function_ref StructB.init()
  %12 = function_ref @$s8dispatch7StructBVACycfC : $@convention(method) (@thin StructB.Type) -> StructB // user: %13
  %13 = apply %12(%11) : $@convention(method) (@thin StructB.Type) -> StructB // user: %14
  store %13 to [trivial] %10 : $*StructB          // id: %14
  %15 = open_existential_addr immutable_access %3 : $*any ProtocolA to $*@opened("F05D9640-4A40-11EF-9F94-EE7386ABDDAF", any ProtocolA) Self // users: %17, %17
  // function_ref ProtocolA.test1()
  %16 = function_ref @$s8dispatch9ProtocolAPAAE5test1yyF : $@convention(method) <τ_0_0 where τ_0_0 : ProtocolA> (@in_guaranteed τ_0_0) -> () // user: %17
  %17 = apply %16<@opened("F05D9640-4A40-11EF-9F94-EE7386ABDDAF", any ProtocolA) Self>(%15) : $@convention(method) <τ_0_0 where τ_0_0 : ProtocolA> (@in_guaranteed τ_0_0) -> () // type-defs: %15
  %18 = load [trivial] %10 : $*StructB            // user: %20
  // function_ref StructB.test1()
  %19 = function_ref @$s8dispatch7StructBV5test1yyF : $@convention(method) (StructB) -> () // user: %20
  %20 = apply %19(%18) : $@convention(method) (StructB) -> ()
  %21 = integer_literal $Builtin.Int32, 0         // user: %22
  %22 = struct $Int32 (%21 : $Builtin.Int32)      // user: %23
  return %22 : $Int32                             // id: %23
} // end sil function 'main'

// ProtocolA.test1()
sil hidden [ossa] @$s8dispatch9ProtocolAPAAE5test1yyF : $@convention(method) <Self where Self : ProtocolA> (@in_guaranteed Self) -> () {
// %0 "self"                                      // user: %1
bb0(%0 : $*Self):
  debug_value %0 : $*Self, let, name "self", argno 1, implicit, expr op_deref // id: %1
  %2 = integer_literal $Builtin.Word, 1           // user: %4
  // function_ref _allocateUninitializedArray<A>(_:)
  %3 = function_ref @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %4
  %4 = apply %3<Any>(%2) : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %5
  (%5, %6) = destructure_tuple %4 : $(Array<Any>, Builtin.RawPointer) // users: %17, %7
  %7 = pointer_to_address %6 : $Builtin.RawPointer to [strict] $*Any // user: %14
  %8 = string_literal utf8 "ProtocolA - test1"    // user: %13
  %9 = integer_literal $Builtin.Word, 17          // user: %13
  %10 = integer_literal $Builtin.Int1, -1         // user: %13
  %11 = metatype $@thin String.Type               // user: %13
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %12 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %13
  %13 = apply %12(%8, %9, %10, %11) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %15
  %14 = init_existential_addr %7 : $*Any, $String // user: %15
  store %13 to [init] %14 : $*String              // id: %15
  // function_ref _finalizeUninitializedArray<A>(_:)
  %16 = function_ref @$ss27_finalizeUninitializedArrayySayxGABnlF : $@convention(thin) <τ_0_0> (@owned Array<τ_0_0>) -> @owned Array<τ_0_0> // user: %17
  %17 = apply %16<Any>(%5) : $@convention(thin) <τ_0_0> (@owned Array<τ_0_0>) -> @owned Array<τ_0_0> // users: %26, %23
  // function_ref default argument 1 of print(_:separator:terminator:)
  %18 = function_ref @$ss5print_9separator10terminatoryypd_S2StFfA0_ : $@convention(thin) () -> @owned String // user: %19
  %19 = apply %18() : $@convention(thin) () -> @owned String // users: %25, %23
  // function_ref default argument 2 of print(_:separator:terminator:)
  %20 = function_ref @$ss5print_9separator10terminatoryypd_S2StFfA1_ : $@convention(thin) () -> @owned String // user: %21
  %21 = apply %20() : $@convention(thin) () -> @owned String // users: %24, %23
  // function_ref print(_:separator:terminator:)
  %22 = function_ref @$ss5print_9separator10terminatoryypd_S2StF : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> () // user: %23
  %23 = apply %22(%17, %19, %21) : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> ()
  destroy_value %21 : $String                     // id: %24
  destroy_value %19 : $String                     // id: %25
  destroy_value %17 : $Array<Any>                 // id: %26
  %27 = tuple ()                                  // user: %28
  return %27 : $()                                // id: %28
} // end sil function '$s8dispatch9ProtocolAPAAE5test1yyF'

// _allocateUninitializedArray<A>(_:)
sil [serialized] [always_inline] [_semantics "array.uninitialized_intrinsic"] @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer)

// String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
sil [serialized] [always_inline] [readonly] [_semantics "string.makeUTF8"] @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String

// _finalizeUninitializedArray<A>(_:)
sil hidden_external [serialized] [readnone] [_semantics "array.finalize_intrinsic"] @$ss27_finalizeUninitializedArrayySayxGABnlF : $@convention(thin) <τ_0_0> (@owned Array<τ_0_0>) -> @owned Array<τ_0_0> {
[%0: escape! v** => %r.v**, escape! v**.c*.v** => %r.v**.c*.v**]
} // end sil function '$ss27_finalizeUninitializedArrayySayxGABnlF'

// default argument 1 of print(_:separator:terminator:)
sil hidden_external [serialized] @$ss5print_9separator10terminatoryypd_S2StFfA0_ : $@convention(thin) () -> @owned String

// default argument 2 of print(_:separator:terminator:)
sil hidden_external [serialized] @$ss5print_9separator10terminatoryypd_S2StFfA1_ : $@convention(thin) () -> @owned String

// print(_:separator:terminator:)
sil @$ss5print_9separator10terminatoryypd_S2StF : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> ()

// StructB.init()
sil hidden [ossa] @$s8dispatch7StructBVACycfC : $@convention(method) (@thin StructB.Type) -> StructB {
// %0 "$metatype"
bb0(%0 : $@thin StructB.Type):
  %1 = alloc_box ${ var StructB }, var, name "self" // user: %2
  %2 = mark_uninitialized [rootself] %1 : ${ var StructB } // users: %5, %3
  %3 = project_box %2 : ${ var StructB }, 0       // user: %4
  %4 = load [trivial] %3 : $*StructB              // user: %6
  destroy_value %2 : ${ var StructB }             // id: %5
  return %4 : $StructB                            // id: %6
} // end sil function '$s8dispatch7StructBVACycfC'

// StructB.test1()
sil hidden [ossa] @$s8dispatch7StructBV5test1yyF : $@convention(method) (StructB) -> () {
// %0 "self"                                      // user: %1
bb0(%0 : $StructB):
  debug_value %0 : $StructB, let, name "self", argno 1, implicit // id: %1
  %2 = integer_literal $Builtin.Word, 1           // user: %4
  // function_ref _allocateUninitializedArray<A>(_:)
  %3 = function_ref @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %4
  %4 = apply %3<Any>(%2) : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %5
  (%5, %6) = destructure_tuple %4 : $(Array<Any>, Builtin.RawPointer) // users: %17, %7
  %7 = pointer_to_address %6 : $Builtin.RawPointer to [strict] $*Any // user: %14
  %8 = string_literal utf8 "StructB  - test1"     // user: %13
  %9 = integer_literal $Builtin.Word, 16          // user: %13
  %10 = integer_literal $Builtin.Int1, -1         // user: %13
  %11 = metatype $@thin String.Type               // user: %13
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %12 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %13
  %13 = apply %12(%8, %9, %10, %11) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %15
  %14 = init_existential_addr %7 : $*Any, $String // user: %15
  store %13 to [init] %14 : $*String              // id: %15
  // function_ref _finalizeUninitializedArray<A>(_:)
  %16 = function_ref @$ss27_finalizeUninitializedArrayySayxGABnlF : $@convention(thin) <τ_0_0> (@owned Array<τ_0_0>) -> @owned Array<τ_0_0> // user: %17
  %17 = apply %16<Any>(%5) : $@convention(thin) <τ_0_0> (@owned Array<τ_0_0>) -> @owned Array<τ_0_0> // users: %26, %23
  // function_ref default argument 1 of print(_:separator:terminator:)
  %18 = function_ref @$ss5print_9separator10terminatoryypd_S2StFfA0_ : $@convention(thin) () -> @owned String // user: %19
  %19 = apply %18() : $@convention(thin) () -> @owned String // users: %25, %23
  // function_ref default argument 2 of print(_:separator:terminator:)
  %20 = function_ref @$ss5print_9separator10terminatoryypd_S2StFfA1_ : $@convention(thin) () -> @owned String // user: %21
  %21 = apply %20() : $@convention(thin) () -> @owned String // users: %24, %23
  // function_ref print(_:separator:terminator:)
  %22 = function_ref @$ss5print_9separator10terminatoryypd_S2StF : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> () // user: %23
  %23 = apply %22(%17, %19, %21) : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> ()
  destroy_value %21 : $String                     // id: %24
  destroy_value %19 : $String                     // id: %25
  destroy_value %17 : $Array<Any>                 // id: %26
  %27 = tuple ()                                  // user: %28
  return %27 : $()                                // id: %28
} // end sil function '$s8dispatch7StructBV5test1yyF'

sil_witness_table hidden StructB: ProtocolA module dispatch {
}



// Mappings from '#fileID' to '#filePath':
//   'dispatch/FuncDispatch.swift' => 'FuncDispatch.swift'


