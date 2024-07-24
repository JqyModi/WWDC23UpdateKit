//
//  CowView.swift
//  TNShareApp
//
//  Created by J.qy on 2024/6/11.
//

import SwiftUI

//打印内存地址
func printAddress(of object: UnsafeRawPointer) {
    let addr = Int(bitPattern:object)
    let str = String(format:"%p",addr)
    print(str)
}

struct PenPalRecord: Equatable {
    static func == (lhs: PenPalRecord, rhs: PenPalRecord) -> Bool {
        print("")
        return true
    }
    
    let myID: Int
    var myNickname: String
    var recommendedPenPalID: Int
}

#Preview {
    UICowView()
}

struct UICowView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        UICowViewController().view
    }
}

class UICowViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        
//        normalType()
//        setStore()
//        customStruct()
//        classInStruct()
        
        
//        readBigData()
//        threadApply()
//        useInFunc()
        
        
//        copyBigData()
//        copyInDispatchQueue()
//        multiWriteAction()
        immutableDestruction()
        
        
//        customCow()
        
        
//        viewRefChanged()
        
        let p1 = PenPalRecord(myID: 0, myNickname: "", recommendedPenPalID: 1)
        let p2 = PenPalRecord(myID: 0, myNickname: "", recommendedPenPalID: 1)
        if p1 == p2 {
            
        }
    }
    
}

extension UICowViewController {
    
    // 基本类型
    func normalType() {
        var int1 = 2
        var int2 = int1
        printAddress(of: &int1)
        printAddress(of: &int2)
        
        int2 = 3
        
        printAddress(of: &int1)
        printAddress(of: &int2)
        
        print("---------------------------")
    }
    
    
    // lldb打印集合地址： fr v -R [objc]
    
    // Swift集合类型
    func setStore() {
        var original = [1, 2, 3]
        var copy = original
        print(original)  // [1, 2, 3]
        print(copy)      // [1, 2, 3]，同样的内容但没有发生复制
        copy.append(4)   // 在这一步，"copy" 发生了写时复制操作
        print(original)  // [1, 2, 3]，原始数组保持不变
        print(copy)      // [1, 2, 3, 4]，只有这个数组被改变和复制
        
        print("---------------------------")
    }
    
    func customStruct() {
        struct Person {
            var name: String

            init(name: String) {
                self.name = name
            }
        }

        var p1 = Person(name: "Jack")

        var p2 = p1
        
        print("---------------------------")
    }
    
    func classInStruct() {
        class Dog: NSObject {

            var age: Int

            init(age: Int) {
                self.age = age
            }
        }

        struct Person {
            var name: String
            var dog: Dog

            init(name: String, dog: Dog) {
                self.name = name
                self.dog = dog
            }
        }

        let dog1 = Dog(age: 2)

        var p1 = Person(name: "Jack", dog: dog1)
        print(p1.dog.description,"\n")

        print("p1-dog age: \((p1.dog).age)\n")

        var p2 = p1
        
        withUnsafePointer(to: &p1) { pointer in
            print(pointer)
        }
        
        withUnsafePointer(to: &p2) { pointer in
            print(pointer)
        }
        
        p2.name = "Andy"
        print(p2.dog.description,"\n")

        p2.dog.age = 5

        print(p1.dog.description,"\n")
        print(p2.dog.description,"\n")

        print("p1-dog age: \((p1.dog).age)")
        print("p2-dog age: \((p2.dog).age)")
        
        withUnsafePointer(to: &p1) { pointer in
            print(pointer)
        }
        
        withUnsafePointer(to: &p2) { pointer in
            print(pointer)
        }
    }
}

// 优势
extension UICowViewController {
    
    /// 变量赋值读取大数据
    func readBigData() {
        // 创建一个大数组
        var largeArray = Array(repeating: 0, count: 10_000_000)

        // 测量写时复制的性能
        let start = CFAbsoluteTimeGetCurrent()

        // 第一次写操作导致复制
        var copyArray = largeArray

        let diff = CFAbsoluteTimeGetCurrent() - start
        print("写时复制的时间: \(diff) 秒")
        
        print("---------------------------")
    }
    
    // 线程
    func threadApply() {
        var original = [1, 2, 3]
        var copy1 = original
        var copy2 = original
        
        print(original)
        print(copy1)
        print(copy2)
        
        // 异步执行任务
        DispatchQueue.global().async {
            // 在后台执行任务
//            var item1 = original[1]
            print(original)
            print(copy1)
            
            copy1[1] = 8
            
            print(original)
            print(copy1)
        }
        
        
        DispatchQueue.global().async {
            print(original)
            print(copy1)
            
            copy2[1] = 10
            
            print(original)
            print(copy2)
        }
        
        
        DispatchQueue.global().async {
            print(original)
            print(copy1)
            
            copy1[1] = 8
            
            print(original)
            print(copy1)
        }
        
        print("---------------------------")
    }
    
    // 函数
    func useInFunc() {
        // 定义一个不可变的函数，返回一个新的数组
        func addElementToArray(_ array: [Int], element: Int) -> [Int] {
            var newArray = array
            newArray.append(element)
            return newArray
        }

        // 初始数组
        let originalArray = [1, 2, 3, 4, 5]

        // 调用函数添加新元素，得到一个新的数组
        let newArray = addElementToArray(originalArray, element: 6)

        // 输出原数组和新数组
        print("Original Array: \(originalArray)")
        print("New Array: \(newArray)")

    }
}

