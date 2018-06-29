//
//  HotCommentCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017 QS. All rights reserved.
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
    
    var model:BookComment?{
        didSet{
            self.iconView.qs_setAvatarWithURLString(urlString: model?.author.avatar ?? "")
            self.userNameLabel.text = "\(model?.author.nickname ?? "")"
            self.titleLabel.text = "\(model?.title ?? "")"
            //文本过长会有卡顿现象
            if (model?.content.characters.count ?? 0) > 40 {
                self.contentLabel.text = "\(model?.content.qs_subStr(to: 40) ?? "")"
            }else{
                self.contentLabel.text = "\(model?.content ?? "")"
            }
            self.userfulBtn.setTitle("\(model?.likeCount ?? 0)", for: .normal)
            let ratingValue = model?.rating ?? 60
            let width = (1 + 10*ratingValue + (ratingValue - 1)*2)
            self.lightView?.frame = CGRect(x: 65 , y: 53, width: width, height: 10)
            self.publishTimeLabel.text = ""
            let created = model?.created ?? "2014-02-23T16:48:18.179Z"
            self.publishTimeLabel.qs_setCreateTime(createTime: created,append:"")
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initSubview()
    }
    
    func initSubview(){
        darkView = DarkView(frame: CGRect(x: 65, y: 53, width: 60, height: 10), image: UIImage(named: "bd_star_empty"))
        lightView = LightView(frame: CGRect(x: 65, y: 53, width: 60, height: 10), image: UIImage(named: "bd_star_filled"))

        contentView.addSubview(darkView!)
        contentView.addSubview(lightView!)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
