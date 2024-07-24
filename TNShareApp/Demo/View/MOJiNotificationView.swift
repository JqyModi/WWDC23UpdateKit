//
//  MOJiNotificationView.swift
//  TNShareApp
//
//  Created by J.qy on 2023/12/12.
//

import UIKit

// 定义一个自定义的UIView子类
class MOJiNotificationView: UIView {

    // 定义UI元素的属性
    let iconImageView = UIImageView()
    let textLabel = UILabel()
    let borderView = UIView()
    let arrowImageView = UIImageView()

    // 重写初始化方法
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemGray

        // 添加UI元素到view中
        addSubview(borderView) // 先添加borderView
        borderView.addSubview(iconImageView) // 然后添加其他UI元素到borderView中
        borderView.addSubview(textLabel)
        borderView.addSubview(arrowImageView)

        // 配置UI元素的样式和内容
        iconImageView.image = UIImage(systemName: "person.circle.fill")
        iconImageView.layer.cornerRadius = 14

        textLabel.text = "1条新消息"
        textLabel.textColor = UIColor.white
        textLabel.font = UIFont.systemFont(ofSize: 14, weight: .medium)

        borderView.backgroundColor = UIColor.black
        borderView.layer.borderColor = UIColor.gray.cgColor
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 20

        arrowImageView.image = UIImage(systemName: "chevron.right")

        // 使用SnapKit布局UI元素的位置和大小
        borderView.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(20)
            make.right.lessThanOrEqualTo(-20)
            make.center.equalToSuperview()
            make.width.equalTo(138)
            make.height.equalTo(40)
        }

        iconImageView.snp.makeConstraints { make in
            make.left.equalTo(6)
            make.centerY.equalToSuperview()
            make.size.equalTo(28)
        }

        textLabel.snp.makeConstraints { make in
            make.left.equalTo(iconImageView.snp.right).offset(8)
            make.centerY.equalToSuperview()
        }

        arrowImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
    }

    // 必须实现的方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//#Preview(traits: .fixedLayout(width: 375, height: 100), body: {
//    MOJiNotificationView(frame: CGRectMake(0, 0, 375, 80))
//})


import SnapKit

class GiftButton: UIButton {

    private let imageV = UIImageView()
    private let label = UILabel()
    private let arrowView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupView() {
        
        imageV.image = UIImage(systemName: "person.circle")
        imageV.contentMode = .scaleAspectFit

        label.text = "赠送了礼物"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black

        arrowView.image = UIImage(systemName: "chevron.forward")
        arrowView.contentMode = .scaleAspectFit

        addSubview(imageV)
        addSubview(label)
        addSubview(arrowView)

        imageV.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(50)
        }

        label.snp.makeConstraints { make in
            make.top.equalTo(imageV.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        arrowView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().offset(-50)
            make.width.height.equalTo(20)
        }
    }

}

#Preview {
    let v = UIView()
    let button = GiftButton(frame: CGRectMake(0, 100, 414, 150))
//    button.snp.makeConstraints { make in
//        make.center.equalToSuperview()
//    }
    button.backgroundColor = .cyan
    v.addSubview(button)
    return v
}
