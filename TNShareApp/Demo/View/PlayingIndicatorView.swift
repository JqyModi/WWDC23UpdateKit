//
//  PlayingIndicatorView.swift
//  TNShareApp
//
//  Created by J.qy on 2023/11/9.
//

import SwiftUI

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

#Preview {
    let bgView = UIView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100)))
    let pv = PlayingIndicatorView(frame: CGRect(origin: CGPoint(x: 100, y: 100), size: CGSize(width: 100, height: 100)))
    pv.setPlaying(false)
    pv.setImage(nil, placeholderImage: nil)
    pv.backgroundColor = .red
    bgView.addSubview(pv)
    return bgView
}
