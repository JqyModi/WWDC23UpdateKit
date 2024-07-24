//
//  LastTagLabelView.swift
//  TNShareApp
//
//  Created by J.qy on 2023/9/27.
//

import SwiftUI
import CharacterLocationSeeker
import YYText
import MJRefresh

let seeker = CharacterLocationSeeker()

extension UILabel {
    
    @discardableResult
    func lastCharFrame(label: UILabel, addPreviewView: Bool = false) -> CGRect {
        let text = (label.text ?? "") as NSString
        
        seeker.config(with: label)
        var textEndFrame = seeker.characterRect(at: UInt(text.length-1))
        print(#function, "计算结束，末尾字符frame为：", textEndFrame)

        textEndFrame.origin.x += self.mj_x
        textEndFrame.origin.y += self.mj_y
        
        // 添加一个测试View
        if addPreviewView {
            let view = UIView()
            view.backgroundColor = .red
            view.frame = textEndFrame
            label.superview?.addSubview(view)
        }
        
        return textEndFrame
    }

}

class LastTagLabel: UIView {

    var imagev = UIImageView(image: UIImage(resource: .icWordlistEdit))

    override init(frame: CGRect) {
        super.init(frame: frame)
//        testYYLabelLast()
        testLabelBounds()
    }
    
    func testYYLabelLast() {
        let label = YYLabel(frame: CGRect(x: 80, y: 300, width: 211, height: 48))
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16)
        let attr = NSMutableAttributedString(string: "This is a long label with multiple li This is a long label with multiple li This is a long label with multiple li")
        label.attributedText = attr
        addImageAttr(label: label, imageName: "ic_wordlist_edit")
        TestYYLabelLastView.addSeeMoreButton(yyLabel: label)
        addSubview(label)
    }
    
    func addImageAttr(label: YYLabel, imageName: String = "") {
        let mulAttr: NSMutableAttributedString = label.attributedText as! NSMutableAttributedString
        // 获取文本的字体
        let font = label.font!
        if imageName.isEmpty {
            return
        }
        let image = UIImage(named: imageName)
        let imageAttr = NSMutableAttributedString.yy_attachmentString(withContent: image, contentMode: .center, attachmentSize: image!.size, alignTo: font, alignment: .center)
        mulAttr.append(imageAttr)
        
        label.attributedText = mulAttr
    }
    
    func testLabelBounds() {
        // Example usage
        let label = UILabel(frame: CGRect(x: 80, y: 300, width: 211, height: 48))
        label.numberOfLines = 3
        label.text = "This is a long label with multiple lines. The last character is 's'.活得好好的会的话换肤大fjdlsaflkjdsalk"
        label.sizeToFit()
        print("label.bounds11111 === \(label.bounds)")
        addSubview(label)
        
        // 方式1
//        var lastCharFrame = label.lastCharFrame(label: label)
//        lastCharFrame.origin.x += label.frame.minX
//        lastCharFrame.origin.y += label.frame.minY
//        print("最后一个字符的位置：", lastCharFrame)
//        imagev.frame = lastCharFrame
//        addSubview(imagev)
        
        // 方式2
        label.lastCharFrame(label: label, addPreviewView: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

struct LastTagLabelView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        return LastTagLabel()
    }
}

#Preview {
    return LastTagLabel(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
 }



