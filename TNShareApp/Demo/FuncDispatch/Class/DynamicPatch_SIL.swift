sil_stage canonical

import Builtin
import Swift
import SwiftShims

class Animal {
  func makeSound()
  @objc deinit
  init()
}

@_inheritsConvenienceInitializers class Dog : Animal {
  override func makeSound()
  override init()
  @objc deinit
}

@_hasStorage @_hasInitialValue let animal: Animal { get }

// animal
sil_global hidden [let] @$s16DynamicPatch_SIL6animalAA6AnimalCvp : $Animal

// main
sil @main : $@convention(c) (Int32, UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>) -> Int32 {
bb0(%0 : $Int32, %1 : $UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>):
  alloc_global @$s16DynamicPatch_SIL6animalAA6AnimalCvp // id: %2
  %3 = global_addr @$s16DynamicPatch_SIL6animalAA6AnimalCvp : $*Animal // users: %9, %8
  %4 = metatype $@thick Dog.Type                  // user: %6
  // function_ref Dog.__allocating_init()
  %5 = function_ref @$s16DynamicPatch_SIL3DogCACycfC : $@convention(method) (@thick Dog.Type) -> @owned Dog // user: %6
  %6 = apply %5(%4) : $@convention(method) (@thick Dog.Type) -> @owned Dog // user: %7
  %7 = upcast %6 : $Dog to $Animal                // user: %8
  store %7 to %3 : $*Animal                       // id: %8
  %9 = load %3 : $*Animal                         // users: %10, %11
  %10 = class_method %9 : $Animal, #Animal.makeSound : (Animal) -> () -> (), $@convention(method) (@guaranteed Animal) -> () // user: %11
  %11 = apply %10(%9) : $@convention(method) (@guaranteed Animal) -> ()
  %12 = integer_literal $Builtin.Int32, 0         // user: %13
  %13 = struct $Int32 (%12 : $Builtin.Int32)      // user: %14
  return %13 : $Int32                             // id: %14
} // end sil function 'main'

// Animal.makeSound()
sil hidden @$s16DynamicPatch_SIL6AnimalC9makeSoundyyF : $@convention(method) (@guaranteed Animal) -> () {
// %0 "self"                                      // user: %1
bb0(%0 : $Animal):
  debug_value %0 : $Animal, let, name "self", argno 1, implicit // id: %1
  %2 = integer_literal $Builtin.Word, 1           // user: %4
  // function_ref _allocateUninitializedArray<A>(_:)
  %3 = function_ref @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %4
  %4 = apply %3<Any>(%2) : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // users: %6, %5
  %5 = tuple_extract %4 : $(Array<Any>, Builtin.RawPointer), 0 // user: %17
  %6 = tuple_extract %4 : $(Array<Any>, Builtin.RawPointer), 1 // user: %7
  %7 = pointer_to_address %6 : $Builtin.RawPointer to [strict] $*Any // user: %14
  %8 = string_literal utf8 "Animal sound"         // user: %13
  %9 = integer_literal $Builtin.Word, 12          // user: %13
  %10 = integer_literal $Builtin.Int1, -1         // user: %13
  %11 = metatype $@thin String.Type               // user: %13
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %12 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %13
  %13 = apply %12(%8, %9, %10, %11) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %15
  %14 = init_existential_addr %7 : $*Any, $String // user: %15
  store %13 to %14 : $*String                     // id: %15
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
  release_value %21 : $String                     // id: %24
  release_value %19 : $String                     // id: %25
  release_value %17 : $Array<Any>                 // id: %26
  %27 = tuple ()                                  // user: %28
  return %27 : $()                                // id: %28
} // end sil function '$s16DynamicPatch_SIL6AnimalC9makeSoundyyF'

// _allocateUninitializedArray<A>(_:)
sil [always_inline] [_semantics "array.uninitialized_intrinsic"] @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer)

// String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
sil [always_inline] [readonly] [_semantics "string.makeUTF8"] @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String

