//
//  HotCommentCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class HotCommentCell: UITableViewCell {

    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var publishTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var userfulBtn: UIButton!
    
    var darkView:DarkView?
    var lightView:LightView?
    
    var model:QSHotComment?{
        didSet{
            let imageUrlString =  "\(picBaseUrl)\(model?.author.avatar ?? "")"
            let url:URL? = URL(string: imageUrlString)
            if let imageUrl = url {
                let resource:QSResource = QSResource(url: imageUrl)
                self.iconView?.kf.setImage(with: resource, placeholder: UIImage(named: "default_avatar_light"), options: nil, progressBlock: nil, completionHandler: nil)
            }
            self.userNameLabel.text = "\(model?.author.nickname ?? "")"
            self.titleLabel.text = "\(model?.title ?? "")"
            self.contentLabel.text = "\(model?.content ?? "")"
            self.userfulBtn.setTitle("\(model?.likeCount ?? 0)", for: .normal)
            let width = (1 + 10*(model?.rating ?? 60) + ((model?.rating ?? 60) - 1)*2)
            self.lightView?.frame = CGRect(x: 65 , y: 53, width: width, height: 10)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initSubview()
    }
    
    func initSubview(){
        darkView = DarkView(frame: CGRect(x: 65, y: 53, width: 60, height: 10))
        lightView = LightView(frame: CGRect(x: 65, y: 53, width: 60, height: 10))

        contentView.addSubview(darkView!)
        contentView.addSubview(lightView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)


    }
    
}
