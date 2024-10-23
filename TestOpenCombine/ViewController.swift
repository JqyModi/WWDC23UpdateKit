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
        
        test()
    }
    
    func test() {
        [1,2,3].publisher.sink { item in
            print(item)
        }
        
//        NotificationCenter.default.ocombine.publisher(for: .NSSystemClockDidChange).sink(receiveValue: <#T##(Notification) -> Void#>)
    }
    
}

