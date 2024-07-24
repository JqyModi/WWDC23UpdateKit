//
//  TestLabelLastView.swift
//  TNShareApp
//
//  Created by J.qy on 2023/11/9.
//

import SwiftUI

struct TestLabelLastView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TestLabelLastView()
}

extension TestLabelLastView {
    @discardableResult
    static func appendLastView(label: UILabel) -> Bool {
        label.sizeToFit()
        let limitLabelWidth: CGFloat = label.width
        let limitLabelHeight: CGFloat = label.height
        
        guard let attr = label.attributedText else { return false }
        var mulAttr = NSMutableAttributedString(attributedString: attr)
        
        let wSize = label.textRect(forBounds: CGRect(origin: label.bounds.origin, size: CGSizeMake(.greatestFiniteMagnitude, limitLabelHeight)), limitedToNumberOfLines: 0).size
        if wSize.width < limitLabelWidth * CGFloat(label.numberOfLines) {
            addImageAttr(label: label, mulAttr: mulAttr)
            return true
        }
        
        adjustText(label: label, limitLabelWidth: limitLabelWidth, limitLabelHeight: limitLabelHeight)
        
        var text = label.text ?? ""
        let dot3Value = "... "
        // 最后添加一个dot3Value
        text.append(dot3Value)

        mulAttr = getAttributedStringByContent(text, textAligment: .left, lineBreakMode: .byTruncatingTail, lineSpacing: 5, font: label.font, color: label.textColor)
        
        addImageAttr(label: label, mulAttr: mulAttr)
        
        return true
    }
    
    static func addImageAttr(label: UILabel, mulAttr: NSMutableAttributedString) {
        // 获取文本的字体
        let font = label.font!
        
        let editAttachment = NSTextAttachment()
        editAttachment.image = UIImage(named: "ic_wordlist_edit")
        editAttachment.bounds = CGRect(x: 8, y: font.descender, width: font.lineHeight * editAttachment.image!.size.width / editAttachment.image!.size.height, height: font.lineHeight)
        mulAttr.append(NSAttributedString(attachment: editAttachment))
        
        label.attributedText = mulAttr
    }


    /// 递归裁剪label显示不下的字符
    /// - Parameters:
    ///   - label: -
    ///   - eachRemoveCharNum: 每次裁剪字符个数
    static func adjustText(label: UILabel, limitLabelWidth: CGFloat, limitLabelHeight: CGFloat, numberOfLines: Int = 2, eachRemoveCharNum: Int = 5) {
        
        // 获取无行数限制时的真实高度
        label.numberOfLines = 0
        label.sizeToFit()
        
        if label.height < limitLabelHeight {
            // 恢复行限制
            label.numberOfLines = numberOfLines
            return
        }
        
        // 如果高度相等则比较宽度
        if label.height == limitLabelHeight {
            let wSize = label.textRect(forBounds: CGRect(origin: label.bounds.origin, size: CGSizeMake(.greatestFiniteMagnitude, limitLabelHeight)), limitedToNumberOfLines: 0).size
            if wSize.width < limitLabelWidth * CGFloat(numberOfLines) {
                // 恢复行限制
                label.numberOfLines = numberOfLines
                return
            }
        }
        
        print(#function, "显示不下裁剪部分文字")
        
        var text = label.text ?? ""
        // 计算要移除的范围
        let range = text.index(text.endIndex, offsetBy: -eachRemoveCharNum)..<text.endIndex
        // 移除该范围的子字符串
        text.removeSubrange(range)
    //        text.replaceSubrange(range, with: "... ")
        // 重新赋值
        label.attributedText = getAttributedStringByContent(text, textAligment: .left, lineBreakMode: .byTruncatingTail, lineSpacing: 5, font: label.font, color: label.textColor)
        // 递归
        adjustText(label: label, limitLabelWidth: limitLabelWidth, limitLabelHeight: limitLabelHeight)
    }

    static func getAttributedStringByContent(_ content: String?,
                                     textAligment: NSTextAlignment,
                                     lineBreakMode: NSLineBreakMode,
                                     lineSpacing: CGFloat,
                                     font: UIFont,
                                     color: UIColor?) -> NSMutableAttributedString {
        guard let content = content else { return NSMutableAttributedString(string: "") }

        let attributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = lineBreakMode
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAligment

        let range = NSRange(location: 0, length: content.count)
        attributedString.addAttributes([
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: font
        ], range: range)

        if let color = color {
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }

        return attributedString
    }
}
