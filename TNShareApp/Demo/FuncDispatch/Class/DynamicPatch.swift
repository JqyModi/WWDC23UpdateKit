//
//  DynamicPatch.swift
//  FunDispatch
//
//  Created by Modi on 2024/7/26.
//

class Animal {
    func makeSound() {
        print("Animal sound")
    }
}

class Dog: Animal {
    override func makeSound() {
        print("Bark")
    }
}

let animal: Animal = Dog()
animal.makeSound() // 虚拟派发，通过虚函数表在运行时确定调用地址
