//
//  ZSNotificationCell.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSNotificationHandler = ()->Void

class ZSNotificationCell: UITableViewCell {
    
    lazy var iconView:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 18
        button.layer.masksToBounds = true
        button.addTarget(self, action: #selector(iconAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var msgLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var nickNameLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(red: 0.38, green: 0.38, blue: 0.4, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var levelLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.64, green: 0.64, blue: 0.64, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.layer.cornerRadius = 6.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 0.5
        return label
    }()
    
    lazy var commentBackgroundView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(red: 0.96, green: 0.96, blue: 0.96, alpha: 1)
        view.layer.cornerRadius = 4
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var commentLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor(red: 0.47, green: 0.47, blue: 0.5, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 13)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var msgTypeView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    var iconHandler:ZSNotificationHandler?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconView)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(msgLabel)
        contentView.addSubview(commentBackgroundView)
        commentBackgroundView.addSubview(commentLabel)
        commentBackgroundView.addSubview(msgTypeView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        iconView.frame = CGRect(x: 15, y: 24, width: 36, height: 36)
        let nickNameWidth = nickNameLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 19.3)).width
        nickNameLabel.frame = CGRect(x: iconView.frame.maxX + 9, y: 32.3, width: nickNameWidth, height: 19.3)
        let levelWith = levelLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 13)).width
        levelLabel.frame = CGRect(x: nickNameLabel.frame.maxX + 2, y: 35.7, width: levelWith * 2, height: 13)
        let msgLabelHeight = msgLabel.sizeThatFits(CGSize(width: bounds.width - 30 , height: CGFloat.greatestFiniteMagnitude)).height
        msgLabel.frame = CGRect(x: 15, y: iconView.frame.maxY + 14, width: bounds.width - 30, height: msgLabelHeight)
        let commentHeight = commentLabel.sizeThatFits(CGSize(width: bounds.width - 30 - 28, height: CGFloat.greatestFiniteMagnitude)).height
        commentLabel.frame = CGRect(x: 14, y: 14, width: bounds.width - 30 - 28, height: commentHeight)
        commentBackgroundView.frame = CGRect(x: 15, y: msgLabel.frame.maxY + 10, width: bounds.width - 30, height: commentHeight + 28)
        msgTypeView.frame = CGRect(x: 14, y: 16, width: 13, height: 13)
    }
    
    func configure(model:ZSNotification) {
        if model.type == .postPush {
            iconView.setImage(UIImage(named: "official_icon_30x30_"), for: .normal)
        } else {
            iconView.qs_setAvatarWithURLString(urlString: model.trigger?.avatar ?? "")
        }
        nickNameLabel.text = "\(model.trigger?.nickname ?? "")"
        levelLabel.text = "lv.\(model.trigger?.lv ?? 0)"
        
        levelLabel.isHidden = model.type == .postPush
        msgLabel.text = model.type == .postPush ? "\(model.title)":"\(model.comment?.content ?? "")"
        let prefixComment = model.type == .commentReply ? "\u{fff9}    ":"\u{fff9}    "
        commentLabel.text = model.type == .postPush ? "\u{fff9}   \(model.post?.title ?? "")":"\(prefixComment)\(model.myComment?.content ?? "")"
        msgTypeView.image = model.type.image
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    func heightFor(model:ZSNotification) ->CGFloat {
        configure(model: model)
        let height = self.commentBackgroundView.frame.maxY + 27
        return height
    }
    
    @objc
    private func iconAction(btn:UIButton) {
        iconHandler?()
    }

}
