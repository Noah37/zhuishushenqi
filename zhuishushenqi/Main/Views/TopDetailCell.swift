//
//  TopDetailCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Kingfisher

class TopDetailCell: UITableViewCell {
 
    @IBOutlet weak var authorWidth: NSLayoutConstraint!
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var reading: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var model:Book?{
        didSet{
            self.remain.text = "\(self.model?.retentionRatio ?? "0")% 读者留存"
            self.reading.text = "\(self.model?.latelyFollower ?? "0") 人在追"
            self.profile.text = "\(self.model?.shortIntro ?? "")"
            self.type.text = "\(self.model?.cat ?? "")"
            self.name.text = "\(self.model?.title ?? "")"
            self.author.text = "\(self.model?.author ?? "")"
            let width = widthOfString(self.author.text ?? "", font: UIFont.systemFontOfSize(11), height: 21)
            self.authorWidth.constant = width + 5
            let urlString = "\((self.model?.cover ?? "" as NSString).substringFromIndex(7))"
            let url = NSURL(string: urlString)
            
            self.icon.kf_setImageWithURL(url, placeholderImage: UIImage(named: "default_book_cover"), optionsInfo: nil, progressBlock: nil, completionHandler: nil)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
