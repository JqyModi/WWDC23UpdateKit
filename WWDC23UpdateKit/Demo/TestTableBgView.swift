//
//  TestTableBgView.swift
//  WWDC23UpdateKit
//
//  Created by Modi on 2023/11/13.
//

import SwiftUI
import MJRefresh

struct TestTableBgPreview: UIViewRepresentable {
    func makeUIView(context: Context) -> some UIView {
        return TestTableBgView().view
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        
    }
}

#Preview {
    TestTableBgPreview()
}

class TestTableBgView: UIViewController {
    lazy var tabContainerView: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.register(UITableViewCell.self, forCellReuseIdentifier: "section1")
        t.register(UITableViewCell.self, forCellReuseIdentifier: "section2")
        t.backgroundColor = .systemBlue
        t.tableFooterView = UIView()
        return t
    }()
    
    lazy var tableView1: UITableView = {
        let t = UITableView()
        t.delegate = self
        t.dataSource = self
        t.register(UITableViewCell.self, forCellReuseIdentifier: "section3")
        t.backgroundColor = .systemCyan
        t.tableFooterView = UIView()
        return t
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configViews()
    }
    
    func configViews() {
        view.backgroundColor = .systemFill
        tabContainerView.frame = view.bounds
        view.addSubview(tabContainerView)
        
        configRefresh()
    }
    
    func configRefresh() {
        let mjH = MJRefreshNormalHeader(refreshingBlock: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
                guard let strongSelf = self else { return }
                strongSelf.tabContainerView.mj_header?.endRefreshing()
            }
        })
        tabContainerView.mj_header = mjH
    }
}

extension TestTableBgView: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == tabContainerView {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tabContainerView {
            return 1
        }
        
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == tabContainerView {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "section1", for: indexPath)
                var config = cell.defaultContentConfiguration()
                config.text = "section1"
                cell.contentConfiguration = config
                cell.backgroundColor = .green
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "section2", for: indexPath)
                var config = cell.defaultContentConfiguration()
                config.text = "section2"
                cell.contentConfiguration = config
                cell.backgroundColor = .white
                tableView1.frame = cell.bounds
                cell.addSubview(tableView1)
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "section3", for: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = "section3"
            cell.contentConfiguration = config
            cell.backgroundColor = .green
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == tabContainerView {
            if indexPath.section == 0 {
                return 150
            } else {
                return tabContainerView.height - 150
            }
        } else {
            return 64
        }
    }
}

