//
//  TopicDetailHeaderCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class TopicDetailHeaderCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var updateTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var iconRect: UIImageView!
    @IBOutlet weak var bottomName: UILabel!
    @IBOutlet weak var share: UIButton!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var model:TopicDetailHeader? {
        didSet{
            self.isHidden = false
            self.name.text  = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
//            self.updateTime.text = ""
            self.title.text = "\(model?.title ?? "")"
            self.content.text = "\(model?.desc ?? "")"
            self.contentHeight.constant = model?.descHeight ?? 0
            self.bottomName.text = "\(model?.author.nickname ?? "")"
            self.iconRect.layer.cornerRadius = self.iconRect.bounds.width/2
            
            if self.model?.author.avatar == "" {
                return;
            }
            let urlString = "\(IMAGE_BASEURL)\(self.model?.author.avatar ?? "qqqqqqqq")"
            let url = URL(string: urlString)
            if let urlstring = url {
                let resource:QSResource = QSResource(url: urlstring)
                self.icon.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)
                self.iconRect.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)

            }
        }
    }
    
    static func height(model:TopicDetailHeader?)->CGFloat{
        if let header = model {
            let baseHeaderHeight:CGFloat = 176
            let baseHeaderTextHeight:CGFloat = 45
            let headerCell = UINib(nibName: "TopicDetailHeaderCell", bundle: nil).instantiate(withOwner: nil, options: nil).last as? TopicDetailHeaderCell
            headerCell?.model = header
            if header.descHeight > baseHeaderTextHeight {
                return header.descHeight - baseHeaderTextHeight + baseHeaderHeight
            }else{
                return baseHeaderHeight - (baseHeaderTextHeight - header.descHeight)
            }
        }
        return 0.0001
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
