//
//  ZSForumPageCell.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/13.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSForumPageCellDelegate:class {
    func forumCell(forumCell:ZSForumPageCell, clickIcon:UIButton)
    func forumCell(forumCell:ZSForumPageCell, clickLike:UIButton)
    func forumCell(forumCell:ZSForumPageCell, clickMore:UIButton)
}

class ZSForumPageCell: UITableViewCell {
    
    weak var delegate:ZSForumPageCellDelegate?
    
    private lazy var avatarView:UIButton = {
        let view = UIButton(type: .custom)
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(avatarAction(btn:)), for: .touchUpInside)
        return view
    }()
    
    private lazy var nicknameLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var levelLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.textColor = UIColor.gray
        label.layer.cornerRadius = 6.5
        label.layer.masksToBounds = true
        label.layer.borderColor = UIColor.gray.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private lazy var displayView:ZSDisplayView = {
        let view = ZSDisplayView(frame: .zero)
        return view
    }()
    
    private lazy var timeLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var floorLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var messageCountLabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var likeButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_like02_26_26"), for: .normal)
        button.addTarget(self, action: #selector(likeAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    private lazy var moreButton:UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(named: "bbs_icon_more_big_26_26"), for: .normal)
        button.addTarget(self, action: #selector(moreAction(btn:)), for: .touchUpInside)
        return button
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(avatarView)
        contentView.addSubview(nicknameLabel)
        contentView.addSubview(levelLabel)
        contentView.addSubview(displayView)
        contentView.addSubview(timeLabel)
        contentView.addSubview(floorLabel)
        contentView.addSubview(likeButton)
        contentView.addSubview(messageCountLabel)
        contentView.addSubview(moreButton)

        avatarView.snp.makeConstraints { (make) in
            make.top.left.equalTo(20)
            make.width.height.equalTo(40)
        }
        
        nicknameLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.avatarView.snp_right).offset(20)
            make.top.equalTo(20)
            make.height.equalTo(14)
            make.width.equalTo(0)
        }
        
        levelLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.nicknameLabel.snp_right).offset(5)
            make.top.equalTo(20)
            make.height.equalTo(14)
            make.width.equalTo(40)
        }
        displayView.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.nicknameLabel.snp_left)
            make.top.equalTo(self.nicknameLabel.snp_bottom).offset(10)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(0)
        }
        timeLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.displayView.snp_left)
            make.height.equalTo(14)
            make.width.equalTo(0)
            make.bottom.equalToSuperview().offset(-14)
        }
        floorLabel.snp.makeConstraints { [unowned self](make) in
            make.left.equalTo(self.timeLabel.snp_right).offset(10)
            make.height.equalTo(self.timeLabel.snp_height)
            make.width.equalTo(0)
            make.bottom.equalToSuperview().offset(-14)
        }
        
        moreButton.snp.makeConstraints { [unowned self](make) in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.displayView.snp_bottom).offset(10)
            make.width.equalTo(26)
            make.height.equalTo(26)
            make.bottom.equalToSuperview().offset(-10)
        }
        
        messageCountLabel.snp.makeConstraints { [unowned self](make) in
            make.right.equalTo(self.moreButton.snp_left).offset(0)
            make.width.equalTo(30)
            make.height.equalTo(14)
            make.bottom.equalTo(self.moreButton.snp_bottom).offset(-2)
        }
        
        likeButton.snp.makeConstraints { [unowned self](make) in
            make.right.equalTo(self.messageCountLabel.snp_left).offset(0)
            make.width.height.equalTo(26)
            make.top.equalTo(self.moreButton.snp_top)
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
    
    func configure(model:ZSForumComment) {
        self.avatarView.qs_setAvatarWithURLString(urlString: model.author.avatar)
        self.nicknameLabel.text = model.author.nickname
        let size = self.nicknameLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14))
        nicknameLabel.snp.updateConstraints { (make) in
            make.width.equalTo(size.width)
        }
        self.levelLabel.text = "lv.\(model.author.lv)"
        let parser = MarkupParser()
        let settings = CTSettings()
        settings.pageRect = CGRect(x: settings.pageRect.origin.x, y: settings.pageRect.origin.y, width: self.displayView.bounds.width, height: settings.pageRect.height)
        parser.parseContent(model.content, settings: settings)
        displayView.snp.updateConstraints { (make) in
            make.height.equalTo(parser.coreData?.height ?? 0)
        }
        displayView.buildContent(attr: parser.attrString, andImages: parser.coreData?.images ?? [], settings: settings)
        timeLabel.qs_setCreateTime(createTime: model.created, append: "")
        let timeSize = timeLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14))
        timeLabel.snp.updateConstraints { (make) in
            make.width.equalTo(timeSize.width)
        }
        floorLabel.text = "\(model.floor)楼"
        let floorSize = floorLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 14))
        floorLabel.snp.updateConstraints { (make) in
            make.width.equalTo(floorSize.width)
        }
        messageCountLabel.text = "\(model.likeCount)"
    }
    
    @objc
    private func avatarAction(btn:UIButton) {
        delegate?.forumCell(forumCell: self, clickIcon: btn)
    }
    
    @objc
    private func likeAction(btn:UIButton) {
        delegate?.forumCell(forumCell: self, clickLike: btn)
    }

    @objc
    private func moreAction(btn:UIButton) {
        delegate?.forumCell(forumCell: self, clickMore: btn)
    }
}
