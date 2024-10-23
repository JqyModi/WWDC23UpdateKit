sil_stage canonical

import Builtin
import Swift
import SwiftShims

protocol SoundMaking {
  func makeSound()
}

class Dog : SoundMaking {
  func makeSound()
  @objc deinit
  init()
}

func playSound<T>(_ animal: T) where T : SoundMaking

@_hasStorage @_hasInitialValue let dog: Dog { get }

// dog
sil_global hidden [let] @$s21WitnessPatch_SIL_NotT3dogAA3DogCvp : $Dog

// main
sil @main : $@convention(c) (Int32, UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>) -> Int32 {
bb0(%0 : $Int32, %1 : $UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>):
  alloc_global @$s21WitnessPatch_SIL_NotT3dogAA3DogCvp // id: %2
  %3 = global_addr @$s21WitnessPatch_SIL_NotT3dogAA3DogCvp : $*Dog // users: %8, %7
  %4 = metatype $@thick Dog.Type                  // user: %6
  // function_ref Dog.__allocating_init()
  %5 = function_ref @$s21WitnessPatch_SIL_NotT3DogCACycfC : $@convention(method) (@thick Dog.Type) -> @owned Dog // user: %6
  %6 = apply %5(%4) : $@convention(method) (@thick Dog.Type) -> @owned Dog // user: %7
  store %6 to %3 : $*Dog                          // id: %7
  %8 = load %3 : $*Dog                            // user: %10
  %9 = alloc_stack $Dog                           // users: %12, %10, %13
  store %8 to %9 : $*Dog                          // id: %10
  // function_ref playSound<A>(_:)
  %11 = function_ref @$s21WitnessPatch_SIL_NotT9playSoundyyxAA0F6MakingRzlF : $@convention(thin) <τ_0_0 where τ_0_0 : SoundMaking> (@in_guaranteed τ_0_0) -> () // user: %12
  %12 = apply %11<Dog>(%9) : $@convention(thin) <τ_0_0 where τ_0_0 : SoundMaking> (@in_guaranteed τ_0_0) -> ()
  dealloc_stack %9 : $*Dog                        // id: %13
  %14 = integer_literal $Builtin.Int32, 0         // user: %15
  %15 = struct $Int32 (%14 : $Builtin.Int32)      // user: %16
  return %15 : $Int32                             // id: %16
} // end sil function 'main'

// Dog.makeSound()
sil hidden @$s21WitnessPatch_SIL_NotT3DogC9makeSoundyyF : $@convention(method) (@guaranteed Dog) -> () {
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
} // end sil function '$s21WitnessPatch_SIL_NotT3DogC9makeSoundyyF'

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

// Dog.deinit
sil hidden @$s21WitnessPatch_SIL_NotT3DogCfd : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  %2 = unchecked_ref_cast %0 : $Dog to $Builtin.NativeObject // user: %3
  return %2 : $Builtin.NativeObject               // id: %3
} // end sil function '$s21WitnessPatch_SIL_NotT3DogCfd'

// Dog.__deallocating_deinit
sil hidden @$s21WitnessPatch_SIL_NotT3DogCfD : $@convention(method) (@owned Dog) -> () {
// %0 "self"                                      // users: %3, %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  // function_ref Dog.deinit
  %2 = function_ref @$s21WitnessPatch_SIL_NotT3DogCfd : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject // user: %3
  %3 = apply %2(%0) : $@convention(method) (@guaranteed Dog) -> @owned Builtin.NativeObject // user: %4
  %4 = unchecked_ref_cast %3 : $Builtin.NativeObject to $Dog // user: %5
  dealloc_ref %4 : $Dog                           // id: %5
  %6 = tuple ()                                   // user: %7
  return %6 : $()                                 // id: %7
} // end sil function '$s21WitnessPatch_SIL_NotT3DogCfD'

