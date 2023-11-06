//
//  TestVC.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/9/27.
//

import UIKit
import CharacterLocationSeeker

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
        
//        addSubview(imagev)
//        imagev.frame = CGRect(x: 20, y: 20, width: 80, height: 40)
        
        addSubview(UISwitch())
        
        
        // Example usage
        let label = UILabel(frame: CGRect(x: 80, y: 300, width: 200, height: 200))
        label.numberOfLines = 0
        label.text = "This is a long label with multiple lines. The last character is 's'.活得好好的会的话换肤大"
        label.sizeToFit()
        addSubview(label)
        var lastCharFrame = label.lastCharFrame(label: label) ?? .zero
//        lastCharFrame.size.width += 50
        lastCharFrame.origin.x += label.frame.minX
        lastCharFrame.origin.y += label.frame.minY
        print("最后一个字符的位置：", lastCharFrame)
//        let view1 = UIView(frame: lastCharFrame)
        imagev.frame = lastCharFrame
//        view1.backgroundColor = .red
        addSubview(imagev)
//        self.bringSubviewToFront(view1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

#Preview {
    return TestVC(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
 }


class PlayingIndicatorView: UIView {
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    private var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                startRotationAnimation()
            } else {
                stopRotationAnimation()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(imageView)
        // 设置 imageView 的约束，这里根据需求自行调整
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    // 设置播放状态，true 表示播放，false 表示停止
    func setPlaying(_ playing: Bool) {
        isPlaying = playing
    }
    
    // 设置播放状态，true 表示播放，false 表示停止
    func setImage(_ imgURL: URL?, placeholderImage: UIImage?) {
//        self.imageView.moji_setImage(with: imgURL, placeholderImage: placeholderImage ?? MDUIUtils.defaultFolderCoverFullImage())
        self.imageView.backgroundColor = .gray
    }
    
    // 启动旋转动画
    private func startRotationAnimation() {
        let rotationAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.fromValue = 0
        rotationAnimation.toValue = Double.pi * 2
        rotationAnimation.duration = 2.0 // 旋转一圈的时间
        rotationAnimation.repeatCount = .greatestFiniteMagnitude // 无限重复
        imageView.layer.add(rotationAnimation, forKey: "rotationAnimation")
    }
    
    // 停止旋转动画
    private func stopRotationAnimation() {
        imageView.layer.removeAnimation(forKey: "rotationAnimation")
    }
}

//#Preview {
//    let bgView = UIView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100)))
//    let pv = PlayingIndicatorView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100)))
//    pv.setPlaying(false)
//    pv.setImage(nil, placeholderImage: nil)
//    pv.backgroundColor = .red
//    bgView.addSubview(pv)
//    return bgView
//}



