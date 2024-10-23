//
//  main.swift
//  MacTermApp
//
//  Created by J.qy on 2024/7/25.
//

//import Foundation
//
//print("Hello, World!")
//
///// 协议A
//protocol ProtocolA {
////    func test1()
//}
//extension ProtocolA {
//    func test1() {
//        print("ProtocolA - test1")
//    }
//}
//
///// 结构体B
//struct StructB { }
//extension StructB: ProtocolA {
//    func test1() {
//        print("StructB  - test1")
//    }
//}
//
//struct FuncDispatch {
//    static func testDispatch() {
//        let p1: ProtocolA = StructB()
//        let s1: StructB = StructB()
//        p1.test1()
//        s1.test1()
//        print("---------------------------")
//        let s2: StructB = StructB()
//        let p2: ProtocolA = s2
//        p2.test1()
//        s2.test1()
//    }
//}
//
//FuncDispatch.testDispatch()
//
//print("dfdsf")

//class Animal {
//    func makeSound() {
//        print("Animal sound")
//    }
//}
//
//class Dog: Animal {
//    override func makeSound() {
//        print("Bark")
//    }
//}
//
//let animal: Animal = Dog()
//animal.makeSound() // 虚拟派发，通过虚函数表在运行时确定调用地址



// 判断当前是大端还是小端
//var a = 1
//print(a)

//class A {
//    var a: Int = 0
//    var b: Double = 0
//}
//
//var aa = A()
//aa.a = 111
//aa.b = 333.0
//
//print(aa)
//print(Unmanaged.passUnretained(aa).toOpaque())


protocol SoundMaking {
//    func makeSound()
}

extension SoundMaking {
    func makeSound() {
        print("Sound")
    }
}

class Dog: SoundMaking {
    func makeSound() {
        print("Bark")
    }
}

// 验证1
let dog = Dog()
dog.makeSound()

let soundMaking: SoundMaking = dog
let soundMaking2: Dog = dog
soundMaking.makeSound()

print(Unmanaged.passUnretained(dog).toOpaque())


