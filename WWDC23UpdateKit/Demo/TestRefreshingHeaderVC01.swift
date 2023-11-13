//
//  TestRefreshingHeaderVC01.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/11/6.
//

import UIKit
import MJRefresh

class TestRefreshingHeaderVC01: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientBgView1: UIView!
    @IBOutlet weak var bgViewH: NSLayoutConstraint!
    
    lazy var tabHeaderView: UIView = {
        let image = UIImageView(image: UIImage(resource: .icWordlistEdit))
        image.frame = CGRect(x: 0, y: 0, width: 375, height: 100)
        image.backgroundColor = .clear
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }
    
    func configViews() {
        configBigBgColor()
        
        tableView.backgroundColor = .white
        
        tableView.tableHeaderView = tabHeaderView
        
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 80
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TestCell")
        
        let mjHeader = MJRefreshNormalHeader(refreshingBlock: {
            print("refreshing ----")
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.tableView.mj_header?.endRefreshing()
            }
        })
        mjHeader.backgroundColor = .clear
        tableView.mj_header = mjHeader
        
        configWhiteBg()
    }
    
    lazy var gradientBgView: MOJiFavInfoGradientView = {
        let view = MOJiFavInfoGradientView()
        let from = UIColor(hex: 0xFFBCBC).cgColor
        let to = UIColor(hex: 0x8B8787).cgColor
        view.gradientLayer.colors = [from, to]
        return view
    }()
    
    func configBigBgColor() {
        gradientBgView1.backgroundColor = .clear
        
        gradientBgView.frame = bgView.bounds
        bgView.insertSubview(gradientBgView, at: 0)
    }
    
    lazy var whiteBgView: MOJiFavInfoGradientView = {
        let view = MOJiFavInfoGradientView()
        let from = UIColor(hex: 0xFFBCBC).cgColor
        let to = UIColor(hex: 0x8B8787).cgColor
        view.gradientLayer.colors = [from, to]
        return view
    }()
    
//    lazy var whiteBgView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .white
//        return view
//    }()
    
    lazy var whiteBgContainerView: UIView = {
        let v = UIView()
        v.backgroundColor = .green
        return v
    }()
    
    func configWhiteBg() {
        whiteBgView.frame = CGRect(x: 0, y: -tableView.mj_y, width: view.mj_w, height: view.height)
        whiteBgContainerView.addSubview(whiteBgView)
        whiteBgContainerView.frame = tabHeaderView.frame
        tableView.insertSubview(whiteBgContainerView, at: 0)
    }

    lazy var tabMaskView: UIView = {
        let v = UIView()
        v.layer.mask = tabMaskLayer
        return v
    }()
    
    lazy var tabMaskLayer: CAGradientLayer = {
        // 创建一个CAShapeLayer
//        let maskLayer = CAShapeLayer()
        let maskLayer = CAGradientLayer()
        // 设置矩形的高度
        maskLayer.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.bgView.bounds.height)
        // 设置矩形的颜色
//        maskLayer.backgroundColor = UIColor.white.cgColor
        maskLayer.colors = [UIColor.clear.cgColor, UIColor.clear.cgColor, UIColor.white.cgColor]
        maskLayer.locations = [0, 0.13, 0.01]
        return maskLayer
    }()
    
    func configTableMaskView() {
        whiteBgView.layer.mask = tabMaskLayer
        let th = tableView.tableHeaderView?.mj_h ?? 0
        let ttop = tableView.mj_y
        let rate = (th + ttop) / view.mj_h
        tabMaskLayer.locations = [0, NSNumber(value: rate), 0.01]
    }
    
}

extension TestRefreshingHeaderVC01: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [5].randomElement()!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        // Configure content.
        content.image = UIImage(systemName: "star")
        content.text = "Favorites 第\(indexPath.row)项"
        // Customize appearance.
        content.imageProperties.tintColor = .purple
        cell.contentConfiguration = content
        cell.backgroundColor = .clear

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tt = CGFloat.random(in: 0.001...0.999)
        tabMaskLayer.locations = [0, NSNumber(value: tt), 0.01]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleRefreshingBgView(scrollView: scrollView)
    }
    
    func handleRefreshingBgView(scrollView: UIScrollView) {
        tableView.sendSubviewToBack(whiteBgContainerView)
        // 获取当前滚动的偏移量
        let yOffset = scrollView.contentOffset.y
//        var height = 375 - yOffset
//        if height <= tableView.mj_y {
//            height = tableView.mj_y
//        }
//        
//        print("height    -----------     \(height)")
//        gradientBgView1.height = height
//        bgViewH.constant = height
        
        let offset: CGFloat = 0
        if yOffset < 0 {
            whiteBgContainerView.frame = CGRect(x: 0, y: yOffset, width: scrollView.width, height: -yOffset + tabHeaderView.height + offset)
        } else {
            whiteBgContainerView.frame = CGRect(x: 0, y: 0, width: scrollView.width, height: tabHeaderView.height + offset)
        }
    }
}

import SwiftUI

struct TestRefreshingHeaderVC01View: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {
//        uiView.backgroundColor = .red
    }
    
    func makeUIView(context: Context) -> UIView {
        let vc = TestRefreshingHeaderVC01()
        return vc.view
    }
    
}

#Preview {
    return TestRefreshingHeaderVC01View()
}
