//
//  ZSCommunityCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSCommunityCell: UITableViewCell {
    
    lazy var iconButton:UIButton = {
        let button = UIButton(type: .custom)
        button.addTarget(self, action: #selector(iconAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var nickNameLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.38, green: 0.38, blue: 0.4, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 15)
        return label
    }()
    
    lazy var tagView:UIImageView = {
        let imageView = UIImageView(image: UIImage(named: ""))
        return imageView
    }()
    
    lazy var levelLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.64, green: 0.64, blue: 0.64, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 9)
        return label
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.54, green: 0.54, blue: 0.56, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var contentLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.54, green: 0.54, blue: 0.56, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 4
        return label
    }()
    
    lazy var insertedScoreView:ZSInsertedBookScoreView = {
        let scoreView = ZSInsertedBookScoreView(frame: .zero)
        return scoreView
    }()
    
    lazy var msgButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_topic_26_26_26x26_"), for: .normal)
        button.addTarget(self, action: #selector(commentAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_share_26_26_26x26_"), for: .normal)
        button.addTarget(self, action: #selector(commentAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    lazy var msgLabel:UILabel = {
        let button = UILabel(frame: .zero)
        button.textColor = UIColor.init(red: 0.72, green: 0.72, blue: 0.74, alpha: 1)
        button.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    lazy var shareLabel:UILabel = {
        let button = UILabel(frame: .zero)
        button.textColor = UIColor.init(red: 0.72, green: 0.72, blue: 0.74, alpha: 1)
        button.font = UIFont.systemFont(ofSize: 12)
        return button
    }()
    
    lazy var focusButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.cornerRadius = 14
        button.layer.masksToBounds = true
        button.backgroundColor = UIColor.init(red: 0.93, green: 0.28, blue: 0.27, alpha: 1)
        button.setTitle("关注", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.addTarget(self, action: #selector(commentAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    var model:QSHotModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconButton)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(levelLabel)
        contentView.addSubview(timeLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(insertedScoreView)
        contentView.addSubview(msgButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(msgLabel)
        contentView.addSubview(shareLabel)
        contentView.addSubview(focusButton)
        
        contentView.layer.masksToBounds = true
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
        iconButton.frame = CGRect(x: 15, y: 25, width: 35, height: 35)
        let nickNameWidth = nickNameLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 18)).width
        nickNameLabel.frame = CGRect(x: 58, y: 23, width: nickNameWidth, height: 18)
        tagView.frame = CGRect(x: nickNameLabel.frame.maxX + 5, y: 26, width: 12, height: 12)
        let levelWith = levelLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 13)).width
        levelLabel.frame = CGRect(x: tagView.frame.maxX + 5, y: 26, width: levelWith, height: 13)
        timeLabel.frame = CGRect(x: 58, y: 45, width: 100, height: 13)
        titleLabel.frame = CGRect(x: 15, y: 80, width: bounds.width - 30, height: 25)
        contentLabel.frame = CGRect(x: 15, y: 118, width: bounds.width - 30, height: 79)
        insertedScoreView.frame = CGRect(x: 15, y: 205, width: bounds.width - 30, height: 125)
        insertedScoreView.height = model?.tweet.book == nil ? 0:125
        msgLabel.frame = CGRect(x: bounds.width/2 - 40 - 17.5, y: insertedScoreView.frame.maxY + 19, width: 40, height: 17)
        msgButton.frame = CGRect(x: msgLabel.frame.minX - 26 - 10, y: insertedScoreView.frame.maxY + 14, width: 26, height: 26)
        
        shareButton.frame = CGRect(x: bounds.width/2 + 17.5, y: insertedScoreView.frame.maxY + 14, width: 26, height: 26)
        shareLabel.frame = CGRect(x: shareButton.frame.maxX + 10, y: insertedScoreView.frame.maxY + 19, width: 40, height: 17)
        focusButton.frame = CGRect(x: bounds.width - 75, y: 30, width: 60, height: 28)
        
        self.iconButton.imageView?.qs_addCornerRadius(cornerRadius: 17.5)
        

    }
    
    func congfigure(model:QSHotModel) {
        self.model = model
        self.iconButton.qs_setAvatarWithURLString(urlString: model.user.avatar)
        self.nickNameLabel.text = "\(model.user.nickname)"
        self.levelLabel.text = "lv.\(model.user.lv)"
        self.timeLabel.qs_setCreateTime(createTime: "\(model.tweet.created)", append: "")
        self.titleLabel.text = "\(model.tweet.title)"
        self.contentLabel.text = "\(model.tweet.content)"
        self.insertedScoreView.configure(model: model.tweet.book)
        self.msgLabel.text = "\(model.tweet.commented)"
        self.shareLabel.text = "\(model.tweet.retweeted)"
        setNeedsLayout()
        layoutIfNeeded()
    }
    
    @objc
    private func iconAction(btn:UIButton) {
        
    }

    @objc
    private func commentAction(btn:UIButton) {
        
    }
}
