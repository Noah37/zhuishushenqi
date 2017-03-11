//
//  TopDetailCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit


class ThemeTopicCell: UITableViewCell {
 
    @IBOutlet weak var persueWidth: NSLayoutConstraint!
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var reading: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    var model:ThemeTopicModel?{
        didSet{
            self.remain.text = "\(self.model?.collectorCount ?? 0)人收藏"
            self.reading.text = "共\(self.model?.bookCount ?? 0) 本书"
            self.profile.text = "\(self.model?.desc ?? "")"
//            self.type.text = "\(self.model?.cat ?? "")"
            self.name.text = "\(self.model?.title ?? "")"
            self.author.text = "\(self.model?.author ?? "")"
            
            self.author.text = "\(self.model?.author ?? "")"
            let width = widthOfString(self.reading.text ?? "", font: UIFont.systemFont(ofSize: 11), height: 21)
            self.persueWidth.constant = width + 5
            
            self.icon.image = UIImage(named: "default_book_cover")
            if self.model?.cover == "" {
                return;
            }
            let urlString = "\(picBaseUrl)\(self.model?.cover ?? "qqqqqqqq")"
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
