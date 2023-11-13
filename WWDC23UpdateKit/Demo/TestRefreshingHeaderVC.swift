//
//  TestRefreshingHeaderVC.swift
//  WWDC23UpdateKit
//
//  Created by J.qy on 2023/11/6.
//

import UIKit
import MJRefresh

class TestRefreshingHeaderVC: UIViewController {

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var gradientBgView1: UIView!
    @IBOutlet weak var bgViewH: NSLayoutConstraint!
    
    @IBAction func tapEmpty(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            models = []
            tableView.reloadData()
        } else {
            let tt = [[1,2,3,4,4,5,6,7,34,56], [1,2,3,4,4,5,6,7,8,9,10,56], [1,2,8,9,10,11,23,34,56], [1,2,3,4,4,5,6]]
            models = tt.randomElement() ?? [1,2]
            tableView.reloadData()
        }
    }
    
    var models: [Int] = [1,2,3,4,4]
    
    lazy var tabHeaderView: UIView = {
        let image = UIImageView(image: UIImage(resource: .icWordlistEdit))
        image.frame = CGRect(x: 0, y: 0, width: 375, height: 100)
        image.backgroundColor = .clear
        return image
    }()
    
    lazy var tabFooterView: UIView = {
        let image = UIView()
        image.frame = CGRect(x: 0, y: 0, width: 375, height: tableView.height-tabHeaderView.height)
        image.backgroundColor = .white
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }
    
    func configViews() {
        configBigBgColor()
        
        tableView.backgroundColor = .clear
        
        tableView.tableHeaderView = tabHeaderView
        tableView.tableHeaderView?.height = 100
        
        bgViewH.constant = tableView.mj_y + tabHeaderView.height
        
        tableView.tableFooterView = tabFooterView
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
//        gradientBgView.frame = gradientBgView1.bounds
        gradientBgView1.addSubview(gradientBgView)
        gradientBgView.translatesAutoresizingMaskIntoConstraints = false
        
        gradientBgView.leadingAnchor.constraint(equalTo: gradientBgView1.leadingAnchor).isActive = true
        gradientBgView.trailingAnchor.constraint(equalTo: gradientBgView1.trailingAnchor).isActive = true
        gradientBgView.topAnchor.constraint(equalTo: gradientBgView1.topAnchor).isActive = true
        gradientBgView.bottomAnchor.constraint(equalTo: gradientBgView1.bottomAnchor).isActive = true
    }
    
//    lazy var whiteBgView: MOJiFavInfoGradientView = {
//        let view = MOJiFavInfoGradientView()
//        let from = UIColor(hex: 0xFFBCBC).cgColor
//        let to = UIColor(hex: 0x8B8787).cgColor
//        view.gradientLayer.colors = [from, to]
//        return view
//    }()
    
    lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    func configWhiteBg() {
        whiteBgView.frame = CGRect(x: 0, y: 0, width: view.mj_w, height: view.mj_h)
        bgView.insertSubview(whiteBgView, aboveSubview: gradientBgView)
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

extension TestRefreshingHeaderVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return [models.count, 0].randomElement() ?? 0
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
        cell.backgroundColor = .white

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tt = CGFloat.random(in: 0.001...0.999)
        tabMaskLayer.locations = [0, NSNumber(value: tt), 0.01]
    }
    
//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        if models.isEmpty {
//            return tableView.height - tabHeaderView.height
//        }
//        
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        if models.isEmpty {
//            let v = UIView()
//            v.backgroundColor = .white
//            return v
//        }
//        
//        return nil
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        handleRefreshingBgView(scrollView: scrollView)
    }
    
    func handleRefreshingBgView(scrollView: UIScrollView) {
        // 获取当前滚动的偏移量
        let yOffset = scrollView.contentOffset.y
        var height = (tableView.mj_y + tabHeaderView.height + 100) - yOffset
        if height <= tableView.mj_y {
            height = tableView.mj_y
        }
        
        print("height    -----------     \(height)")
        gradientBgView1.height = height
        bgViewH.constant = height
    }
}

import SwiftUI

struct TestRefreshingHeaderVCView: UIViewRepresentable {
    func updateUIView(_ uiView: UIView, context: Context) {
//        uiView.backgroundColor = .red
    }
    
    func makeUIView(context: Context) -> UIView {
        let vc = TestRefreshingHeaderVC()
        return vc.view
    }
    
}

#Preview {
    return TestRefreshingHeaderVCView()
}


