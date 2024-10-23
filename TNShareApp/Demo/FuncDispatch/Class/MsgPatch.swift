//
//  MsgPatch.swift
//  FunDispatch
//
//  Created by Modi on 2024/7/26.
//

import Foundation

@objc class Animal: NSObject {
    @objc func makeSound() {
        print("Animal sound")
    }
    
    dynamic func makeCookie() {
        print("Animal sound")
    }
    
    @objc dynamic func makeSleep() {
        print("Animal sound")
    }
}

let animal = Animal()
animal.makeSound()  // 静态派发
animal.makeCookie() // 静态派发
animal.makeSleep()  // 消息派发，通过 objc_msgSend 在运行时确定调用地址




