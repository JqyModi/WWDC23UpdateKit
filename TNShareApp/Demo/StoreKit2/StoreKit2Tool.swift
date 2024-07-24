//
//  StoreKit2Tool.swift
//  TNShareApp
//
//  Created by J.qy on 2024/2/27.
//

import StoreKit
import SwiftUI
import UIKit

// MARK: - 获取Swift枚举的caseName
@_silgen_name("swift_EnumCaseName")
func _getEnumCaseName<T>(_ value: T) -> UnsafePointer<CChar>?

func getEnumCaseName<T>(for value: T) -> String? {
    if let stringPtr = _getEnumCaseName(value) {
        return String(validatingUTF8: stringPtr)
    }
    return nil
}

// MARK: - 测试商品信息
enum StoreKit2Product: Int, CaseIterable {
    /// 消耗型
    case Consumable
    /// 非消耗型：一次性买断
    case NonConsumable
    /// 非自动订阅
    case NonRenewing
    /// 自动订阅
    case AutoRenewable
    
    var identifier: String {
//        #if DEBUG
//        return "moji_read_upgrade"
//        #endif
        
        let caseNames = Self.allCases.map({ getEnumCaseName(for: $0) ?? "" })
        return "\(caseNames[rawValue])_001"
    }
    
    /// async异步获取商品
    /// await会等待返回结果
    /// try/throws可能获取异常并抛出
    static func products() async throws -> [Product] {
        return try await Product.products(for: Self.allCases.map({ $0.identifier }))
    }
    
    static func testAsync() async throws {
        let tt = try await Product.products(for: Self.allCases.map({ $0.identifier }))
        print("的话的换货单号和")
        print(tt)
    }
}


@MainActor
class PurchaseManager: NSObject, ObservableObject {
    
    public var windowScenes: UIWindowScene!
    
    private let testInXcodeProductIds = StoreKit2Product.allCases.map({ $0.identifier })
    private let productIds = ["moji_read_upgrade", "moji_read_pro_1_month"]
    
    @Published
    private(set) var products: [Product] = []
    private var productsLoaded = false
    
    @Published
    private(set) var purchasedProductIDs = Set<String>()
    
    private var updates: Task<Void, Never>? = nil
    
    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    private let entitlementManager: EntitlementManager
    
    init(entitlementManager: EntitlementManager, windowScenes: UIWindowScene? = nil) {
        self.entitlementManager = entitlementManager
        super.init()
        SKPaymentQueue.default().add(self)
        
        self.updates = observeTransactionUpdates()
        
        self.windowScenes = windowScenes
    }
    
    deinit {
        updates?.cancel()
    }
    
    func loadProducts(testInXcode: Bool = true) async throws {
        guard !self.productsLoaded else { return }
        self.products = try await Product.products(for: testInXcode ? testInXcodeProductIds : productIds)
        self.productsLoaded = true
        print("加载商品列表完成：", products)
    }
    
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
            case let .success(.verified(transaction)):
                // 应用内商品已成功购买
                await transaction.finish()
                
                if transaction.productType == .consumable {
                    print("消耗品购买成功")
                    return
                } else {
                    print("非消耗品购买成功")
                    await self.updatePurchasedProducts()
                }
                
                // 服务端验证收据
//                await postTransaction(transaction, product: product)
            case let .success(.unverified(_, error)):
                // 购买成功，但未通过 StoreKit 自动验证检查，这可能是由于设备越狱造成的
                break
            case .pending:
                // 这是由强客户身份验证 (SCA)或询问购买引起的。SCA 是在进行购买之前由金融机构进行身份验证或批准的附加因素。这可以通过应用程序或短信来完成。
                // 批准后，交易将被更新。购买请求是一项功能，让孩子可以向父母或监护人请求购买商品。购买将处于待处理状态，直到父母或监护人批准或拒绝购买
                break
            case .userCancelled:
                // 用户已取消
                break
            @unknown default:
                // 错误：这个结果是Product.PurchaseError或StoreKitError，可能是由于没有互联网连接、App Store停机、付款错误等原因
                break
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            if transaction.revocationDate == nil {
                self.purchasedProductIDs.insert(transaction.productID)
            } else {
                self.purchasedProductIDs.remove(transaction.productID)
            }
        }
        
        self.entitlementManager.hasPro = !self.purchasedProductIDs.isEmpty
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            // MARK: - 客户端验证流程
            for await verificationResult in Transaction.updates {
                // 此时的VerificationResult和Transaction.currentEntitlements等效
                await self.updatePurchasedProducts()
            }
            
            // MARK: - 服务端验证流程
