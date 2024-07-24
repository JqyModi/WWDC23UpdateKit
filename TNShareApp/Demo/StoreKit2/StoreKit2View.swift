//
//  StoreKit2View.swift
//  TNShareApp
//
//  Created by J.qy on 2024/2/27.
//

import SwiftUI
import StoreKit

struct StoreKit2View: View {
    @EnvironmentObject
    private var entitlementManager: EntitlementManager
    
    @EnvironmentObject
    private var purchaseManager: PurchaseManager

    var body: some View {
        VStack(spacing: 20) {
            if entitlementManager.hasPro {
                Text("Thank you for purchasing pro!")
            } else {
                Text("Products")
                ForEach(purchaseManager.products) { (product) in
                    Button {
                        Task {
                            do {
                                try await purchaseManager.purchase(product)
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Text("\(product.displayPrice) - \(product.displayName)")
                            .foregroundColor(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Capsule())
                    }
                }
            }
            
            Button {
                Task {
                    do {
                        try await AppStore.sync()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("恢复购买")
            }
            
            Button {
                Task {
                    do {
                        try await purchaseManager.showManageSubscriptions()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("账单管理")
            }
            
            Button {
                Task {
                    do {
                        try await purchaseManager.refundLatestTransaction()
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("退款最新一笔交易")
            }
        }.task {
            Task {
                do {
                    try await purchaseManager.loadProducts(testInXcode: true)
                    
                    try await StoreKit2Product.testAsync()
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    StoreKit2View()
}

