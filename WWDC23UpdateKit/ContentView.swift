//
//  ContentView.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/9/26.
//

import SwiftUI
//import SwiftData

//struct ContentView: View {
//    @Environment(\.modelContext) private var modelContext
//    @Query private var items: [Item]
//
//    var body: some View {
//        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
////                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
////                        Text(item.title)
//                        Image(.到的)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//                ToolbarItem {
//                    Button(action: updateItem) {
//                        Label("Add Item", systemImage: "done")
//                    }
//                }
//            }
//        } detail: {
//            Text("Select an item")
//        }
//    }
//
//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
//    
//    private func updateItem() {
//        let item = items[0]
//        
//        let s = Text("测试国际化字符串")
//        let s0 = String(format: "测试国际化字符串0 %s", "A")
//        let s1 = String(localized: "测试国际化字符串1")
//        let s2 = "测试国际化字符串2"
//        let s3 = NSString(string: "测试国际化字符串3")
//        let s4 = NSString(format: "测试国际化字符串4 %@", "dd")
//        let s5 = String(localized: "%lld 个苹果")
//        let s6 = NSLocalizedString("测试国际化字符串6", comment: "")
//        let s7 = testLocalized(text: "点击的防静电九分裤 \("fdsfds")")
//        
//        withAnimation {
//            item.title += "\([1, 2, 3, 4].randomElement() ?? 666)"
//        }
//    }
//    
//    func testLocalized(text: String.LocalizationValue) -> String {
//        return String(localized: text)
//    }
//}
//
//#Preview {
//    ContentView()
//        .modelContainer(for: Item.self, inMemory: true)
//}
//







