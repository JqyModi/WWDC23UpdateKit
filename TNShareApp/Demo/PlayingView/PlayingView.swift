//
//  PlayingView.swift
//  TNShareApp
//
//  Created by J.qy on 2024/5/10.
//

import SwiftUI
import Lottie
import UIKit
import SnapKit

#Preview {
    PlayingView()
}


class AudioProgressView: UIView {
    private let normalRingView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xECECEC)
        view.layer.cornerRadius = 50
        return view
    }()
    
    private let highlightRingView = {
        let view = UIView()
        view.backgroundColor = .init(hex: 0xE0315B)
        view.layer.cornerRadius = 50
        return view
    }()
    
    private let playingAnimateView = LottieAnimationView(name: "musicAni01")
    
    var isPlaying: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        
        playingAnimateView.loopMode = .loop
        playingAnimateView.play()
//        playingAnimateView.pause()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if normalRingView.width > 0 {
            setupNormalRingViewMask()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        
        addSubview(normalRingView)
        normalRingView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
        addSubview(highlightRingView)
        highlightRingView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 100, height: 100))
            make.center.equalToSuperview()
        }
        addSubview(playingAnimateView)
        playingAnimateView.snp.makeConstraints { make in
            make.size.equalTo(CGSize(width: 80, height: 80))
            make.center.equalToSuperview()
        }
    }
    
    func setupNormalRingViewMask() {
        let centerPoint = CGPoint(x: normalRingView.bounds.midX, y: normalRingView.bounds.midY)
        let path = UIBezierPath(arcCenter: centerPoint, radius: 50, startAngle: 0, endAngle: CGFloat.pi * 2, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.lineWidth = 8
        
        normalRingView.layer.mask = shapeLayer
    }
    
    func updateProgress(_ progress: CGFloat) {
        let angle = CGFloat.pi * 2 * progress
        let centerPoint = CGPoint(x: highlightRingView.bounds.midX, y: highlightRingView.bounds.midY)
        
        let startAngle = CGFloat(-0.5 * .pi)
        let endAngle = startAngle + angle
        let path = UIBezierPath(arcCenter: centerPoint, radius: 50, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = UIColor.red.cgColor
        shapeLayer.lineWidth = 8
        shapeLayer.lineCap = .round
//        shapeLayer.lineDashPattern = [10,5,5,5]
        
        highlightRingView.layer.mask = shapeLayer
    }
}

class TestVC: UIViewController {
    var timer: Timer?
    var progress: CGFloat = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create and add the AudioProgressView instance
        let audioProgressView = AudioProgressView(frame: .zero)
        view.addSubview(audioProgressView)
        
        audioProgressView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        // Start a timer to update the progress
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
            self.progress += 0.001
            if self.progress > 1.0 {
                self.progress = 0.0
            }
            audioProgressView.updateProgress(self.progress)
        }
        audioProgressView.updateProgress(0.5)
    }
    
    deinit {
        timer?.invalidate()
    }
}

struct PlayingView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        let vc = TestVC()
        return vc.view
    }
    
}

#Preview {
    return PlayingView()
}
