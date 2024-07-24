//
//  AICommentCell.swift
//  TNShareApp
//
//  Created by J.qy on 2023/12/12.
//

import UIKit
import SnapKit

// 定义一个自定义的UITableViewCell子类
class AICommentCell: UITableViewCell {

    // 定义UI元素的属性
    let userImageView = UIImageView()
    let userNameLabel = UILabel()
    let subjectTitleLabel = UILabel()
    let commentLabel = UILabel()
    let timeStampLabel = UILabel()
    let replyButton = UIButton()
    let likeButton = UIButton()

    // 重写初始化方法
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .lightGray
        print("调用初始化方法")
        
        // 添加UI元素到cell的contentView中
        contentView.addSubview(userImageView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(subjectTitleLabel)
        contentView.addSubview(commentLabel)
        contentView.addSubview(timeStampLabel)
        contentView.addSubview(replyButton)
        contentView.addSubview(likeButton)

        // 配置UI元素的样式和内容
        userImageView.image = UIImage(named: "user")
        userImageView.layer.cornerRadius = 20
        userImageView.layer.masksToBounds = true
        userImageView.backgroundColor = .yellow

        userNameLabel.text = "用户名"
        userNameLabel.textColor = UIColor.white
        userNameLabel.font = UIFont.systemFont(ofSize: 16)
        userImageView.backgroundColor = .systemPink

        subjectTitleLabel.text = "被评论的主体标题"
        subjectTitleLabel.textColor = UIColor.white
        subjectTitleLabel.font = UIFont.systemFont(ofSize: 16)
        userImageView.backgroundColor = .gray

        commentLabel.text = "评论内容"
        commentLabel.textColor = UIColor.white
        commentLabel.font = UIFont.systemFont(ofSize: 14)
        commentLabel.numberOfLines = 0
        userImageView.backgroundColor = .blue

        timeStampLabel.text = "时间戳"
        timeStampLabel.textColor = UIColor.white
        timeStampLabel.font = UIFont.systemFont(ofSize: 12)
        userImageView.backgroundColor = .brown

        replyButton.setImage(UIImage(named: "reply"), for: .normal)

        likeButton.setImage(UIImage(named: "like"), for: .normal)

        // 使用SnapKit布局UI元素的位置和大小
        userImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(20)
            make.size.equalTo(40)
        }

        userNameLabel.snp.makeConstraints { make in
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.top.equalToSuperview().offset(20)
        }

        subjectTitleLabel.snp.makeConstraints { make in
            make.left.equalTo(userNameLabel.snp.right).offset(10)
            make.top.equalToSuperview().offset(20)
        }

        commentLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(userNameLabel.snp.bottom).offset(5)
        }

        timeStampLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(commentLabel.snp.bottom).offset(5)
        }

        replyButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(60)
            make.top.equalTo(timeStampLabel.snp.bottom).offset(10)
            make.size.equalTo(20)
        }

        likeButton.snp.makeConstraints { make in
            make.left.equalTo(replyButton.snp.right).offset(10)
            make.top.equalTo(timeStampLabel.snp.bottom).offset(10)
            make.size.equalTo(20)
        }
    }

    // 必须实现的方法
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
