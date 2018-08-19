//
//  ZSReviewsCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/19.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSReviewsCell: UITableViewCell {

    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var book: UILabel!
    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var useful: UILabel!
    @IBOutlet weak var date: UILabel!
    @IBOutlet weak var flag: UIImageView!
    
    var model:BookComment?

    var tags:[[String:String]] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(model:BookComment){
        self.model = model
        book.text = "\(model.book.title)[\(pyToHz(py: model.book.type))]"
        content.text = "\(model.title)"
        useful.text = "\(model.helpful.total + model.helpful.no)/\(model.helpful.yes + model.helpful.no) 有用"
        date.qs_setCreateTime(createTime: self.model?.created ?? "", append: "")
        icon.qs_setBookCoverWithURLString(urlString: "\(model.book.cover)")
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
    }
    
    func tag(items:[[String:String]]) {
        self.tags = items
    }
    
    func pyToHz(py:String)->String{
        var hz = ""
        if py == "qt" {
            hz = "其它"
        } else {
            for item in self.tags {
                if item["value"] == py {
                    hz = item["title"] ?? ""
                    break
                }
            }
        }
        return hz
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
