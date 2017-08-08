//
//  QSHelpViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSHelpViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var commentCount: UIButton!
    @IBOutlet weak var likeCount: UIButton!
    @IBOutlet weak var createdTime: UILabel!
    
    @IBOutlet weak var official: UIImageView!
    @IBOutlet weak var flag: UIImageView!
    var model:BookComment?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureCell(model:BookComment){
        self.model = model
        nickName.text = "\(self.model?.author.nickname ?? "") lv.\(self.model?.author.lv ?? 0)"
        title.text = "\(self.model?.title ?? "")"
        commentCount.setTitle("\(self.model?.commentCount ?? 0)", for: .normal)
        likeCount.setTitle("\(self.model?.likeCount ?? 0)", for: .normal)
        createdTime.qs_setCreateTime(createTime: self.model?.created ?? "", append: "")
        icon.qs_setAvatarWithURLString(urlString: "\(self.model?.author.avatar ?? "")")
        let state = self.model?.state
        if state == "normal" {
            flag.isHidden = true
        }else if state == "distillate" {
            flag.isHidden = false
            flag.image = UIImage(named: "f_distillate")
        }else if state == "hot" {
            flag.isHidden = false
            flag.image = UIImage(named: "f_hot")
        }else if state == "focus" {
            flag.isHidden = false
            flag.image = UIImage(named: "f_today_topic")
        }
        
        let type = self.model?.author.type
        if type == "official" {
            official.image = UIImage(named: "f_official_icon")
            official.isHidden = false
        }else if type == "normal" {
            official.isHidden = true
        }else if type == "doyen" {
            official.isHidden = false
            official.image = UIImage(named: "f_doyen_icon")
        }
        icon.qs_addCornerRadius(cornerRadius: 5)
    }
    
    func isToday()->Bool{
        let year = self.model?.created.qs_subStr(to: 4) ?? "2017"
        let month = self.model?.created.qs_subStr(start: 5, end: 7) ?? "06"
        let day = self.model?.created.qs_subStr(start: 8, length: 2) ?? "18"
        let today = Date()
        if today.year() == Int(year) && today.month() == Int(month) && today.day() == Int(day) {
            return true
        }
        return false
    }
}
