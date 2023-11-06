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
    
    lazy var tabHeaderView: UIView = {
        let image = UIImageView(image: UIImage(resource: .icWordlistEdit))
        image.frame = CGRect(x: 0, y: 0, width: 375, height: 100)
        image.backgroundColor = .systemMint
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configViews()
    }
    
    func configViews() {
        bgView.backgroundColor = .systemPink
        
        tableView.backgroundColor = .clear
//        let bgView = UIView()
//        bgView.backgroundColor = .systemCyan
//        tableView.backgroundView = bgView
        
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
        mjHeader.backgroundColor = .systemTeal
        tableView.mj_header = mjHeader
        
//        tableView.performBatchUpdates {} completion: { succ in
//            self.configWhiteBg()
//        }
        
        configWhiteBg()

    }
    
    lazy var whiteBgView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemFill
        return view
    }()
    
    func configWhiteBg() {
//        if (whiteBgView.superview != nil) {
//            tableView.sendSubviewToBack(whiteBgView)
//            return
//        }
        
        let tabHeaderView = tableView.tableHeaderView ?? UIView()
        
        whiteBgView.frame = CGRect(x: 32, y: tabHeaderView.mj_h, width: view.mj_w - 64, height: view.mj_h)
//        tableView.insertSubview(whiteBgView, at: 0)
        tableView.addSubview(whiteBgView)
    }

}

extension TestRefreshingHeaderVC: UITableViewDataSource, UITableViewDelegate {
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

        return cell
    }
}

#Preview {
    return TestRefreshingHeaderVC()
}