// _finalizeUninitializedArray<A>(_:)
sil shared [readnone] [_semantics "array.finalize_intrinsic"] @$ss27_finalizeUninitializedArrayySayxGABnlF : $@convention(thin) <Element> (@owned Array<Element>) -> @owned Array<Element> {
[%0: escape! v** => %r.v**, escape! v**.c*.v** => %r.v**.c*.v**]
// %0                                             // user: %2
bb0(%0 : $Array<Element>):
  %1 = alloc_stack $Array<Element>                // users: %6, %5, %4, %2
  store %0 to %1 : $*Array<Element>               // id: %2
  // function_ref Array._endMutation()
  %3 = function_ref @$sSa12_endMutationyyF : $@convention(method) <τ_0_0> (@inout Array<τ_0_0>) -> () // user: %4
  %4 = apply %3<Element>(%1) : $@convention(method) <τ_0_0> (@inout Array<τ_0_0>) -> ()
  %5 = load %1 : $*Array<Element>                 // user: %7
  dealloc_stack %1 : $*Array<Element>             // id: %6
  return %5 : $Array<Element>                     // id: %7
} // end sil function '$ss27_finalizeUninitializedArrayySayxGABnlF'

// default argument 1 of print(_:separator:terminator:)
sil shared @$ss5print_9separator10terminatoryypd_S2StFfA0_ : $@convention(thin) () -> @owned String {
bb0:
  %0 = string_literal utf8 " "                    // user: %5
  %1 = integer_literal $Builtin.Word, 1           // user: %5
  %2 = integer_literal $Builtin.Int1, -1          // user: %5
  %3 = metatype $@thin String.Type                // user: %5
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %4 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %5
  %5 = apply %4(%0, %1, %2, %3) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %6
  return %5 : $String                             // id: %6
} // end sil function '$ss5print_9separator10terminatoryypd_S2StFfA0_'

// default argument 2 of print(_:separator:terminator:)
sil shared @$ss5print_9separator10terminatoryypd_S2StFfA1_ : $@convention(thin) () -> @owned String {
bb0:
  %0 = string_literal utf8 "\n"                   // user: %5
  %1 = integer_literal $Builtin.Word, 1           // user: %5
  %2 = integer_literal $Builtin.Int1, -1          // user: %5
  %3 = metatype $@thin String.Type                // user: %5
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %4 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %5
  %5 = apply %4(%0, %1, %2, %3) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %6
  return %5 : $String                             // id: %6
} // end sil function '$ss5print_9separator10terminatoryypd_S2StFfA1_'

// print(_:separator:terminator:)
sil @$ss5print_9separator10terminatoryypd_S2StF : $@convention(thin) (@guaranteed Array<Any>, @guaranteed String, @guaranteed String) -> ()

// Animal.deinit
sil hidden @$s16DynamicPatch_SIL6AnimalCfd : $@convention(method) (@guaranteed Animal) -> @owned Builtin.NativeObject {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Animal):
  debug_value %0 : $Animal, let, name "self", argno 1, implicit // id: %1
  %2 = unchecked_ref_cast %0 : $Animal to $Builtin.NativeObject // user: %3
  return %2 : $Builtin.NativeObject               // id: %3
} // end sil function '$s16DynamicPatch_SIL6AnimalCfd'

// Animal.__deallocating_deinit
sil hidden @$s16DynamicPatch_SIL6AnimalCfD : $@convention(method) (@owned Animal) -> () {
// %0 "self"                                      // users: %3, %1
bb0(%0 : $Animal):
  debug_value %0 : $Animal, let, name "self", argno 1, implicit // id: %1
  // function_ref Animal.deinit
  %2 = function_ref @$s16DynamicPatch_SIL6AnimalCfd : $@convention(method) (@guaranteed Animal) -> @owned Builtin.NativeObject // user: %3
  %3 = apply %2(%0) : $@convention(method) (@guaranteed Animal) -> @owned Builtin.NativeObject // user: %4
  %4 = unchecked_ref_cast %3 : $Builtin.NativeObject to $Animal // user: %5
  dealloc_ref %4 : $Animal                        // id: %5
  %6 = tuple ()                                   // user: %7
  return %6 : $()                                 // id: %7
} // end sil function '$s16DynamicPatch_SIL6AnimalCfD'

// Animal.__allocating_init()
sil hidden [exact_self_class] @$s16DynamicPatch_SIL6AnimalCACycfC : $@convention(method) (@thick Animal.Type) -> @owned Animal {
// %0 "$metatype"
bb0(%0 : $@thick Animal.Type):
  %1 = alloc_ref $Animal                          // user: %3
  // function_ref Animal.init()
  %2 = function_ref @$s16DynamicPatch_SIL6AnimalCACycfc : $@convention(method) (@owned Animal) -> @owned Animal // user: %3
  %3 = apply %2(%1) : $@convention(method) (@owned Animal) -> @owned Animal // user: %4
  return %3 : $Animal                             // id: %4
} // end sil function '$s16DynamicPatch_SIL6AnimalCACycfC'

