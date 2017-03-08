//
//  TopDetailCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit


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
            let width = widthOfString(self.author.text ?? "", font: UIFont.systemFont(ofSize: 11), height: 21)
            self.authorWidth.constant = width + 5
            self.icon.image = UIImage(named: "default_book_cover")
            if self.model?.cover == "" {
                return;
            }
            let urlString = "\(((self.model?.cover ?? "qqqqqqqq") as NSString).substring(from: 7))"
            let url = URL(string: urlString)
            if let urlstring = url {
                let resource:QSResource = QSResource(url: urlstring)
                self.icon.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"), options: nil, progressBlock: nil, completionHandler: nil)
            }
        }
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
