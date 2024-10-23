sil_stage canonical

import Builtin
import Swift
import SwiftShims

import Foundation

@_inheritsConvenienceInitializers @objc class Animal : NSObject {
  @objc func makeSound()
  dynamic func makeCookie()
  @objc dynamic func makeSleep()
  override dynamic init()
  @objc deinit
}

@_hasStorage @_hasInitialValue let animal: Animal { get }

// animal
sil_global hidden [let] @$s12MsgPatch_SIL6animalAA6AnimalCvp : $Animal

// main
sil @main : $@convention(c) (Int32, UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>) -> Int32 {
bb0(%0 : $Int32, %1 : $UnsafeMutablePointer<Optional<UnsafeMutablePointer<Int8>>>):
  alloc_global @$s12MsgPatch_SIL6animalAA6AnimalCvp // id: %2
  %3 = global_addr @$s12MsgPatch_SIL6animalAA6AnimalCvp : $*Animal // users: %14, %11, %8, %7
  %4 = metatype $@thick Animal.Type               // user: %6
  // function_ref Animal.__allocating_init()
  %5 = function_ref @$s12MsgPatch_SIL6AnimalCACycfC : $@convention(method) (@thick Animal.Type) -> @owned Animal // user: %6
  %6 = apply %5(%4) : $@convention(method) (@thick Animal.Type) -> @owned Animal // user: %7
  store %6 to %3 : $*Animal                       // id: %7
  %8 = load %3 : $*Animal                         // users: %9, %10
  %9 = class_method %8 : $Animal, #Animal.makeSound : (Animal) -> () -> (), $@convention(method) (@guaranteed Animal) -> () // user: %10
  %10 = apply %9(%8) : $@convention(method) (@guaranteed Animal) -> ()
  %11 = load %3 : $*Animal                        // users: %12, %13
  %12 = class_method %11 : $Animal, #Animal.makeCookie : (Animal) -> () -> (), $@convention(method) (@guaranteed Animal) -> () // user: %13
  %13 = apply %12(%11) : $@convention(method) (@guaranteed Animal) -> ()
  %14 = load %3 : $*Animal                        // users: %15, %16
  %15 = objc_method %14 : $Animal, #Animal.makeSleep!foreign : (Animal) -> () -> (), $@convention(objc_method) (Animal) -> () // user: %16
  %16 = apply %15(%14) : $@convention(objc_method) (Animal) -> ()
  %17 = integer_literal $Builtin.Int32, 0         // user: %18
  %18 = struct $Int32 (%17 : $Builtin.Int32)      // user: %19
  return %18 : $Int32                             // id: %19
} // end sil function 'main'

// Animal.makeSound()
sil hidden @$s12MsgPatch_SIL6AnimalC9makeSoundyyF : $@convention(method) (@guaranteed Animal) -> () {
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
} // end sil function '$s12MsgPatch_SIL6AnimalC9makeSoundyyF'

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

// @objc Animal.makeSound()
sil private [thunk] @$s12MsgPatch_SIL6AnimalC9makeSoundyyFTo : $@convention(objc_method) (Animal) -> () {
// %0                                             // users: %4, %3, %1
bb0(%0 : $Animal):
  strong_retain %0 : $Animal                      // id: %1
  // function_ref Animal.makeSound()
  %2 = function_ref @$s12MsgPatch_SIL6AnimalC9makeSoundyyF : $@convention(method) (@guaranteed Animal) -> () // user: %3
  %3 = apply %2(%0) : $@convention(method) (@guaranteed Animal) -> () // user: %5
  strong_release %0 : $Animal                     // id: %4
  return %3 : $()                                 // id: %5
} // end sil function '$s12MsgPatch_SIL6AnimalC9makeSoundyyFTo'

// Animal.makeCookie()
sil hidden [dynamically_replacable] @$s12MsgPatch_SIL6AnimalC10makeCookieyyF : $@convention(method) (@guaranteed Animal) -> () {
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
} // end sil function '$s12MsgPatch_SIL6AnimalC10makeCookieyyF'

// Animal.makeSleep()
sil hidden @$s12MsgPatch_SIL6AnimalC9makeSleepyyF : $@convention(method) (@guaranteed Animal) -> () {
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
} // end sil function '$s12MsgPatch_SIL6AnimalC9makeSleepyyF'

// @objc Animal.makeSleep()
sil private [thunk] @$s12MsgPatch_SIL6AnimalC9makeSleepyyFTo : $@convention(objc_method) (Animal) -> () {
// %0                                             // users: %4, %3, %1
bb0(%0 : $Animal):
  strong_retain %0 : $Animal                      // id: %1
  // function_ref Animal.makeSleep()
  %2 = function_ref @$s12MsgPatch_SIL6AnimalC9makeSleepyyF : $@convention(method) (@guaranteed Animal) -> () // user: %3
  %3 = apply %2(%0) : $@convention(method) (@guaranteed Animal) -> () // user: %5
  strong_release %0 : $Animal                     // id: %4
  return %3 : $()                                 // id: %5
} // end sil function '$s12MsgPatch_SIL6AnimalC9makeSleepyyFTo'