// Animal.init()
sil hidden @$s16DynamicPatch_SIL6AnimalCACycfc : $@convention(method) (@owned Animal) -> @owned Animal {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Animal):
  debug_value %0 : $Animal, let, name "self", argno 1, implicit // id: %1
  return %0 : $Animal                             // id: %2
} // end sil function '$s16DynamicPatch_SIL6AnimalCACycfc'

// Dog.makeSound()
sil hidden @$s16DynamicPatch_SIL3DogC9makeSoundyyF : $@convention(method) (@guaranteed Dog) -> () {
// %0 "self"                                      // user: %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  %2 = integer_literal $Builtin.Word, 1           // user: %4
  // function_ref _allocateUninitializedArray<A>(_:)
  %3 = function_ref @$ss27_allocateUninitializedArrayySayxG_BptBwlF : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // user: %4
  %4 = apply %3<Any>(%2) : $@convention(thin) <τ_0_0> (Builtin.Word) -> (@owned Array<τ_0_0>, Builtin.RawPointer) // users: %6, %5
  %5 = tuple_extract %4 : $(Array<Any>, Builtin.RawPointer), 0 // user: %17
  %6 = tuple_extract %4 : $(Array<Any>, Builtin.RawPointer), 1 // user: %7
  %7 = pointer_to_address %6 : $Builtin.RawPointer to [strict] $*Any // user: %14
  %8 = string_literal utf8 "Bark"                 // user: %13
  %9 = integer_literal $Builtin.Word, 4           // user: %13
  %10 = integer_literal $Builtin.Int1, -1         // user: %13
  %11 = metatype $@thin String.Type               // user: %13
  // function_ref String.init(_builtinStringLiteral:utf8CodeUnitCount:isASCII:)
  %12 = function_ref @$sSS21_builtinStringLiteral17utf8CodeUnitCount7isASCIISSBp_BwBi1_tcfC : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %13
  %13 = apply %12(%8, %9, %10, %11) : $@convention(method) (Builtin.RawPointer, Builtin.Word, Builtin.Int1, @thin String.Type) -> @owned String // user: %15
  %14 = init_existential_addr %7 : $*Any, $String // user: %15
  store %13 to %14 : $*String                     // id: %15
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
  release_value %21 : $String                     // id: %24
  release_value %19 : $String                     // id: %25
  release_value %17 : $Array<Any>                 // id: %26
  %27 = tuple ()                                  // user: %28
  return %27 : $()                                // id: %28
} // end sil function '$s16DynamicPatch_SIL3DogC9makeSoundyyF'

// Dog.__allocating_init()
sil hidden [exact_self_class] @$s16DynamicPatch_SIL3DogCACycfC : $@convention(method) (@thick Dog.Type) -> @owned Dog {
// %0 "$metatype"
bb0(%0 : $@thick Dog.Type):
  %1 = alloc_ref $Dog                             // user: %3
  // function_ref Dog.init()
  %2 = function_ref @$s16DynamicPatch_SIL3DogCACycfc : $@convention(method) (@owned Dog) -> @owned Dog // user: %3
  %3 = apply %2(%1) : $@convention(method) (@owned Dog) -> @owned Dog // user: %4
  return %3 : $Dog                                // id: %4
} // end sil function '$s16DynamicPatch_SIL3DogCACycfC'

// Dog.init()
sil hidden @$s16DynamicPatch_SIL3DogCACycfc : $@convention(method) (@owned Dog) -> @owned Dog {
// %0 "self"                                      // user: %2
bb0(%0 : $Dog):
  %1 = alloc_stack [lexical] $Dog, let, name "self", implicit // users: %9, %3, %2, %10, %11
  store %0 to %1 : $*Dog                          // id: %2
  %3 = load %1 : $*Dog                            // user: %4
  %4 = upcast %3 : $Dog to $Animal                // user: %6
  // function_ref Animal.init()
  %5 = function_ref @$s16DynamicPatch_SIL6AnimalCACycfc : $@convention(method) (@owned Animal) -> @owned Animal // user: %6
  %6 = apply %5(%4) : $@convention(method) (@owned Animal) -> @owned Animal // user: %7
  %7 = unchecked_ref_cast %6 : $Animal to $Dog    // users: %9, %12, %8
  strong_retain %7 : $Dog                         // id: %8
  store %7 to %1 : $*Dog                          // id: %9
  destroy_addr %1 : $*Dog                         // id: %10
  dealloc_stack %1 : $*Dog                        // id: %11
  return %7 : $Dog                                // id: %12
} // end sil function '$s16DynamicPatch_SIL3DogCACycfc'

