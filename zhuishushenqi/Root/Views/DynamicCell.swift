//
//  DynamicCell.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/10/22.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class DynamicCell: UITableViewCell {
    
    var model:QSHotModel?

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var forward: UIImageView!
    @IBOutlet weak var transfer: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var update: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var comment: UIButton!
    @IBOutlet weak var publish: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setContent(model:QSHotModel){
        self.model = model
        setNeedsDisplay()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let urlString = self.model?.user.avatar ?? ""
        self.icon.qs_setAvatarWithURLString(urlString: urlString)
        transfer.isHidden = true
        forward.isHidden = true
        author.text = "\(self.model?.user.nickname ?? "") lv.\(self.model?.user.lv ?? 0)"
        title.text = "\(self.model?.tweet.title ?? "")"
        content.text = "\(self.model?.tweet.content ?? "")"
        comment.setTitle("\(self.model?.tweet.commented ?? 0)" , for: .normal)
        publish.setTitle("\(self.model?.tweet.retweeted ?? 0)", for: .normal)
        update.qs_setCreateTime(createTime: self.model?.tweet.hotAt ?? "", append: "")
    }
    
}
