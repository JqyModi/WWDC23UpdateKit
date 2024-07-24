//
//  MOJiAudioPlayerView.swift
//  TNShareApp
//
//  Created by J.qy on 2024/5/10.
//

import UIKit
import SwiftUI

class MOJiAudioPlayerView: UIView {
    lazy var back2SecondBtn = {
        let btn = UIButton()
        return btn
    }()
    lazy var previousBtn = {
        let btn = UIButton()
        return btn
    }()
    lazy var playBtn = {
        let btn = UIButton()
        return btn
    }()
    lazy var nextBtn = {
        let btn = UIButton()
        return btn
    }()
    lazy var viewBtn = {
        let btn = UIButton()
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        addSubview(back2SecondBtn)
        addSubview(previousBtn)
        addSubview(playBtn)
        addSubview(nextBtn)
        addSubview(viewBtn)
        
        back2SecondBtn.backgroundColor = UIColor.random()
        previousBtn.backgroundColor = UIColor.random()
        playBtn.backgroundColor = UIColor.random()
        nextBtn.backgroundColor = UIColor.random()
        viewBtn.backgroundColor = UIColor.random()
        
        back2SecondBtn.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(20)
            make.size.equalTo(CGSizeMake(28, 28))
        }
        
        previousBtn.snp.makeConstraints { make in
            make.left.greaterThanOrEqualTo(back2SecondBtn.snp.right).offset(16)
            make.centerY.equalTo(back2SecondBtn)
            make.size.equalTo(CGSizeMake(16, 16))
        }
        
        playBtn.snp.makeConstraints { make in
            make.left.equalTo(previousBtn.snp.right).offset(20)
            make.centerX.equalToSuperview()
            make.centerY.equalTo(back2SecondBtn)
            make.size.equalTo(CGSizeMake(38, 38))
        }
        
        nextBtn.snp.makeConstraints { make in
            make.left.equalTo(playBtn.snp.right).offset(20)
            make.centerY.equalTo(back2SecondBtn)
            make.size.equalTo(CGSizeMake(16, 16))
        }
        
        viewBtn.snp.makeConstraints { make in
            make.centerY.equalTo(back2SecondBtn)
            make.right.equalTo(-22)
            make.size.equalTo(CGSizeMake(20, 14))
        }
        
    }
    
}


struct AudioPlayerView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let view = MOJiAudioPlayerView(frame: CGRect(x: 0, y: 0, width: 375, height: 96))
        return view
    }
    
}

#Preview {
    return AudioPlayerView()
}
