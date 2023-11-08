//
//  Extension.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/11/7.
//

import UIKit

@objc public extension UIColor {
    
    /// Random Color.
    /// - Returns: UIColor
    @objc static func random() -> UIColor {
        UIColor(red: CGFloat((arc4random() % 255)) / 255.0, green: CGFloat((arc4random() % 255)) / 255.0, blue: CGFloat((arc4random() % 255)) / 255.0, alpha: 1)
    }
    
    /// Get Color via hex(int).
    /// - Parameter hex: like 0xFF3A3A
    /// - Returns: UIColor
    @objc static func color(hex: Int) -> UIColor {
        color(hex: hex, alpha: 1.0)
    }
    
    /// Get Color via hex(int).
    /// - Parameters:
    ///   - hex: hex like 0xFF3A3A
    ///   - alpha: alpha
    /// - Returns: UIColor
    @objc static func color(hex: Int, alpha: CGFloat) -> UIColor {
        UIColor.init(hex: hex, alpha: alpha)
    }
    
    convenience init(hex: Int) {
        self.init(hex: hex, alpha: 1.0)
    }
    
    convenience init(hex: Int, alpha: CGFloat) {
        self.init(red: CGFloat(Double(((hex & 0xFF0000) >> 16)) / 255.0), green: CGFloat(Double(((hex & 0x00FF00) >> 8)) / 255.0), blue: CGFloat(Double(((hex & 0x0000FF))) / 255.0), alpha: alpha)
    }
    
    /// Get Color via Hex String(Can add # or not.)
    /// - Parameter hexString: #RGB(#RRGGBB)/#RGBA(RRGGBBAA)/#RRGGBB/#RRGGBBAA
    /// - Returns: UIColor
    convenience init(hexString: String) {
        let colorString = hexString.replacingOccurrences(of: "#", with: "").uppercased()
        
        var alpha = 1.0
        var red   = 0.0
        var blue  = 0.0
        var green = 0.0
        
        switch colorString.count {
            case 3:// #RGB(#RRGGBB)
                alpha = 1.0
                red   = UIColor.colorComponentFrom(colorString, location: 0, length: 1)
                green = UIColor.colorComponentFrom(colorString, location: 1, length: 1)
                blue  = UIColor.colorComponentFrom(colorString, location: 2, length: 1)
            case 4: // #RGBA(RRGGBBAA)
                red   = UIColor.colorComponentFrom(colorString, location: 0, length: 1)
                green = UIColor.colorComponentFrom(colorString, location: 1, length: 1)
                blue  = UIColor.colorComponentFrom(colorString, location: 2, length: 1)
                alpha = UIColor.colorComponentFrom(colorString, location: 3, length: 1)
            case 6: // #RRGGBB
                red   = UIColor.colorComponentFrom(colorString, location: 0, length: 2)
                green = UIColor.colorComponentFrom(colorString, location: 2, length: 2)
                blue  = UIColor.colorComponentFrom(colorString, location: 4, length: 2)
            case 8: // #RRGGBBAA
                red   = UIColor.colorComponentFrom(colorString, location: 0, length: 2)
                green = UIColor.colorComponentFrom(colorString, location: 2, length: 2)
                blue  = UIColor.colorComponentFrom(colorString, location: 4, length: 2)
                alpha = UIColor.colorComponentFrom(colorString, location: 6, length: 2)
            default:
                break
        }
        
        self.init(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
    }
    
    @objc static func color(hexString: String) -> UIColor {
        return UIColor.init(hexString: hexString)
    }
    
    private static func colorComponentFrom(_ string: String, location: Int, length: Int) -> Double {
        let substring     = (string as NSString).substring(with: NSMakeRange(location, length))
        let fullHexString = length == 2 ? substring : String(format: "%@%@", substring, substring)
        
        var hexComponent: UInt32 = 0
        
        Scanner.init(string: fullHexString).scanHexInt32(&hexComponent)
        
        return Double(hexComponent) / 255.0
    }
    
}

/// 十六进制颜色值转换 UIColor（#FFC0CBFF / FFC0CBFF / #FFC0CB / FFC0CB ）
/// - Parameter hexString: hex string
/// - Returns: UIColor
public func HexColor(_ hexString: String) -> UIColor {
    UIColor.init(hexString: hexString)
}
