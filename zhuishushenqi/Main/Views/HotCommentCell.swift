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
            self.publishTimeLabel.text = ""
            
            let date = Date()
            
//            let dateFormat = DateFormatter()
//            dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
//            (model!.updated as NSString).substring(with: NSMakeRange(5, 2))
//            let dateString = "\((model!.updated as NSString).substring(to: 4))-\((model!.updated as NSString).substring(with: NSMakeRange(5, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(8, 2))) \((model!.updated as NSString).substring(with: NSMakeRange(11, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(14, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(17, 2)))"
//            let beginDate = dateFormat.date(from: dateString)
//            let  timeIn =  timeBetween(beginDate, endDate: date)
//            if timeIn > 3600 && timeIn < 3600*24 {
//                new.text = "\(String(format: "%.0f",timeIn/3600 ))小时前更新"
//            }else if timeIn > 3600*24{
//                new.text = "\(String(format: "%.0f",timeIn/3600/24))天前更新"
//            }else{
//                new.text = "\(String(format: "%.0f",timeIn/60))分钟前更新"
//            }
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
