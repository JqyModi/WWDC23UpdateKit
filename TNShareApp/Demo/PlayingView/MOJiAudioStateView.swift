//
//  MOJiAudioStateView.swift
//  TNShareApp
//
//  Created by J.qy on 2024/5/10.
//

import UIKit
import SwiftUI

class MOJiAudioStateDotView: UIView {
    lazy var defaultView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xACACAC).withAlphaComponent(0.4)
        view.layer.cornerRadius = 2
        return view
    }()
    
    lazy var selectedView = {
        let view = UIView()
        view.backgroundColor = UIColor(hex: 0xF9D6DE).withAlphaComponent(0.2)
        view.layer.cornerRadius = 4
        let redView = UIView()
        redView.backgroundColor = UIColor(hex: 0xE0315B)
        redView.layer.cornerRadius = 2
        
        view.addSubview(redView)
        redView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSizeMake(4, 4))
        }
        
        return view
    }()
    
    var isSelected: Bool = false {
        didSet {
            updateStyle()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(defaultView)
        addSubview(selectedView)
        
        defaultView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSizeMake(4, 4))
        }
        
        selectedView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSizeMake(8, 8))
        }
        
        // 默认值
        self.isSelected = false
    }
    
    func updateStyle() {
        if isSelected {
            defaultView.isHidden = true
            selectedView.isHidden = false
        } else {
            defaultView.isHidden = false
            selectedView.isHidden = true
        }
    }
}

class MOJiAudioStateView: UIView {
    lazy var currentIndexLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20, weight: .medium)
        return label
    }()
    
    lazy var totalIndexLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.textColor = UIColor(hex: 0xACACAC)
        return label
    }()
    
    lazy var playStateStack = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        return stack
    }()
    
    lazy var playStateLabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor(hex: 0xE0315B)
        return label
    }()
    
    lazy var playStateBorder = {
        let border = UIView()
        border.backgroundColor = .clear
        border.layer.borderColor = UIColor(hex: 0xECECEC).cgColor
        border.layer.borderWidth = 1
        border.layer.cornerRadius = 16
        border.addSubview(playStateLabel)
        
        playStateLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        return border
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        setupDotView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(currentIndexLabel)
        addSubview(totalIndexLabel)
        addSubview(playStateStack)
        addSubview(playStateBorder)
        
        currentIndexLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalTo(16)
        }
        
        totalIndexLabel.snp.makeConstraints { make in
            make.bottom.equalTo(currentIndexLabel.snp.bottom)
            make.left.equalTo(currentIndexLabel.snp.right).offset(8)
        }
        
        playStateStack.snp.makeConstraints { make in
            make.bottom.equalTo(totalIndexLabel.snp.bottom).offset(-5)
            make.left.equalTo(totalIndexLabel.snp.right).offset(8)
        }
        
        playStateBorder.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalTo(-16)
            make.size.equalTo(CGSizeMake(107, 30))
            make.left.greaterThanOrEqualTo(playStateStack.snp.right)
        }
    }
    
    func setupDotView() {
        let dot1 = MOJiAudioStateDotView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        let dot2 = MOJiAudioStateDotView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        dot2.isSelected = true
        let dot3 = MOJiAudioStateDotView(frame: CGRect(x: 0, y: 0, width: 8, height: 8))
        playStateStack.addArrangedSubview(dot1)
        playStateStack.addArrangedSubview(dot2)
        playStateStack.addArrangedSubview(dot3)
        
        currentIndexLabel.text = "1"
        totalIndexLabel.text = "/ 12"
        playStateLabel.text = "播放2次｜1.0X"
    }
}

struct AudioStateView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let view = MOJiAudioStateView(frame: CGRect(x: 0, y: 0, width: 375, height: 80))
        return view
    }
    
}

#Preview {
    return AudioStateView()
}
