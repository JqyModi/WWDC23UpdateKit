//
//  TestYYLabelLastView.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/11/9.
//

import SwiftUI
import YYText

struct TestYYLabelLastView: View {
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    TestYYLabelLastView()
}

extension TestYYLabelLastView {
    static func addSeeMoreButton(yyLabel: YYLabel) {
        let text = NSMutableAttributedString(string: "...more")

        let highlight = YYTextHighlight()
        highlight.setColor(UIColor(red: 0.578, green: 0.790, blue: 1.000, alpha: 1.000))
        highlight.tapAction = { (containerView, text, range, rect) in
            yyLabel.sizeToFit()
        }

        text.yy_setColor(UIColor(red: 0.000, green: 0.449, blue: 1.000, alpha: 1.000), range: (text.string as NSString).range(of: "more"))
        text.yy_setTextHighlight(highlight, range: (text.string as NSString).range(of: "more"))
        text.yy_font = yyLabel.font

        let seeMoreLabel = YYLabel()
        seeMoreLabel.attributedText = text
        seeMoreLabel.sizeToFit()

        let truncationToken = NSAttributedString.yy_attachmentString(withContent: seeMoreLabel,
                                                                     contentMode: .center,
                                                                     attachmentSize: seeMoreLabel.size,
                                                                     alignTo: text.yy_font!,
                                                                                alignment: .center)
        yyLabel.truncationToken = truncationToken
    }

}
