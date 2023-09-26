//
//  Item.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/9/26.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
