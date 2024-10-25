//
//  ViewController.swift
//  TestOpenCombine
//
//  Created by J.qy on 2024/10/23.
//

import UIKit
import OpenCombine
import OpenCombineFoundation

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
//        test()
        customSub()
    }
    
    func test() {
        [1,2,3].publisher.sink { item in
            print(item)
        }
        
//        NotificationCenter.default.ocombine.publisher(for: .NSSystemClockDidChange).sink(receiveValue: <#T##(Notification) -> Void#>)
    }
    
    func customSub() {
        final class CustomSubscriber: Subscriber {
            typealias Input = String
            typealias Failure = Never

            func receive(subscription: Subscription) {
                print("Subscribed!")
                // Subscription继承了Cancellable可以用来取消订阅
                subscription.request(.unlimited) // 请求无限个值
            }

            func receive(_ input: String) -> Subscribers.Demand {
                print("Received input: \(input)")
                return .none // 表示不需要更多的值
            }

            func receive(completion: Subscribers.Completion<Never>) {
                print("Received completion: \(completion)")
            }
        }

        let customSubscriber = CustomSubscriber()
        let customPublisher = ["A", "B", "C"].publisher
        customPublisher.subscribe(customSubscriber)
    }
}