// 劣势
extension UICowViewController {
    
    /// 性能开销：耗时长
    func copyBigData() {
        // 创建一个大数组
        var largeArray = Array(repeating: 0, count: 10_000_000)

        // 测量写时复制的性能
        let start = CFAbsoluteTimeGetCurrent()

        // 第一次写操作导致复制
        var copyArray = largeArray
        copyArray[0] = 1

        let diff = CFAbsoluteTimeGetCurrent() - start
        print("写时复制的时间: \(diff) 秒")
        
        
        copyArray[1] = 88
        
        let diff1 = CFAbsoluteTimeGetCurrent() - start
        print("写时复制的时间1: \(diff1) 秒")
        
        print("---------------------------")
    }
    
    // 内存使用
    func copyInDispatchQueue() {
        // 创建一个大数组
        var largeArray = Array(repeating: 0, count: 10_000_000)

        // 在多线程环境下进行写操作
        DispatchQueue.concurrentPerform(iterations: 10) { i in
            var copyArray = largeArray
            copyArray[i] = i
            // 每个线程都会创建一个数组副本，导致内存使用增加
        }
        
        print("---------------------------")
    }
    
    /// 简化并发编程
//    func concurrentProgramming() {
//        // 创建一个大数组
//        var largeArray = Array(repeating: 0, count: 10_000_000)
//        
//        // 在多线程环境下进行读取操作，不会触发复制
//        DispatchQueue.concurrentPerform(iterations: 10) { i in
//            let value = largeArray[i]
//            print("读取值: \(value)")
//        }
//        
//        // 此时 largeArray 仍然没有被复制
//        
//        print("---------------------------")
//    }
    
    /// 性能问题
    func multiWriteAction() {
        // 创建一个大数组
        var largeArray = Array(repeating: 0, count: 10_000_000)

        func modifyArray(_ array: inout [Int]) {
            // 尝试修改数组的一个元素
            array[0] = 1
        }

        let start = CFAbsoluteTimeGetCurrent()

        // 多次调用函数，可能会导致不可预期的性能问题
        for _ in 0..<1000 {
            modifyArray(&largeArray)
        }

        let diff = CFAbsoluteTimeGetCurrent() - start
        print("函数调用后的时间: \(diff) 秒")
        
        print("---------------------------")
    }
    
    /// 不可变性假设的破坏
    func immutableDestruction() {
        // 创建一个不可变数组
        let immutableArray = [1, 2, 3, 4, 5]

        // 传递数组给函数并修改它
        func modifyArray(_ array: inout [Int]) {
            array[0] = 99
        }

        var copiedArray = immutableArray
        modifyArray(&copiedArray)

        print("原数组: \(immutableArray)") // 输出: 原数组: [1, 2, 3, 4, 5]
        print("修改后的副本: \(copiedArray)") // 输出: 修改后的副本: [99, 2, 3, 4, 5]
        
        print("---------------------------")
    }
}

// 优势
extension UICowViewController {
    
    func customCow() {
        
        class Dog: NSObject {

            var age: Int

            init(age: Int) {
                self.age = age
            }
        }

        struct Person {
            var name: String
            var dog: Dog

            init(name: String, dog: Dog) {
                self.name = name
                self.dog = dog
            }
        }
        
        /// 官方例子
        
        final class Ref<T> {
            var value: T
            init(_ value: T) {
                self.value = value
            }
        }
        
        struct COWStruct<T> {
            private var ref: Ref<T>
            
            init(_ value: T) {
                self.ref = Ref(value)
            }
            
            var value: T {
                get { return ref.value }
                // 如果是数组可以在append写方法时处理
                set {
                    // 检查引用计数，执行写时复制
                    if !isKnownUniquelyReferenced(&ref) {
                        ref = Ref(newValue)
                    } else {
                        ref.value = newValue
                    }
                }
            }
        }
        
        var a = COWStruct(COWStruct(Dog(age: 11)))
        var b = a  // 此时 a 和 b 共享相同的存储
        
        print(a.value)  // 输出 42
        print(b.value)  // 输出 42
        
        withUnsafePointer(to: &a) { print($0) }
        withUnsafePointer(to: &b) { print($0) }
        
        b.value = COWStruct(Dog(age: 11))   // b 修改了数据，这时会进行复制
        print(a.value)  // 输出 42（未改变）
        print(b.value)  // 输出 100（b 已经拥有了自己的副本）
        
        // 验证内存地址
        //        print(Unmanaged.passUnretained(a.ref).toOpaque())  // 打印 a 的引用的内存地址
        //        print(Unmanaged.passUnretained(b.ref).toOpaque())  // 打印 b 的引用的内存地址，地址不同
        // 打印地址
        withUnsafePointer(to: &a) { print($0) }
        withUnsafePointer(to: &b) { print($0) }
    }
}
    
// 验证方式
extension UICowViewController {
    
    func viewRefChanged() {
        class Reference<T> {
            var value: T
            init(_ value: T) {
                self.value = value
            }
        }

        var ref1 = Reference([1, 2, 3])
        print(CFGetRetainCount(ref1))

        var ref2 = ref1
        print(CFGetRetainCount(ref1))

        ref2.value.append(4)
        print(CFGetRetainCount(ref1))
    }
}



