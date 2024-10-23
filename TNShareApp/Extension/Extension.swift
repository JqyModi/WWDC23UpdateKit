//
//  Extension.swift
//  TNShareApp
//
//  Created by J.qy on 2023/11/7.
//

import UIKit

@objc class MOJiFavInfoGradientView: UIView {
    @objc let gradientLayer = CAGradientLayer()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        gradientLayer.startPoint = CGPoint(x: 1, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.locations = [0, 1]
        
        layer.addSublayer(gradientLayer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

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



//frame
@objc public extension UIView {
    
    //把self放到target的左边某个位置     [self]←[target]
    @objc func leftTo(_ view: UIView, _ forDistance: CGFloat) { x = view.x - forDistance - width }
    
    //把self放到target的右边某个位置     [target]←[self]
    @objc func rightTo(_ view: UIView, _ forDistance: CGFloat) { x = view.maxX + forDistance }
    
    //把self放到target的里面左边某个位置     [←[self] target]
    @objc func leftInner(_ view: UIView, _ forDistance: CGFloat) { x = forDistance }
    
    //把self放到target的里面左边某个位置     [target [self]→]
    @objc func rightInner(_ view: UIView, _ forDistance: CGFloat) {
        x = view.width - forDistance - width
        view.addSubview(self)
    }

    @objc var radius: CGFloat {
        get { self.width == self.height ? self.width : 0 }
        set {
            self.width = newValue
            self.height = newValue
        }
    }

    @objc var width: CGFloat {
        get { self.frame.size.width }
        set {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: newValue,
                                height: self.frame.size.height)
        }
    }

    @objc var height: CGFloat {
        get { self.frame.size.height }
        set {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: self.frame.size.width,
                                height: newValue)
        }
    }
    
    @objc var size: CGSize {
        get { self.frame.size }
        set {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: self.frame.origin.y,
                                width: newValue.width,
                                height: newValue.height)
        }
    }
    
    @objc var x: CGFloat {
        get { self.frame.origin.x }
        set {
            self.frame = CGRect(x: newValue,
                                y: self.frame.origin.y,
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        }
    }

    @objc var centerX: CGFloat {
        get { self.center.x }
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    @objc var centerY: CGFloat {
        get { self.center.y }
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    @objc var y: CGFloat {
        get { self.frame.origin.y }
        set {
            self.frame = CGRect(x: self.frame.origin.x,
                                y: newValue,
                                width: self.frame.size.width,
                                height: self.frame.size.height)
        }
    }

    @objc var maxX: CGFloat {
        get { self.frame.origin.x+self.width }
    }

    @objc var maxY: CGFloat {
        get { self.frame.origin.y+self.height }
    }
}

extension UIViewController {
    
    // 获取当前类的所有无参实例方法，并过滤掉系统方法
    private func getCustomInstanceMethods() -> [Selector] {
        // 获取 CombineVC 自己的无参实例方法
        let combineVCMethods = getInstanceMethods(for: type(of: self))
        
        // 获取 UIViewController 的无参实例方法
        let uiViewControllerMethods = getInstanceMethods(for: UIViewController.self)
        
        // 排除掉系统的原有方法，只保留 CombineVC 新增的方法
        return combineVCMethods.filter { !uiViewControllerMethods.contains($0) }
    }
    
    // 获取指定类的无参实例方法
    private func getInstanceMethods(for cls: AnyClass) -> [Selector] {
        var methodCount: UInt32 = 0
        var methods = [Selector]()
        
        // 获取类的所有方法列表
        if let methodList = class_copyMethodList(cls, &methodCount) {
            for i in 0..<Int(methodCount) {
                let selector = method_getName(methodList[i])
                
                if selector.description.contains("_") {
                    continue
                }
                
                // 检查方法是否是实例方法，且没有参数
                if let method = class_getInstanceMethod(cls, selector) {
                    let argumentCount = method_getNumberOfArguments(method)
                    if argumentCount == 2 { // 1 for self, 1 for _cmd (表示没有额外参数)
                        methods.append(selector)
                    }
                }
            }
            free(methodList)
        }
        return methods
    }
    
    // 获取当前类的所有无参实例方法
    func getInstanceMethods() -> [Selector] {
        var methodCount: UInt32 = 0
        var methods = [Selector]()
        
        // 获取类的所有方法列表
        if let methodList = class_copyMethodList(object_getClass(self), &methodCount) {
            for i in 0..<Int(methodCount) {
                let selector = method_getName(methodList[i])
//                let name = NSStringFromSelector(selector)
                
                // 检查方法是否是实例方法，且没有参数
                if let method = class_getInstanceMethod(type(of: self), selector) {
                    let argumentCount = method_getNumberOfArguments(method)
                    if argumentCount == 2 { // 1 for self, 1 for _cmd (表示没有额外参数)
                        methods.append(selector)
                    }
                }
            }
            free(methodList)
        }
        return methods
    }
    
    // 动态创建按钮并绑定到方法
    func createButtonsForInstanceMethods() {
        let methods = getCustomInstanceMethods()
        
        let scrollView = UIScrollView(frame: self.view.frame)
        scrollView.contentInset = .init(top: 0, left: 0, bottom: 80, right: 0)
        self.view.addSubview(scrollView)
        
        let buttonHeight: CGFloat = 50
        let padding: CGFloat = 10
        
        for (index, selector) in methods.enumerated() {
            let button = UIButton(type: .system)
            button.setTitle(NSStringFromSelector(selector), for: .normal)
            button.backgroundColor = .systemBlue
            button.setTitleColor(.white, for: .normal)
            button.frame = CGRect(x: 20, y: CGFloat(index) * (buttonHeight + padding) + 20, width: self.view.frame.width - 40, height: buttonHeight)
            button.addTarget(self, action: selector, for: .touchUpInside)
            
            scrollView.addSubview(button)
        }
        
        scrollView.contentSize = .init(width: view.width, height: (scrollView.subviews.last?.maxY ?? 0))
    }
}
