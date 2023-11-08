//
//  WWDC23UpdateKitApp.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/9/26.
//

import SwiftUI
import SwiftData

@main
struct WWDC23UpdateKitApp: App {
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

    var body: some Scene {
        WindowGroup {
//            ContentView()
            TestRefreshingHeaderVCView()
        }
//        .modelContainer(sharedModelContainer)
    }
}
