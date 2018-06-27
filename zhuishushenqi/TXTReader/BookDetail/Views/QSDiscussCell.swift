//
//  QSDiscussCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/24.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSDiscussCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var model:BookComment? {
        didSet{
            icon.qs_setAvatarWithURLString(urlString: model?.author.avatar ?? "")
            name.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
            contentLabel.text = "\(model?.title ?? "")"
            commentLabel.text = "\(model?.commentCount ?? 0)"
            likeLabel.text = "\(model?.likeCount ?? 0)"
            timeLabel.qs_setCreateTime(createTime: model?.created ?? "", append: "")
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.layer.cornerRadius = 5
        backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
