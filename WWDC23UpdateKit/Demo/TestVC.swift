//
//  TestVC.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/9/27.
//

import UIKit
import CharacterLocationSeeker
import YYText

let seeker = CharacterLocationSeeker()

extension UILabel {
    func frameForLastCharacter() -> CGRect? {
        guard let text = self.text, !text.isEmpty else {
            return nil
        }

        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize(width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        let textStorage = NSTextStorage(string: text)

        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)

        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines

        let range = NSRange(location: 0, length: textStorage.length)
        let boundingRect = layoutManager.usedRect(for: textContainer)

        let lastCharIndex = layoutManager.characterIndex(for: CGPoint(x: boundingRect.size.width - 1, y: boundingRect.size.height - 1), in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)

        if lastCharIndex < range.location + range.length {
            let lastCharRange = NSRange(location: lastCharIndex, length: 1)
            let glyphRange = layoutManager.glyphRange(forCharacterRange: lastCharRange, actualCharacterRange: nil)
            let glyphRect = layoutManager.boundingRect(forGlyphRange: glyphRange, in: textContainer)

            return glyphRect
        }

        return nil
    }
    
    func lastCharacterFrame(label: UILabel) -> CGRect {
        // 获取 label 的 numberOfLines 属性
        let numberOfLines = label.numberOfLines
        
        // 获取 label 的 attributedText 属性
        let attributedText = label.attributedText
        
        // 获取 label 的 font 属性
        let font = label.font
        
        // 获取 label 的 attributedText 属性的字符数
        let characterCount = attributedText?.string.count ?? 0
        
        // 计算最后一个显示字符的 index
        let lastCharacterIndex = characterCount - 1
        
        // 获取最后一个显示字符的 frame
        let lastCharacterFrame = attributedText?.boundingRect(with: label.bounds.size, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil) ?? .zero
        
        // 获取最后一个显示字符的 x 坐标
        let lastCharacterX = lastCharacterFrame.origin.x + lastCharacterFrame.size.width
        
        // 获取最后一个显示字符的 y 坐标
        let lastCharacterY = lastCharacterFrame.origin.y + lastCharacterFrame.size.height
        
        // 判断最后一个显示字符是否位于最后一行
        if lastCharacterIndex < numberOfLines {
            // 如果位于最后一行，则返回最后一个显示字符的 frame
            return lastCharacterFrame
        } else {
            // 如果不位于最后一行，则返回 label 的 frame
            return label.frame
        }
    }
    
    func lastCharFrame(label: UILabel, addPreviewView: Bool = false) -> CGRect {
        let text = (label.text ?? "") as NSString
        
        seeker.config(with: label)
        var textEndFrame = seeker.characterRect(at: UInt(text.length-1))
//        textEndFrame.origin.y += 200
        print(#function, "计算结束，末尾字符frame为：", textEndFrame)
        
        // 添加一个测试View
//        if addPreviewView {
//            let view = UIView()
//            view.backgroundColor = .red
//            view.frame = textEndFrame
//            label.superview?.addSubview(view)
//        }
        
        return textEndFrame
    }

}

class TestVC: UIView {

    var imagev = UIImageView(image: UIImage(resource: .icWordlistEdit))

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        testYYLabelLast()
    }
    
    func testYYLabelLast() {
        let label = YYLabel(frame: CGRect(x: 80, y: 300, width: 211, height: 48))
        label.numberOfLines = 2
        let attr = NSMutableAttributedString(string: "This is a long label with multiple lines. The last character is 's'.活得好好的会的话换肤大")
        label.attributedText = attr
        addImageAttr(label: label, mulAttr: attr)
//        TestYYLabelLastView.addSeeMoreButton(yyLabel: label)
        addSubview(label)
    }
    
    func addImageAttr(label: YYLabel, mulAttr: NSMutableAttributedString) {
        // 获取文本的字体
        let font = label.font!
        
        let editAttachment = NSTextAttachment()
        editAttachment.image = UIImage(named: "ic_wordlist_edit")
        editAttachment.bounds = CGRect(x: 8, y: font.descender, width: font.lineHeight * editAttachment.image!.size.width / editAttachment.image!.size.height, height: font.lineHeight)
        mulAttr.append(NSAttributedString(attachment: editAttachment))
        
        label.attributedText = mulAttr
    }
    
    func testLabelBounds() {
        // Example usage
        let label = UILabel(frame: CGRect(x: 80, y: 300, width: 211, height: 48))
        label.numberOfLines = 2
        label.text = "This is a long label with multiple lines. The last character is 's'.活得好好的会的话换肤大"
        label.sizeToFit()
        print("label.bounds11111 === \(label.bounds)")
        addSubview(label)
//        var lastCharFrame = label.lastCharFrame(label: label) ?? .zero
////        lastCharFrame.size.width += 50
//        lastCharFrame.origin.x += label.frame.minX
//        lastCharFrame.origin.y += label.frame.minY
//        print("最后一个字符的位置：", lastCharFrame)
////        let view1 = UIView(frame: lastCharFrame)
//        imagev.frame = lastCharFrame
////        view1.backgroundColor = .red
//        addSubview(imagev)
////        self.bringSubviewToFront(view1)
            
        print("height === \(label.mj_h)")
        print("width === \(label.mj_w)")
        let size = CGSize(width: label.mj_w, height: CGFloat.greatestFiniteMagnitude)
//        let frame = label.attributedText?.boundingRect(with: size, options: [.usesLineFragmentOrigin], context: nil)
        label.numberOfLines = 0
        label.sizeToFit()
        print("label.bounds22222 === \(label.bounds)")
        let frame = label.textRect(forBounds: CGRect(origin: label.bounds.origin, size: CGSize(width: .greatestFiniteMagnitude, height: label.bounds.height)), limitedToNumberOfLines: 0)
//        let frame = label.text!.boundingRect(with: size, options: .usesLineFragmentOrigin, context: nil)
        
        print("height111111 === \(frame.height)")
        
        addPreView(frame: frame, label: label)
    }
    
    func addPreView(frame: CGRect, label: UILabel) {
        var frame = frame
        frame.origin.x += label.frame.minX
        frame.origin.y += label.frame.minY - 50

        let v = UIView(frame: frame)
        v.backgroundColor = .systemMint
        addSubview(v)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    return TestVC(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
 }