// Animal.__allocating_init()
sil hidden @$s12MsgPatch_SIL6AnimalCACycfC : $@convention(method) (@thick Animal.Type) -> @owned Animal {
// %0 "$metatype"                                 // user: %1
bb0(%0 : $@thick Animal.Type):
  %1 = thick_to_objc_metatype %0 : $@thick Animal.Type to $@objc_metatype Animal.Type // user: %2
  %2 = alloc_ref_dynamic [objc] %1 : $@objc_metatype Animal.Type, $Animal // users: %3, %4
  %3 = objc_method %2 : $Animal, #Animal.init!initializer.foreign : (Animal.Type) -> () -> Animal, $@convention(objc_method) (@owned Animal) -> @owned Animal // user: %4
  %4 = apply %3(%2) : $@convention(objc_method) (@owned Animal) -> @owned Animal // user: %5
  return %4 : $Animal                             // id: %5
} // end sil function '$s12MsgPatch_SIL6AnimalCACycfC'

// dynamic Animal.init()
sil shared [transparent] [thunk] @$s12MsgPatch_SIL6AnimalCACycfcTD : $@convention(method) (@owned Animal) -> @owned Animal {
// %0 "self"                                      // users: %2, %1
bb0(%0 : $Animal):
  %1 = objc_method %0 : $Animal, #Animal.init!initializer.foreign : (Animal.Type) -> () -> Animal, $@convention(objc_method) (@owned Animal) -> @owned Animal // user: %2
  %2 = apply %1(%0) : $@convention(objc_method) (@owned Animal) -> @owned Animal // user: %3
  return %2 : $Animal                             // id: %3
} // end sil function '$s12MsgPatch_SIL6AnimalCACycfcTD'

// Animal.init()
sil hidden @$s12MsgPatch_SIL6AnimalCACycfc : $@convention(method) (@owned Animal) -> @owned Animal {
// %0 "self"                                      // user: %2
bb0(%0 : $Animal):
  %1 = alloc_stack [lexical] $Animal, let, name "self", implicit // users: %10, %3, %2, %11, %12
  store %0 to %1 : $*Animal                       // id: %2
  %3 = load %1 : $*Animal                         // user: %4
  %4 = upcast %3 : $Animal to $NSObject           // users: %5, %7
  %5 = unchecked_ref_cast %4 : $NSObject to $Animal // user: %6
  %6 = objc_super_method %5 : $Animal, #NSObject.init!initializer.foreign : (NSObject.Type) -> () -> NSObject, $@convention(objc_method) (@owned NSObject) -> @owned NSObject // user: %7
  %7 = apply %6(%4) : $@convention(objc_method) (@owned NSObject) -> @owned NSObject // user: %8
  %8 = unchecked_ref_cast %7 : $NSObject to $Animal // users: %10, %13, %9
  strong_retain %8 : $Animal                      // id: %9
  store %8 to %1 : $*Animal                       // id: %10
  destroy_addr %1 : $*Animal                      // id: %11
  dealloc_stack %1 : $*Animal                     // id: %12
  return %8 : $Animal                             // id: %13
} // end sil function '$s12MsgPatch_SIL6AnimalCACycfc'

// @objc Animal.init()
sil private [thunk] @$s12MsgPatch_SIL6AnimalCACycfcTo : $@convention(objc_method) (@owned Animal) -> @owned Animal {
// %0                                             // user: %2
bb0(%0 : $Animal):
  // function_ref Animal.init()
  %1 = function_ref @$s12MsgPatch_SIL6AnimalCACycfc : $@convention(method) (@owned Animal) -> @owned Animal // user: %2
  %2 = apply %1(%0) : $@convention(method) (@owned Animal) -> @owned Animal // user: %3
  return %2 : $Animal                             // id: %3
} // end sil function '$s12MsgPatch_SIL6AnimalCACycfcTo'

// Animal.__deallocating_deinit
sil hidden @$s12MsgPatch_SIL6AnimalCfD : $@convention(method) (@owned Animal) -> () {
// %0 "self"                                      // users: %3, %2, %1
bb0(%0 : $Animal):
  debug_value %0 : $Animal, let, name "self", argno 1, implicit // id: %1
  %2 = objc_super_method %0 : $Animal, #NSObject.deinit!deallocator.foreign : (NSObject) -> () -> (), $@convention(objc_method) (NSObject) -> () // user: %4
  %3 = upcast %0 : $Animal to $NSObject           // user: %4
  %4 = apply %2(%3) : $@convention(objc_method) (NSObject) -> ()
  %5 = tuple ()                                   // user: %6
  return %5 : $()                                 // id: %6
} // end sil function '$s12MsgPatch_SIL6AnimalCfD'

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
  #Animal.makeSound: (Animal) -> () -> () : @$s12MsgPatch_SIL6AnimalC9makeSoundyyF	// Animal.makeSound()
  #Animal.makeCookie: (Animal) -> () -> () : @$s12MsgPatch_SIL6AnimalC10makeCookieyyF	// Animal.makeCookie()
  #Animal.deinit!deallocator: @$s12MsgPatch_SIL6AnimalCfD	// Animal.__deallocating_deinit
}



// Mappings from '#fileID' to '#filePath':
//   'MsgPatch_SIL/MsgPatch.swift' => 'MsgPatch.swift'


