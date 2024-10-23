//
//  WitnessPatch.swift
//  FunDispatch
//
//  Created by Modi on 2024/7/26.
//

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

// 验证2
//func playSound<T: SoundMaking>(_ animal: T) {
//    animal.makeSound() // Witness Table 派发，通过 Witness Table 在运行时确定调用地址
//}
//
//let dog = Dog()
//playSound(dog)
