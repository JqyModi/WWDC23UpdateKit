//
//  PushNotificationView.swift
//  TNShareApp
//
//  Created by J.qy on 2023/12/12.
//

import UIKit
import SnapKit
import SwiftUI

class PushNotificationViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 创建背景视图
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.96, alpha: 1.0)
        view.addSubview(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(80)
        }
        
        // 创建图标
        let iconImageView = UIImageView(image: UIImage(named: "notification_icon"))
        backgroundView.addSubview(iconImageView)
        iconImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(40)
        }
        
        // 创建标题标签
        let titleLabel = UILabel()
        titleLabel.text = "推送通知标题"
        titleLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        titleLabel.textColor = UIColor.black
        backgroundView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.top.equalToSuperview().inset(12)
        }
        
        // 创建内容标签
        let contentLabel = UILabel()
        contentLabel.text = "这是一条推送通知的内容示例。"
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.gray
        backgroundView.addSubview(contentLabel)
        contentLabel.snp.makeConstraints { make in
            make.leading.equalTo(iconImageView.snp.trailing).offset(12)
            make.bottom.equalToSuperview().inset(12)
        }
    }
}

struct PushNotificationView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        return PushNotificationViewController().view
    }
}

#Preview {
    let vc = PushNotificationViewController()
    return vc
}
