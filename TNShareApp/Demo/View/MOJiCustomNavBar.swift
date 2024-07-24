//
//  AINavigationBar.swift
//  TNShareApp
//
//  Created by J.qy on 2023/12/12.
//

import UIKit

// 定义一个自定义的UIView子类
class AINavigationBar: UIView {

    // 定义UI元素的属性
    let backButton = UIButton()
    let titleLabel = UILabel()
    let functionButton = UIButton()

    // 定义一个初始化方法，接收一个参数，表示是否显示功能按钮
    init(showFunctionButton: Bool) {
        super.init(frame: .zero)

        // 添加UI元素到view中
        addSubview(backButton)
        addSubview(titleLabel)
        addSubview(functionButton)

        // 配置UI元素的样式和内容
        backButton.setImage(UIImage(named: "back"), for: .normal)

        titleLabel.text = "标题文本"
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18)

        functionButton.setImage(UIImage(named: "function"), for: .normal)
        functionButton.isHidden = !showFunctionButton // 根据参数决定是否显示功能按钮

        // 使用SnapKit布局UI元素的位置和大小
        backButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }

        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        functionButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
        }
    }

    // 必须实现的方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