// Dog.deinit
sil hidden @$s16DynamicPatch_SIL3DogCfd : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  %2 = upcast %0 : $Dog to $Animal                // user: %4
  // function_ref Animal.deinit
  %3 = function_ref @$s16DynamicPatch_SIL6AnimalCfd : $@convention(method) (@guaranteed Animal) -> @owned Builtin.NativeObject // user: %4
  %4 = apply %3(%2) : $@convention(method) (@guaranteed Animal) -> @owned Builtin.NativeObject // user: %5
  return %4 : $Builtin.NativeObject               // id: %5
} // end sil function '$s16DynamicPatch_SIL3DogCfd'

// Dog.__deallocating_deinit
sil hidden @$s16DynamicPatch_SIL3DogCfD : $@convention(method) (@owned Dog) -> () {
// %0 "self"                                      // users: %3, %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  // function_ref Dog.deinit
  %2 = function_ref @$s16DynamicPatch_SIL3DogCfd : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject // user: %3
  %3 = apply %2(%0) : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject // user: %4
  %4 = unchecked_ref_cast %3 : $Builtin.NativeObject to $Dog // user: %5
  dealloc_ref %4 : $Dog                           // id: %5
  %6 = tuple ()                                   // user: %7
  return %6 : $()                                 // id: %7
} // end sil function '$s16DynamicPatch_SIL3DogCfD'

// Array._endMutation()
sil shared [_semantics "array.end_mutation"] @$sSa12_endMutationyyF : $@convention(method) <Element> (@inout Array<Element>) -> () {
[%0: noescape! **]
// %0                                             // users: %9, %1
bb0(%0 : $*Array<Element>):
  %1 = struct_element_addr %0 : $*Array<Element>, #Array._buffer // user: %2
  %2 = struct_element_addr %1 : $*_ArrayBuffer<Element>, #_ArrayBuffer._storage // user: %3
  %3 = struct_element_addr %2 : $*_BridgeStorage<__ContiguousArrayStorageBase>, #_BridgeStorage.rawValue // user: %4
  %4 = load %3 : $*Builtin.BridgeObject           // user: %5
  %5 = end_cow_mutation %4 : $Builtin.BridgeObject // user: %6
  %6 = struct $_BridgeStorage<__ContiguousArrayStorageBase> (%5 : $Builtin.BridgeObject) // user: %7
  %7 = struct $_ArrayBuffer<Element> (%6 : $_BridgeStorage<__ContiguousArrayStorageBase>) // user: %8
  %8 = struct $Array<Element> (%7 : $_ArrayBuffer<Element>) // user: %9
  store %8 to %0 : $*Array<Element>               // id: %9
  %10 = tuple ()                                  // user: %11
  return %10 : $()                                // id: %11
} // end sil function '$sSa12_endMutationyyF'

sil_vtable Animal {
  #Animal.makeSound: (Animal) -> () -> () : @$s16DynamicPatch_SIL6AnimalC9makeSoundyyF	// Animal.makeSound()
  #Animal.init!allocator: (Animal.Type) -> () -> Animal : @$s16DynamicPatch_SIL6AnimalCACycfC	// Animal.__allocating_init()
  #Animal.deinit!deallocator: @$s16DynamicPatch_SIL6AnimalCfD	// Animal.__deallocating_deinit
}

sil_vtable Dog {
  #Animal.makeSound: (Animal) -> () -> () : @$s16DynamicPatch_SIL3DogC9makeSoundyyF [override]	// Dog.makeSound()
  #Animal.init!allocator: (Animal.Type) -> () -> Animal : @$s16DynamicPatch_SIL3DogCACycfC [override]	// Dog.__allocating_init()
  #Dog.deinit!deallocator: @$s16DynamicPatch_SIL3DogCfD	// Dog.__deallocating_deinit
}



// Mappings from '#fileID' to '#filePath':
//   'DynamicPatch_SIL/DynamicPatch.swift' => 'DynamicPatch.swift'


