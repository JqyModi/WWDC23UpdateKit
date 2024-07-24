//
//  TNShareAppApp.swift
//  TNShareApp
//
//  Created by J.qy on 2023/9/26.
//

import SwiftUI
import SwiftData
import DebugKit

@main
struct TNShareApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    @StateObject
    private var entitlementManager: EntitlementManager
    
    @StateObject
    private var purchaseManager: PurchaseManager
    
    init() {
        let entitlementManager = EntitlementManager()
        let purchaseManager = PurchaseManager(entitlementManager: entitlementManager)

        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._purchaseManager = StateObject(wrappedValue: purchaseManager)
    }

    var body: some Scene {
        WindowGroup {
//            ContentView()
//            LastTagLabelView()
//            PushNotificationView()
//            TestYYLabelLastView()
//            PlayingIndicatorView()
//            TestLabelLastView()
//            AICodeVCView()
//            PlayingView()
            AudioStateView()
//            AudioPlayerView()
//            MOJiAudioSettingView()
//            RadioButtonGroupView()
//            GearSliderView()
//            UICowView()
//            StoreKit2View()
//                .onAppear {
//                    DebugKit.shared.setup(config: DebugConfigHelper())
//                    let scenes = UIApplication.shared.connectedScenes
//                    let windowScenes = scenes.first as! UIWindowScene
//                    purchaseManager.windowScenes = windowScenes
//                }
//                .environmentObject(entitlementManager)
//                .environmentObject(purchaseManager)
//                .task {
//                    // 启动时：检查待完成的交易
//                    await purchaseManager.updatePurchasedProducts()
//                }
        }
//        .modelContainer(sharedModelContainer)
    }
}