// Dog.__allocating_init()
sil hidden [exact_self_class] @$s21WitnessPatch_SIL_NotT3DogCACycfC : $@convention(method) (@thick Dog.Type) -> @owned Dog {
// %0 "$metatype"
bb0(%0 : $@thick Dog.Type):
  %1 = alloc_ref $Dog                             // user: %3
  // function_ref Dog.init()
  %2 = function_ref @$s21WitnessPatch_SIL_NotT3DogCACycfc : $@convention(method) (@owned Dog) -> @owned Dog // user: %3
  %3 = apply %2(%1) : $@convention(method) (@owned Dog) -> @owned Dog // user: %4
  return %3 : $Dog                                // id: %4
} // end sil function '$s21WitnessPatch_SIL_NotT3DogCACycfC'

// Dog.init()
sil hidden @$s21WitnessPatch_SIL_NotT3DogCACycfc : $@convention(method) (@owned Dog) -> @owned Dog {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Dog):
  debug_value %0 : $Dog, let, name "self", argno 1, implicit // id: %1
  return %0 : $Dog                                // id: %2
} // end sil function '$s21WitnessPatch_SIL_NotT3DogCACycfc'

// protocol witness for SoundMaking.makeSound() in conformance Dog
sil private [transparent] [thunk] @$s21WitnessPatch_SIL_NotT3DogCAA11SoundMakingA2aDP04makeF0yyFTW : $@convention(witness_method: SoundMaking) (@in_guaranteed Dog) -> () {
// %0                                             // user: %1
bb0(%0 : $*Dog):
  %1 = load %0 : $*Dog                            // users: %2, %3
  %2 = class_method %1 : $Dog, #Dog.makeSound : (Dog) -> () -> (), $@convention(method) (@guaranteed Dog) -> () // user: %3
  %3 = apply %2(%1) : $@convention(method) (@guaranteed Dog) -> ()
  %4 = tuple ()                                   // user: %5
  return %4 : $()                                 // id: %5
} // end sil function '$s21WitnessPatch_SIL_NotT3DogCAA11SoundMakingA2aDP04makeF0yyFTW'

// playSound<A>(_:)
sil hidden @$s21WitnessPatch_SIL_NotT9playSoundyyxAA0F6MakingRzlF : $@convention(thin) <T where T : SoundMaking> (@in_guaranteed T) -> () {
// %0 "animal"                                    // users: %3, %1
bb0(%0 : $*T):
  debug_value %0 : $*T, let, name "animal", argno 1, expr op_deref // id: %1
  %2 = witness_method $T, #SoundMaking.makeSound : <Self where Self : SoundMaking> (Self) -> () -> () : $@convention(witness_method: SoundMaking) <τ_0_0 where τ_0_0 : SoundMaking> (@in_guaranteed τ_0_0) -> () // user: %3
  %3 = apply %2<T>(%0) : $@convention(witness_method: SoundMaking) <τ_0_0 where τ_0_0 : SoundMaking> (@in_guaranteed τ_0_0) -> ()
  %4 = tuple ()                                   // user: %5
  return %4 : $()                                 // id: %5
} // end sil function '$s21WitnessPatch_SIL_NotT9playSoundyyxAA0F6MakingRzlF'

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

sil_vtable Dog {
  #Dog.makeSound: (Dog) -> () -> () : @$s21WitnessPatch_SIL_NotT3DogC9makeSoundyyF	// Dog.makeSound()
  #Dog.init!allocator: (Dog.Type) -> () -> Dog : @$s21WitnessPatch_SIL_NotT3DogCACycfC	// Dog.__allocating_init()
  #Dog.deinit!deallocator: @$s21WitnessPatch_SIL_NotT3DogCfD	// Dog.__deallocating_deinit
}

sil_witness_table hidden Dog: SoundMaking module WitnessPatch_SIL_NotT {
  method #SoundMaking.makeSound: <Self where Self : SoundMaking> (Self) -> () -> () : @$s21WitnessPatch_SIL_NotT3DogCAA11SoundMakingA2aDP04makeF0yyFTW	// protocol witness for SoundMaking.makeSound() in conformance Dog
}



// Mappings from '#fileID' to '#filePath':
//   'WitnessPatch_SIL_NotT/WitnessPatch.swift' => 'WitnessPatch.swift'


