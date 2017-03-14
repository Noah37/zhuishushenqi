//
//  BookCommentViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

enum CommentType {
    case normal
    case magical
}

class BookCommentViewCell: UITableViewCell {
    @IBOutlet weak var readerIcon: UIImageView!
    @IBOutlet weak var floor: UILabel!
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var reply: UILabel!
    @IBOutlet weak var floorWidth: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var cellHeight:CGFloat = 44

    var type:CommentType = .normal
    var model:BookCommentDetail? {
        didSet{
            self.modelSetAction(model: model)
        }
    }
    
    @discardableResult
    func modelSetAction(model:BookCommentDetail?)->CGFloat{
        floor.text = "\(model?.floor ?? 0)楼"
        let width = widthOfString(floor.text ?? "", font: UIFont.systemFont(ofSize: 12), height: 21) + 5
        floorWidth.constant = width
        readerName.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
        createTime.text = "\(model?.created ?? "")"
        var replyHeight = reply.frame.height
        if type == .magical {
            createTime.text = "\(model?.likeCount ?? 0)同感"
        }
        if  model?.replyTo != nil {
            reply.isHidden = false
            reply.text = "回复\(model?.replyTo.author.nickname ?? "") (\(model?.replyTo.floor ?? 0)楼)"
        }else{
            replyHeight = 0
            reply.isHidden = true
        }
        
        content.text = "\(model?.content ?? "")"
        let height = heightOfString(content.text ?? "", font: UIFont.systemFont(ofSize: 12), width: self.bounds.width - 65) + 10
        contentHeight.constant = height
        cellHeight = floor.frame.minY + floor.frame.height + height + replyHeight
        
        self.readerIcon.layer.cornerRadius = 3
        self.readerIcon.layer.masksToBounds = true
        if self.model?.author.avatar == "" {
            return cellHeight
        }
        let urlString = "\(picBaseUrl)\(self.model?.author.avatar ?? "qqqqqqqq")"
        let url = URL(string: urlString)
        if let urlstring = url {
            let resource:QSResource = QSResource(url: urlstring)
            self.readerIcon.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        return cellHeight
    }
    
    static func cellHeight(model:BookCommentDetail?)->CGFloat{
        let cell:BookCommentViewCell? = UINib(nibName: "BookCommentViewCell", bundle: nil).instantiate(withOwner: self, options: nil)[0] as? BookCommentViewCell
        let height = cell?.modelSetAction(model: model)
        return height ?? 44
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
