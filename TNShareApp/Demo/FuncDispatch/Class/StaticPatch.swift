//
//  StaticPatch.swift
//  FunDispatch
//
//  Created by Modi on 2024/7/26.
//

class Animal {
    final func makeSound() {
        print("Animal sound")
    }
}

let animal = Animal()
animal.makeSound() // 直接派发，在编译期确定调用地址



