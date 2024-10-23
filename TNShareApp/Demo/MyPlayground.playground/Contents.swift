import UIKit
import PlaygroundSupport


//protocol TestProtocol {
//    
//}
//
//extension TestProtocol {
//    func extFunc() {
//        print(#function, "TestProtocol")
//    }
//}
//
//struct TestStruct: TestProtocol {
//    func extFunc() {
//        print(#function, "TestStruct")
//    }
//}

//extension TestStruct {
//    func extFunc() {
//        print(#function, "TestStruct")
//    }
//}

//let stru = TestStruct()
//let struPro: TestProtocol = stru
//
//stru.extFunc()
//struPro.extFunc()


/// 协议A
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
//let p1: ProtocolA = StructB()
//let s1: StructB = StructB()
//p1.test1()
//s1.test1()
//print("---------------------------")
//let s2: StructB = StructB()
//let p2: ProtocolA = s2
//p2.test1()
//s2.test1()



//@objc class Animal: NSObject {
//    @objc func makeSound() {
//        print("Animal sound")
//    }
//    
//    dynamic func makeSleep() {
//        print("Animal sleep")
//    }
//}
//
//let animal = Animal()
//animal.makeSleep() // 消息派发，通过 objc_msgSend 在运行时确定调用地址



//protocol SoundMaking {
//    func makeSound()
//}
//
//class Dog: SoundMaking {
//    func makeSound() {
//        print("Bark")
//    }
//}
//
//let dog = Dog()
//dog.makeSound()
//
//let soundMaking: SoundMaking = dog
//soundMaking.makeSound()



//protocol SoundMaking {
//    func makeSound()
//}
//
//extension SoundMaking {
//    func makeSound() {
//        print("Sound")
//    }
//}
//
//class Dog: SoundMaking {
//    func makeSound() {
//        print("Bark")
//    }
//}
//
//let dog = Dog()
//dog.makeSound()
//
//let soundMaking: SoundMaking = dog
//soundMaking.makeSound()




// SR-103 (Swift bug, protocols)

protocol Greetable {
    func sayHi()
}
extension Greetable {
    func sayHi() {
        print("from protocol")
    }
}
func greetings(greeter: Greetable) {
    greeter.sayHi()
}
class Person: Greetable { }
class Employee: Person {
    func sayHi() {
        print("from employee")
    }
}
greetings(greeter: Employee())
// from protocol, however Employee has own implementation


