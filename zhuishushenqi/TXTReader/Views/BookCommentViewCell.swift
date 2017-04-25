//
//  BookCommentViewCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

enum CommentType {
    case normal
    case magical
}

class BookCommentViewCell: UITableViewCell {
//    @IBOutlet weak var readerIcon: UIImageView!
//    @IBOutlet weak var floor: UILabel!
//    @IBOutlet weak var readerName: UILabel!
//    @IBOutlet weak var createTime: UILabel!
//    @IBOutlet weak var content: UILabel!
//    @IBOutlet weak var reply: UILabel!
//    @IBOutlet weak var floorWidth: NSLayoutConstraint!
//    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var readerIcon: UIImageView = {
        let readerIcon = UIImageView()
        return readerIcon
    }()
    var floor: UILabel = {
        let floor = UILabel()
        floor.font = UIFont.systemFont(ofSize: 12)
        return floor
    }()
    var readerName: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor(red: 0.78, green: 0.55, blue: 0.19, alpha: 1.0)
        return label
    }()
    var createTime: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 11)
        label.textAlignment = .right
        return label
    }()
    var content: YYLabel = {
        let label = YYLabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.numberOfLines = 0
        return label
    }()
    var reply: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    var contentPane:UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return view
    }()
    
    var cellHeight:CGFloat = 44

    var type:CommentType = .normal
    var model:BookCommentDetail?
    
    override func prepareForReuse() {
        self.floor.text = ""
        self.readerName.text = ""
        self.createTime.text = ""
        self.content.text = ""
        self.reply.text = ""
    }
    
    static func cellHeight(model:BookCommentDetail)->CGFloat{
        let contentHeight = model.textLayout?.textBoundingRect.size.height ?? 0
        var height = contentHeight + 15 + 21 + 15
        if contentHeight < 19 {
            height = CGFloat(15 + 15 + 40)
        }
        if let _ = model.replyTo?._id {
            height += (21 + 5)
        }
        return height
    }
    
    func setLayout(){
        self.contentPane.snp.makeConstraints{ (make) -> Void in
            make.top.left.right.equalTo(self.contentView)
        }
        self.readerIcon.snp.makeConstraints { (make) in
            make.top.left.equalTo(self.contentView).offset(15)
            make.width.height.equalTo(40)
        }
        self.createTime.snp.makeConstraints { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.top.equalTo(self.floor.snp.top)
        }
        self.floor.snp.makeConstraints { (make) in
            make.top.equalTo(self.readerIcon)
            make.left.equalTo(self.readerIcon.snp.right).offset(5)
        }
        self.readerName.snp.makeConstraints { (make) in
            make.left.equalTo(self.floor.snp.right).offset(10)
            make.top.equalTo(self.floor.snp.top)
            make.height.equalTo(self.floor.snp.height)
            make.right.equalTo(self.createTime.snp.left).offset(-10)
        }
        
        self.reply.snp.makeConstraints { (make) in
            make.left.equalTo(self.floor.snp.left)
            make.bottom.equalTo(self.contentPane.snp.bottom).offset(-10)
            make.right.equalTo(self.contentView).offset(-15)
        }
        self.content.snp.makeConstraints { (make) in
            make.left.equalTo(self.floor.snp.left)
            make.top.equalTo(self.floor.snp.bottom).offset(5)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.reply.snp.top).offset(-10)
        }
        self.contentPane.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.contentView.snp.bottom)
        }
    }
    
    func setupSubviews(){
        self.contentView.addSubview(self.contentPane)
        contentPane.addSubview(readerIcon)
        contentPane.addSubview(floor)
        contentPane.addSubview(readerName)
        contentPane.addSubview(createTime)
        contentPane.addSubview(content)
        contentPane.addSubview(reply)
        
        setLayout()
    }
    
    func bind(model:BookCommentDetail){
        floor.text = "\(model.floor)楼"
        readerName.text = "\(model.author.nickname) lv.\(model.author.lv)"
        let created = model.created
        self.createTime.qs_setCreateTime(createTime: created, append: "")
        if type == .magical {
            createTime.text = "\(model.likeCount)同感"
        }
        if  model.replyTo != nil {
            reply.isHidden = false
            reply.text = "回复\(model.replyTo?.author.nickname ?? "") (\(model.replyTo?.floor ?? 0)楼)"
        }else{
            reply.isHidden = true
        }
        content.text = "\(model.content)"
        let urlString = "\(IMAGE_BASEURL)\(self.model?.author.avatar ?? "qqqqqqqq")"
        self.readerIcon.qs_setAvatarWithURLString(urlString: urlString)
        
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        readerIcon.qs_addCornerRadius(cornerRadius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
