//
//  CombineVC.swift
//  TNShareApp
//
//  Created by J.qy on 2024/10/18.
//

import SwiftUI
import Combine
import SnapKit

class CombineVC: UIViewController {

    lazy var tapBtn = {
        let btn = UIButton()
        btn.backgroundColor = .red
        btn.setTitle("测试", for: .normal)
        btn.addTarget(self, action: #selector(future), for: .touchUpInside)
        return btn
    }()
    
//    var futurePublisher: Future<String, Error>!
    var cancellables: Set<AnyCancellable>!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        cancellables = []
        
        // 动态创建按钮
        createButtonsForInstanceMethods()
        
//        view.addSubview(tapBtn)
//        tapBtn.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.size.equalTo(CGSize(width: 100, height: 60))
//        }
    }
    
    func fetchData() -> Future<String, Error> {
        return Future { promise in
            DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
                let data = "Fetched data"
                promise(.success(data))
            }
        }
    }
}

// 发布者 Publisher
@objc extension CombineVC {
    
    func just() {
        let publisher = Just(43)
        publisher.sink { item in
            print("item = ", item)
        }
    }
    
    func future() async {
        let futurePublisher = fetchData()
//        futurePublisher = fetchData()
        futurePublisher.sink(receiveCompletion: { completion in
            print(completion)
        }, receiveValue: { value in
            print("Received: \(value)")
        })
        .store(in: &cancellables)
        // 输出: Received: Fetched data
        
        
//        do {
//            let value = try await futurePublisher.value
//            print("Received value: \(value)")
//        } catch {
//            print("Error occurred with info: \(error.localizedDescription)")
//        }

    }
    
    func passthroughSubject() {
        let subject = PassthroughSubject<String, Never>()
        subject.sink { value in
            print("Received: \(value)")
        }
        .store(in: &cancellables)

        subject.send("First event")
        subject.send("Second event")
        // 输出:
        // Received: First event
        // Received: Second event
    }
    
    func currentValueSubject() {
        let currentValueSubject = CurrentValueSubject<Int, Never>(10)
        currentValueSubject.sink { value in
            print("Received: \(value)")
        }

        currentValueSubject.send(20)
        // 新订阅者会立即收到最新值
        let newSubscriber = currentValueSubject.sink { value in
            print("New Subscriber Received: \(value)")
        }
        // 输出:
        // Received: 10
        // Received: 20
        // New Subscriber Received: 20
    }
    
    func deferred() {
        let deferredPublisher = Deferred {
            Future<String, Never> { promise in
                promise(.success("Deferred execution"))
            }
        }

        deferredPublisher.sink { value in
            print(value)
        }
        // 输出: Deferred execution
    }
    
}

// 订阅者 Subscriber
@objc extension CombineVC {
    func sink() {
        let numberPublisher = [1, 2, 3, 4].publisher
        numberPublisher.sink(receiveCompletion: { completion in
            print("Completion: \(completion)")
        }, receiveValue: { value in
            print("Value: \(value)")
        })
        // 输出:
        // Value: 1
        // Value: 2
        // Value: 3
        // Value: 4
        // Completion: finished
    }
    
    func assign() {
        class User {
            var name: String = "" {
                didSet {
                    print("User name updated to: \(name)")
                }
            }
        }

        let user = User()
        let namePublisher = Just("John Doe")
        namePublisher.assign(to: \.name, on: user)
        // 输出: User name updated to: John Doe
    }
    
    func customSubscriber() {
        final class CustomSubscriber: Subscriber {
            typealias Input = String
            typealias Failure = Never

            func receive(subscription: Subscription) {
                print("Subscribed!")
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
        ["":1, "": "2"].publisher.sink { dict in
            print(dict.key)
        }
        
        let customPublisher = ["A", "B", "C"].publisher
        customPublisher.subscribe(customSubscriber)
        // 输出:
        // Subscribed!
        // Received input: A
        // Received input: B
        // Received input: C
        // Received completion: finished
    }
}

// 操作符
@objc extension CombineVC {
    
    func convert() {
        let publisher = ["A", "B", "C"].publisher
        publisher
            .map({ $0 + "1" })
//            .flatMap({ item in
//                return (item + "2").publisher
//            })
            .compactMap({ $0 })
//            .reduce("aa", -)
//            .scan("dd", +)
//            .encode(encoder: JSONEncoder())
//            .decode(type: <#T##Decodable.Protocol#>, decoder: <#T##TopLevelDecoder#>)
            .sink(receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
        
    }
    
    func combine() {
        let publisher = Just("John")
        let publisher1 = Just("Doe")
        publisher
            .merge(with: publisher1)
            .combineLatest(publisher1)
            .zip(publisher1)
            .sink(receiveValue: {
                print($0)
            })
            .store(in: &cancellables)
    }
    
    func time() {
        enum TimeoutError: Error {
            case timeout
        }

        let publisher = PassthroughSubject<String, TimeoutError>()

        publisher
            .timeout(.seconds(2), scheduler: DispatchQueue.main, customError: { () -> TimeoutError in
                return TimeoutError.timeout
            }) // 超时
            .delay(for: .seconds(2), scheduler: DispatchQueue.main) // 延时
            .debounce(for: .seconds(1), scheduler: DispatchQueue.main) // 防抖
            .sink(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        print("Finished")
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                },
                receiveValue: { value in
                    print("Received value: \(value)")
                }
            )
            .store(in: &cancellables)

        publisher.send("Hello")
        publisher.send("World")
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            publisher.send("Timeout")
        }
    }
    
    func error() {
        enum MyError: Error {
            case invalidValue
        }
        
        let numbers: [Any] = [1, 2, 3, 4, 5, "Six", 7, 8, 9, 10]
        let publisher = numbers.publisher
        publisher
            .tryMap { value -> Int in
                guard let intValue = value as? Int else {
                    throw MyError.invalidValue
                }
                return intValue
            }
            .handleEvents() // 可以观察每个阶段执行
            .retry(3)
            .catch { error in
                return Just(-10)
            }
            .sink(receiveCompletion: { completion in
                print("Completion: \(completion)")
            }, receiveValue: { value in
                print("Value: \(value)")
            })
            .store(in: &cancellables)
    }
}

@objc extension CombineVC {
    class Model {
        @Published var title: String = ""
    }

    func modifier() {
        let model = Model()
        
        model.$title.sink(receiveValue: {
            print($0)
        })
        .store(in: &cancellables)
        
        model.title = "JJ"
        model.title = "KK"
    }
}

@objc extension CombineVC {
    func connect() {
        let model = Model()
        
        model.$title
            .share()
            .makeConnectable()
//            .connect()
            .sink(receiveValue: {
            print($0)
        })
    }
    
    func connect1() {
        let pub = (1...3).publisher
            .delay(for: 1, scheduler: DispatchQueue.main)
            .map( { _ in return Int.random(in: 0...100) } )
//            .print("Random")
//            .share()
            .makeConnectable()


        pub
            .sink { print ("Stream 1 received: \($0)")}.store(in: &cancellables)
        pub
            .sink { print ("Stream 2 received: \($0)")}.store(in: &cancellables)
        pub
            .sink { print ("Stream 3 received: \($0)")}.store(in: &cancellables)
        
        pub.connect().store(in: &cancellables)
    }
}

//#Preview {
//    CombineVC()
//}


struct CombineView: UIViewRepresentable {
    
    let vc = CombineVC()
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        return vc.view
    }
    
}

#Preview {
    return CombineView()
}
