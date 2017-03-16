//
//  HotCommentCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
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
            self.publishTimeLabel.text = ""
            
            let created = model?.created ?? "2014-02-23T16:48:18.179Z"
            if created.lengthOfBytes(using: String.Encoding.utf8) > 18{
                
                let year = created.subStr(to: 4) 
                let month = created.sub(start: 5, end: 7) 
                let day = created.sub(start: 8, length: 2) 
                let hour = created.sub(start: 11, length: 2) 
                let mimute = created.sub(start: 14, length: 2) 
                let second = created.sub(start: 17, length: 2)
                let beginDate = NSDate.getWithYear(year, month: month, day: day, hour: hour, mimute: mimute, second: second)
                let endDate = Date()
                let formatter = DateIntervalFormatter()
                let out = formatter.timeInfo(from: beginDate!, to: endDate)
                self.publishTimeLabel.text = "\(out)"
                print(out)
            }
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
