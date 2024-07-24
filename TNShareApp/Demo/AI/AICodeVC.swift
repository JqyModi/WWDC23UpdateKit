//
//  AICodeVC.swift
//  TNShareApp
//
//  Created by J.qy on 2023/12/12.
//

import UIKit

class AICodeVC: UIViewController {
    
    let testView: UIView = {
        let v = UIView()
        v.backgroundColor = .red
        return v
    }()
    
    lazy var btn: UIButton = {
        let btn = UIButton()
        btn.setTitle("开始", for: .normal)
        btn.addTarget(self, action: #selector(tapTestView), for: .touchUpInside)
        return btn
    }()
    
    lazy var navbar: AINavigationBar = {
        let nb = AINavigationBar(showFunctionButton: true)
        nb.titleLabel.text = "AICode"
        return nb
    }()
    
    lazy var headerV: MOJiNotificationView = {
        return MOJiNotificationView(frame: CGRectMake(0, 0, 375, 150))
    }()
    
    lazy var tableView: UITableView = {
        let tableV = UITableView()
        tableV.backgroundColor = .clear
        tableV.mj_header = nil
        tableV.mj_footer = nil
        tableV.tableFooterView = UIView()
        tableV.separatorStyle = .none
        tableV.register(AICommentCell.self, forCellReuseIdentifier: AICommentCell.description())
        tableV.dataSource = self
        tableV.delegate = self
        tableV.tableHeaderView = headerV
        return tableV
    }()
    
    public private(set) var models: [Any] = [1,2,3]

    override func viewDidLoad() {
        super.viewDidLoad()
        configViews()
    }
    
    func configViews() {
        view.backgroundColor = .clear
        
        configNavBar()
//        configTableView()
    }
    
    func configNavBar() {
        view.addSubview(navbar)
        navbar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.right.equalToSuperview()
            make.height.equalTo(44)
        }
        
        view.addSubview(testView)
        testView.snp.makeConstraints { make in
            make.edges.equalTo(navbar)
        }
        
        
        view.addSubview(btn)
        btn.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(100)
            make.height.equalTo(80)
        }
        
        testView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapTestView)))
        testView.isUserInteractionEnabled = true
    }
    
    func configTableView() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(navbar.snp.bottom)
            make.left.bottom.right.equalToSuperview()
        }
    }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//        
//        testView.backgroundColor = .green
//        
//        testView.backgroundColor = .yellow
//    }
    
    @objc func tapTestView() {
        testView.backgroundColor = .green
        
        testView.backgroundColor = .yellow
    }
    
}

extension AICodeVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: AICommentCell.description())
        as! AICommentCell
        // 配置cell的数据
//        cell.userImageView.image = UIImage(systemName: "star")
//        cell.userNameLabel.text = "UserName hehehhehehehehheheh"
//        cell.subjectTitleLabel.text = "targetTitle hehehhehehehehheheh"
//        cell.commentLabel.text = "comment hehehhehehehehheheh, hehehhehehehehhehehm, hehehhehehehehheheh, hehehhehehehehheheh"
//        cell.timeStampLabel.text = "09:48"
//        cell.replyButton.addTarget(...)
//        cell.likeButton.addTarget(...)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 56
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
}

import SwiftUI

struct AICodeVCView: UIViewRepresentable {
    
    let vc = AICodeVC()
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(button: self, vc: vc)
    }
    
    class Coordinator {
        var button: AICodeVCView
        var vc: AICodeVC
        
        init(button: AICodeVCView, vc: AICodeVC) {
            self.button = button
            self.vc = vc
        }
        
        @objc func didTapCustomButton(sender: UIButton) {
            vc.testView.backgroundColor = .green
            vc.testView.backgroundColor = .yellow
        }
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
    
    func makeUIView(context: Context) -> UIView {
        vc.btn.addTarget(context.coordinator, action: #selector(Coordinator.didTapCustomButton(sender:)), for: .touchUpInside)
        return vc.view
    }
    
}

#Preview {
    return AICodeVCView()
}