//            for await result in Transaction.updates {
//                guard case .verified(let transaction) = result else {
//                    continue
//                }
//                
//                guard let product = products.first(where: { product in
//                    product.id == transaction.productID
//                }) else { continue }
//                await postTransaction(transaction, product: product)
//            }
        }
    }
    
    // MARK: - 发送收据到服务端验证
    func postTransaction(_ transaction: StoreKit.Transaction, product: Product) async {
        let originalTransactionID = transaction.originalID
        let body: [String: Any] = [
            "originalTransactionId": "\(originalTransactionID)",
            "price": product.price,
            "displayPrice": product.displayPrice
        ]
        // 发送post请求到服务端
        await httpPost(body: body)
    }
    
//    func httpPost(body: [String : Any]) async {
//        // 创建 URLRequest 对象
//        let url = URL(string: "http://localhost:8080/apple/transactions")!
//        var request = URLRequest(url: url)
//        request.httpMethod = "POST"
//
//        // 设置请求头
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//
//        // 设置请求体
////        let body = ["username": "user", "password": "pass"]
//        let jsonData = try! JSONSerialization.data(withJSONObject: body)
//        request.httpBody = jsonData
//
//        // 发送请求
//        let publisher = URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .decode(type: [String: String].self, decoder: JSONDecoder())
//
//        // 处理响应
//        publisher.sink(receiveCompletion: {
//            print($0)
//        }, receiveValue: {
//            print($0)
//        })
//    }
    
    func httpPost(body: [String : Any]) async {
        // 使用示例
        let urlString = "http://localhost:8080/apple/transactions"
        let parameters: [String: Any] = body

        HttpTool.httpPost(urlString: urlString, parameters: parameters) { data, response, error in
            if let error = error {
                print("Error:", error)
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Status code:", httpResponse.statusCode)
            }
            
            if let data = data {
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Response:", jsonString)
                }
            }
        }
    }
}

// MARK: - 监听从App Store进行应用内购买
extension PurchaseManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        print(#function)
    }

    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        print(#function)
        // 返回true时打开App后会自动购买，false需要自己处理购买逻辑
        
        // 参考辞书
//        let productId = product.productIdentifier
//        
//        if productId == MOJI_JISO_PRO_UPGRADE_ID_appstore {
//            MDUIUtils.pushVipVC()
//        } else {
//            MDUIUtils.pushSubscriptionVC(withProductId: productId)
//        }
        
        return false
    }
}

// MARK: - 退款、订阅账单管理
extension PurchaseManager {
    
    func showManageSubscriptions() async throws {
        try await AppStore.showManageSubscriptions(in: windowScenes)
    }
    
    func refundLatestTransaction() async throws {
        if await entitlementsIsEmpty() {
            return
        }
        
        var transactionTmp: (StoreKit.Transaction)!
        
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            
            transactionTmp = transaction
            break
        }
        
        if transactionTmp.revocationDate == nil {
            let status = try await transactionTmp.beginRefundRequest(in: windowScenes)
            
            switch status {
                case .success:
                    print("退款成功")
                case .userCancelled:
                    print("用户取消退款")
                @unknown default:
                    print("退款失败")
            }
        }
    }
    
    func entitlementsIsEmpty() async -> Bool {
        // 初始值为 true，表示没有事务信息
        var hasTransaction = true

        // 获取当前事务信息
        let transactions = Transaction.currentEntitlements
        // 创建异步迭代器
        var iterator = transactions.makeAsyncIterator()

        // 使用异步循环来遍历元素
        while let result = await iterator.next() {
            // 在这里处理每个事务信息
            print(result)
            // 设置 hasTransaction 为 true
            hasTransaction = false
            // 因为我们只需要知道是否有事务信息，所以遇到一个即可退出循环
            break
        }

        // 返回是否有事务信息
        return hasTransaction
    }

}

// MARK: - 扩展target同步购买信息类
class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.modi.shared")!
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
}


// MARK: - 简单Http请求类
class HttpTool {

    static func httpPost(urlString: String, parameters: [String: Any], completion: @escaping (Data?, URLResponse?, Error?) -> Void) {
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // 设置请求头
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 设置请求体参数
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        } catch {
            print("Failed to serialize parameters:", error)
            return
        }
        
        // 发起请求
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, response, error)
        }
        task.resume()
    }
}
