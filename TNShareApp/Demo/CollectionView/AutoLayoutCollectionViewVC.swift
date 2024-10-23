//
//  AutoLayoutCollectionView.swift
//  TNShareApp
//
//  Created by J.qy on 2024/8/22.
//

import UIKit
import SnapKit

// MARK: - 参考：https://medium.com/swift2go/implementing-a-dynamic-height-uicollectionviewcell-in-swift-5-bdd912acd5c8

func randomString() -> String {
    let length = Int.random(in: 10...100)
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789" + "对于可以滚动展示数字的控件，网上也有其他人的实现，有人的解决思路是利用一个长长的多行的UILabel，每行展示一个数字，展示的动画其实是改变这个UILabel的位置。我的解决思路也很简单，就是利用两个UILabel轮流做位移动画和展示"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

class AutoLayoutCollectionViewCell: UICollectionViewCell {
    let titleL = UILabel()
    let descL = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configViews() {
        contentView.backgroundColor = .green
        titleL.backgroundColor = .red
        descL.backgroundColor = .yellow
        contentView.addSubview(titleL)
        contentView.addSubview(descL)
        
        titleL.numberOfLines = 0
        descL.numberOfLines = 0
        
        titleL.snp.makeConstraints { make in
            make.left.right.top.equalToSuperview().inset(8)
        }
        
        descL.snp.makeConstraints { make in
            make.top.equalTo(titleL.snp.bottom).offset(8)
            make.left.right.bottom.equalToSuperview().inset(8)
        }
    }
    
    func updateView(title: String, desc: String) {
        titleL.text = title
        descL.text = desc
    }
    
//    override func preferredLayoutAttributesFitting(
//        _ layoutAttributes: UICollectionViewLayoutAttributes
//    ) -> UICollectionViewLayoutAttributes {
//        layoutAttributes.bounds.size.height = contentView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
//        return layoutAttributes
//    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
}

class AutoLayoutCollectionViewVC: UIViewController {

    private struct Constant {
        static let layoutLineSpacing: CGFloat = 20
        static let layoutInteritemSpacing: CGFloat = 20
//        static let layoutItemWidth: CGFloat = (UIScreen.main.bounds.width - 20)/2
        static let layoutItemWidth: CGFloat = (UIScreen.main.bounds.width - 20)
        static let layoutItemHeight: CGFloat = 70
    }
    
    lazy var collectionView: UICollectionView! = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.layout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource      = self
        collectionView.delegate        = self
        collectionView.register(AutoLayoutCollectionViewCell.self, forCellWithReuseIdentifier: AutoLayoutCollectionViewCell.description())
        
        return collectionView
    }()
    
    lazy var layout: UICollectionViewFlowLayout! = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing            = Constant.layoutLineSpacing
        layout.minimumInteritemSpacing       = Constant.layoutInteritemSpacing
        layout.scrollDirection               = .vertical
        
        layout.estimatedItemSize             = CGSize(width: Constant.layoutItemWidth, height: Constant.layoutItemHeight)
        layout.itemSize                      = UICollectionViewFlowLayout.automaticSize
        
        return layout
    }()
    
    var models: [String] = (0...10).map({ _ in return randomString() })
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }
    
    private func configViews() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AutoLayoutCollectionViewVC: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AutoLayoutCollectionViewCell.description(), for: indexPath) as! AutoLayoutCollectionViewCell
        cell.updateView(title: models[indexPath.row], desc: models[indexPath.row])
        return cell
    }
}


import SwiftUI

struct AutoLayoutCollectionView: UIViewRepresentable {
    
    let vc = AutoLayoutCollectionViewVC()
    
//    func makeCoordinator() -> Coordinator {
//        return Coordinator(button: self, vc: vc)
//    }
//    
//    class Coordinator {
//        var button: AICodeVCView
//        var vc: AICodeVC
//        
//        init(button: AICodeVCView, vc: AICodeVC) {
//            self.button = button
//            self.vc = vc
//        }
//        
//        @objc func didTapCustomButton(sender: UIButton) {
//            vc.testView.backgroundColor = .green
//            vc.testView.backgroundColor = .yellow
//        }
//    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        return vc.view
    }
    
}

#Preview {
    return AutoLayoutCollectionView()
}
