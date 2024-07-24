// RUN: %empty-directory(%t)
// RUN: %target-swift-frontend-emit-module -emit-module-path %t/FakeDistributedActorSystems.swiftmodule -module-name FakeDistributedActorSystems %S/../Inputs/FakeDistributedActorSystems.swift
// RUN: %target-build-swift -module-name main %import-libdispatch -j2 -parse-as-library -Xfrontend -disable-availability-checking -I %t %s %S/../Inputs/FakeDistributedActorSystems.swift -g -o %t/a.out
// RUN: %target-codesign %t/a.out
// RUN: %target-run %t/a.out | %FileCheck %s

// REQUIRES: executable_test
// REQUIRES: concurrency
// REQUIRES: distributed
// REQUIRES: libdispatch

// rdar://76038845
// UNSUPPORTED: use_os_stdlib
// UNSUPPORTED: back_deployment_runtime

// FIXME(distributed): Distributed actors currently have some issues on windows rdar://82593574
// UNSUPPORTED: OS=windows-msvc

import Dispatch
import Distributed
import FakeDistributedActorSystems

typealias DefaultDistributedActorSystem = FakeRoundtripActorSystem

@available(SwiftStdlib 5.7, *)
distributed actor Greeter {
  distributed func hello() -> String {
    let any = g(self)
    return "hello"
  }
}

@available(SwiftStdlib 5.7, *)
public func g<DA: DistributedActor>(_ t: isolated DA) -> any Actor {
  return takeIsolatedDistributedActorReturnAsLocalActor(t)
}


@main struct Main {
  static func main() async {
    let system = DefaultDistributedActorSystem()
    let greeter = Greeter(actorSystem: system)

    let greeting = try! await greeter.hello()
    print("OK: \(greeting)")
  }
}

// CHECK: OK: hello

