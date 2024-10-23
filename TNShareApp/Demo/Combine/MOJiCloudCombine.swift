//
//  MOJiCloudCombine.swift
//  TNShareApp
//
//  Created by J.qy on 2024/10/21.
//

//import Combine
//import MOJiCloud
//
//@available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 6.0, *)
//
//struct CombineCloud {
//    
//}
//
//extension CombineCloud {
//    static func requestCustomPublisher<T: Codable>(_ modelType: T.Type, path: String, params: [String:Any], method: MCConfigMethodType) -> AnyPublisher<T, Error> {
//        return Future { promise in
//            MCCloud.callFunctionInBackground(bySystem: path, parameters: params, methodType: method) { resp, error in
//                do {
//                    // 1.MCCloud响应成功
//                    guard let resp = MCAPIResponse(result: resp) else {
//                        return
//                    }
//                    
//                    // 2.判断data为json格式
//                    guard let json = resp.originalData as? [String: Any] else {
//                        return
//                    }
//                    
//                    let jsonDecode = JSONDecoder()
//                    let customModel = try jsonDecode.decode(modelType, from: JSONSerialization.data(withJSONObject: json, options: []))
//                    
//                    promise(.success(customModel))
//                } catch {
//                    promise(.failure(error))
//                }
//            }
//        }
//        .receive(on: DispatchQueue.main) // 在主线程接收结果
//        .eraseToAnyPublisher() // 将 Future 转换为更通用的 AnyPublisher
//    }
//    
//    static func requestCustomPublisher1<T: Codable>(_ modelType: T.Type, path: String, params: [String:Any], method: MCConfigMethodType) -> AnyPublisher<Data, Error> {
//        return Future { promise in
//            MCCloud.callFunctionInBackground(bySystem: path, parameters: params, methodType: method) { resp, error in
//                do {
//                    // 1.MCCloud响应成功
//                    guard let resp = MCAPIResponse(result: resp) else {
//                        return
//                    }
//                    
//                    // 2.判断data为json格式
//                    guard let json = resp.originalData as? [String: Any] else {
//                        return
//                    }
//                    
//                    promise(.success(resp.originalData as! Data))
//                } catch {
//                    promise(.failure(error))
//                }
//            }
//        }
//        .receive(on: DispatchQueue.main) // 在主线程接收结果
//        .eraseToAnyPublisher() // 将 Future 转换为更通用的 AnyPublisher
//    }
//}
//
//extension CombineCloud {
//    
//    struct TopInfo: Codable {
//        let avatars: [String]
//        let onlineUserNum: Int
//    }
//    
//    struct Constant {
//        static let URL = "http://debugten.mojidict.com/api/v1/moments/header"
//        static let str = Data("{\"pubDate\":1574273638.575666, \"title\" : \"My First Article\", \"author\" : \"Gita Kumar\" }".utf8)
//    }
//    
//    static func testPublisher() {
//        requestCustomPublisher1(TopInfo.self, path: Constant.URL, params: [:], method: .get)
////            .tryMap() { element -> Data in
////                guard let httpResponse = element.response as? HTTPURLResponse,
////                    httpResponse.statusCode == 200 else {
////                        throw URLError(.badServerResponse)
////                    }
////                return element.data
////                }
////            .encode(encoder: JSONEncoder())
//            .decode(type: TopInfo.self, decoder: JSONDecoder())
//            .sink(receiveCompletion: { print ("Received completion: \($0).") },
//                  receiveValue: { user in print ("Received user: \(user).")})
//
//    }
//    
//    static func testURLSessionPublisher() {
//        struct User: Codable {
//            let name: String
//            let userID: String
//        }
//        let url = URL(string: "https://example.com/endpoint")!
//        let cancellable = URLSession.shared
//            .dataTaskPublisher(for: url)
//            .tryMap() { element -> Data in
//                guard let httpResponse = element.response as? HTTPURLResponse,
//                    httpResponse.statusCode == 200 else {
//                        throw URLError(.badServerResponse)
//                    }
//                return element.data
//                }
//            .decode(type: User.self, decoder: JSONDecoder())
//            .sink(receiveCompletion: { print ("Received completion: \($0).") },
//                  receiveValue: { user in print ("Received user: \(user).")})
//    }
//}
