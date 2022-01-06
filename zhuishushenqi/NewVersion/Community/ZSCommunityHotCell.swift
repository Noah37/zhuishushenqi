//
//  ZSCommunityHotCell.swift
//  zhuishushenqi
//
//  Created by yung on 2022/1/6.
//  Copyright © 2022 QS. All rights reserved.
//

import UIKit

protocol ZSCommunityHotCellDelegate:AnyObject {
    func community(cell:ZSCommunityHotCell, clickIcon:UIButton)
    func community(cell:ZSCommunityHotCell, clickFocus:UIButton)
    func community(cell:ZSCommunityHotCell, clickMsg:UIButton)
    func community(cell:ZSCommunityHotCell, clickShare:UIButton)
}

class ZSCommunityHotCell: UITableViewCell {
    
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
        label.textAlignment = .center
        label.layer.cornerRadius = 6.5
        label.layer.borderColor = UIColor.darkGray.cgColor
        label.layer.borderWidth = 0.5
        return label
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    lazy var contentLabel:ZSDisplayView = {
        let label = ZSDisplayView(frame: .zero)
//        label.textColor = UIColor.init(red: 0.54, green: 0.54, blue: 0.56, alpha: 1)
//        label.font = UIFont.systemFont(ofSize: 14)
//        label.numberOfLines = 4
        return label
    }()
    
    lazy var timeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = UIColor.init(red: 0.54, green: 0.54, blue: 0.56, alpha: 1)
        label.font = UIFont.systemFont(ofSize: 12)
        return label
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
        button.addTarget(self, action: #selector(shareAction(btn:)), for: .touchUpInside)
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
        button.addTarget(self, action: #selector(focusAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    weak var delegate:ZSCommunityHotCellDelegate?
    
    @objc
    private func iconAction(btn:UIButton) {
        delegate?.community(cell: self, clickIcon: btn)
    }

    @objc
    private func commentAction(btn:UIButton) {
        delegate?.community(cell: self, clickMsg: btn)
    }
    
    @objc
    private func focusAction(btn:UIButton) {
        delegate?.community(cell: self, clickFocus: btn)
    }
    
    @objc
    private func shareAction(btn:UIButton) {
        delegate?.community(cell: self, clickShare: btn)
    }
    
    func congfigure(model:ZSCommunityHot) {
        self.iconButton.qs_setAvatarWithURLString(urlString: model.author.avatar)
        self.nickNameLabel.text = "\(model.author.nickname)"
//        self.tagView.image = model.user.type.image
        self.levelLabel.text = "lv.\(model.author.lv)"
        self.timeLabel.qs_setCreateTime(createTime: "\(model.created)", append: "")
        self.titleLabel.text = "回答问题：\(model.title)"
//        self.contentLabel.text = "\(model.content)"
        
        let parser = MarkupParser()
        parser.parseContent(model.content, settings: CTSettings.shared)
        contentLabel.snp.updateConstraints { (make) in
            make.height.equalTo(parser.coreData?.height ?? 0)
        }
        contentLabel.buildContent(attr: parser.attrString, andImages: parser.coreData?.images ?? [], settings: CTSettings.shared)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(iconButton)
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(tagView)
        contentView.addSubview(levelLabel)
        contentView.addSubview(timeLabel)
//        contentView.addSubview(forumImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(contentLabel)
//        contentView.addSubview(insertedScoreView)
        contentView.addSubview(msgButton)
        contentView.addSubview(shareButton)
        contentView.addSubview(msgLabel)
        contentView.addSubview(shareLabel)
        contentView.addSubview(focusButton)
        
        contentView.layer.masksToBounds = true
        
        iconButton.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(25)
            make.width.height.equalTo(20)
        }
        
        nickNameLabel.snp.makeConstraints { make in
            make.left.equalTo(self.iconButton.snp.right).offset(5)
            make.top.equalTo(25)
            make.height.equalTo(20)
        }
        
        tagView.snp.makeConstraints { make in
            make.left.equalTo(self.nickNameLabel.snp.right).offset(5)
            make.top.equalTo(30)
            make.height.equalTo(10)
            make.width.equalTo(25)
        }
        
        levelLabel.snp.makeConstraints { make in
            make.left.equalTo(self.tagView.snp.right).offset(5)
            make.top.equalTo(30)
            make.height.equalTo(10)
            make.width.equalTo(25)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(self.iconButton.snp.bottom).offset(10)
            make.width.equalTo(self).offset(-40)
            make.height.equalTo(15)
        }
        
        contentLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(self.titleLabel.snp.bottom).offset(5)
            make.width.equalTo(self).offset(-40)
            make.height.equalTo(30)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(20)
            make.top.equalTo(self.contentLabel.snp.bottom).offset(5)
            make.height.equalTo(12)
        }
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

}
