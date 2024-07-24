//
//  DebugConfigHelper.swift
//  TNShareApp
//
//  Created by J.qy on 2024/2/23.
//

import DebugKit

class DebugConfigHelper: NSObject, DebugConfig {
    var currentEnv: String {
        return "测试环境"
    }
    
    var currentTheme: String {
        return "深色"
    }
    
    func serverDidSelected(env: Int) {
        SwiftLog.mojiLog(items: #function)
    }
    
    func clearAllUrlCacheFile() {
        SwiftLog.mojiLog(items: #function)
    }
    
    func resetH5hybridUrlHost(host: String) {
        SwiftLog.mojiLog(items: #function)
    }
    
    var customPlugsInfo: [[String : String]] {
        return []
    }
    
    func customPlugsDidSelected(id: String) {
        SwiftLog.mojiLog(items: #function)
    }
}