/*

 /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/bin/swift-frontend -frontend -c -primary-file /Users/ktoso/code/swift-project/swift/test/Distributed/Runtime/distributed_actor_to_actor.swift /Users/ktoso/code/swift-project/swift/test/Distributed/Runtime/../Inputs/FakeDistributedActorSystems.swift -emit-module-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.swiftmodule -emit-module-doc-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.swiftdoc -emit-module-source-info-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.swiftsourceinfo -target arm64-apple-macosx10.13 -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -color-diagnostics -I /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -F /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -g -module-cache-path /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/swift-test-results/arm64-apple-macosx10.13/clang-module-cache -swift-version 4 -define-availability "SwiftStdlib 9999:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999" -define-availability "SwiftStdlib 5.0:macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2" -define-availability "SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0" -define-availability "SwiftStdlib 5.2:macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4" -define-availability "SwiftStdlib 5.3:macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0" -define-availability "SwiftStdlib 5.4:macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5" -define-availability "SwiftStdlib 5.5:macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0" -define-availability "SwiftStdlib 5.6:macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4" -define-availability "SwiftStdlib 5.7:macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0" -define-availability "SwiftStdlib 5.8:macOS 13.3, iOS 16.4, watchOS 9.4, tvOS 16.4" -define-availability "SwiftStdlib 5.9:macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0" -define-availability "SwiftStdlib 5.10:macOS 14.4, iOS 17.4, watchOS 10.4, tvOS 17.4, visionOS 1.1" -define-availability "SwiftStdlib 6.0:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999" -disable-availability-checking -enable-anonymous-context-mangled-names -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/host/plugins -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/local/lib/swift/host/plugins -target-sdk-version 14.0 -dwarf-version=4 -parse-as-library -module-name main -o /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.o
 /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/bin/swift-frontend -frontend -c /Users/ktoso/code/swift-project/swift/test/Distributed/Runtime/distributed_actor_to_actor.swift -primary-file /Users/ktoso/code/swift-project/swift/test/Distributed/Runtime/../Inputs/FakeDistributedActorSystems.swift -emit-module-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.swiftmodule -emit-module-doc-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.swiftdoc -emit-module-source-info-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.swiftsourceinfo -target arm64-apple-macosx10.13 -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -color-diagnostics -I /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -F /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -g -module-cache-path /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/swift-test-results/arm64-apple-macosx10.13/clang-module-cache -swift-version 4 -define-availability "SwiftStdlib 9999:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999" -define-availability "SwiftStdlib 5.0:macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2" -define-availability "SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0" -define-availability "SwiftStdlib 5.2:macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4" -define-availability "SwiftStdlib 5.3:macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0" -define-availability "SwiftStdlib 5.4:macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5" -define-availability "SwiftStdlib 5.5:macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0" -define-availability "SwiftStdlib 5.6:macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4" -define-availability "SwiftStdlib 5.7:macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0" -define-availability "SwiftStdlib 5.8:macOS 13.3, iOS 16.4, watchOS 9.4, tvOS 16.4" -define-availability "SwiftStdlib 5.9:macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0" -define-availability "SwiftStdlib 5.10:macOS 14.4, iOS 17.4, watchOS 10.4, tvOS 17.4, visionOS 1.1" -define-availability "SwiftStdlib 6.0:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999" -disable-availability-checking -enable-anonymous-context-mangled-names -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/host/plugins -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/local/lib/swift/host/plugins -target-sdk-version 14.0 -dwarf-version=4 -parse-as-library -module-name main -o /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.o
 /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/bin/swift-frontend -frontend -merge-modules -emit-module /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.swiftmodule /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.swiftmodule -parse-as-library -disable-diagnostic-passes -disable-sil-perf-optzns -target arm64-apple-macosx10.13 -Xllvm -aarch64-use-tbi -enable-objc-interop -sdk /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -color-diagnostics -I /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -F /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -g -module-cache-path /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/swift-test-results/arm64-apple-macosx10.13/clang-module-cache -swift-version 4 -define-availability "SwiftStdlib 9999:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999" -define-availability "SwiftStdlib 5.0:macOS 10.14.4, iOS 12.2, watchOS 5.2, tvOS 12.2" -define-availability "SwiftStdlib 5.1:macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0" -define-availability "SwiftStdlib 5.2:macOS 10.15.4, iOS 13.4, watchOS 6.2, tvOS 13.4" -define-availability "SwiftStdlib 5.3:macOS 11.0, iOS 14.0, watchOS 7.0, tvOS 14.0" -define-availability "SwiftStdlib 5.4:macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5" -define-availability "SwiftStdlib 5.5:macOS 12.0, iOS 15.0, watchOS 8.0, tvOS 15.0" -define-availability "SwiftStdlib 5.6:macOS 12.3, iOS 15.4, watchOS 8.5, tvOS 15.4" -define-availability "SwiftStdlib 5.7:macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0" -define-availability "SwiftStdlib 5.8:macOS 13.3, iOS 16.4, watchOS 9.4, tvOS 16.4" -define-availability "SwiftStdlib 5.9:macOS 14.0, iOS 17.0, watchOS 10.0, tvOS 17.0" -define-availability "SwiftStdlib 5.10:macOS 14.4, iOS 17.4, watchOS 10.4, tvOS 17.4, visionOS 1.1" -define-availability "SwiftStdlib 6.0:macOS 9999, iOS 9999, watchOS 9999, tvOS 9999, visionOS 9999" -disable-availability-checking -enable-anonymous-context-mangled-names -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -external-plugin-path /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/local/lib/swift/host/plugins#/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/usr/bin/swift-plugin-server -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/host/plugins -plugin-path /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/local/lib/swift/host/plugins -target-sdk-version 14.0 -dwarf-version=4 -emit-module-doc-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/main-bbfe55.swiftdoc -emit-module-source-info-path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/main-bbfe55.swiftsourceinfo -module-name main -o /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/main-bbfe55.swiftmodule
 /usr/bin/ld /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.o /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.o -add_ast_path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/main-bbfe55.swiftmodule /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/clang/lib/darwin/libclang_rt.osx.a -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -F /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -syslibroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -lobjc -lSystem -arch arm64 -force_load /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibilityConcurrency.a -force_load /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibility56.a /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibilityPacks.a -L /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx -L /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift -rpath /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx -rpath /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift -platform_version macos 11.0.0 14.0.0 -no_objc_category_merging -rpath /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -rpath /usr/lib/swift -headerpad_max_install_names -rpath /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -o /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp/a.out
 /usr/bin/dsymutil /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp/a.out -o /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp/a.out.dSYM




 /// ------
-> %  /usr/bin/ld /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/distributed_actor_to_actor-93d4b3.o /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/FakeDistributedActorSystems-2b3bf4.o -add_ast_path /var/folders/hn/c22y4jsn4j74mw23_kpgn88w0000gn/T/main-bbfe55.swiftmodule /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/clang/lib/darwin/libclang_rt.osx.a -F /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -F /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -syslibroot /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk -lobjc -lSystem -arch arm64 -force_load /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibilityConcurrency.a -force_load /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibility56.a /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx/libswiftCompatibilityPacks.a -L /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx -L /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift -rpath /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx -rpath /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift -platform_version macos 11.0.0 14.0.0 -no_objc_category_merging -rpath /Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks -rpath /usr/lib/swift -headerpad_max_install_names -rpath /Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib -o /Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/test-macosx-arm64/Distributed/Runtime/Output/distributed_actor_to_actor.swift.tmp/a.out -v
@(#)PROGRAM:ld  PROJECT:dyld-1015.7
BUILD 16:59:34 Oct  1 2023
configured to support archs: armv6 armv7 armv7s arm64 arm64e arm64_32 i386 x86_64 x86_64h armv6m armv7k armv7m armv7em
will use ld-classic for: armv6 armv7 armv7s arm64_32 i386 armv6m armv7k armv7m armv7em
LTO support using: LLVM version 15.0.0 (static support for 29, runtime is 29)
TAPI support using: Apple TAPI version 15.0.0 (tapi-1500.0.12.3)
Library search paths:
	/Volumes/ExternalT7/code-external/swift-project-build/Ninja-DebugAssert/swift-macosx-arm64/lib/swift/macosx
	/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX14.0.sdk/usr/lib/swift
Framework search paths:
	/Applications/Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/Library/Frameworks
	/Users/ktoso/code/swift-project/build/Ninja-DebugAssert/swift-macosx-arm64/lib
ld: Undefined symbols:
  _main, referenced from:
      <initial-undefines>

*/