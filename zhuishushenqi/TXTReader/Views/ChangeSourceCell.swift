//
//  ChangeSourceCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit


class ChangeSourceCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var website: UILabel!
    @IBOutlet weak var novelInfo: UILabel!
    @IBOutlet weak var currentSelect: UILabel!

    @IBOutlet weak var sourceWidth: NSLayoutConstraint!
    @IBOutlet weak var updated: UILabel!
    
    var higherCase:UILabel!
    var isCurrentSelected:Bool = false
    var model:ResourceModel? {
        didSet{
            self.website.text = "\(model?.source ?? "")"
            let width = (website.text ?? "").qs_width(UIFont.systemFont(ofSize: 11), height: 21)
            self.sourceWidth.constant = width + 10
            let created = model?.updated ?? ""
            self.updated.qs_setCreateTime(createTime: created, append: "")
            self.novelInfo.text = "\(model?.lastChapter ?? "")"
            self.currentSelect.isHidden = !self.isCurrentSelected
            higherCase.text = (model?.source ?? "zz").qs_subStr(to: 1).uppercased()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        icon.layer.cornerRadius = 16.5
        icon.layer.masksToBounds = true
        higherCase = UILabel(frame: CGRect(x: 0, y: 0, width: 33, height: 33))
        higherCase.textAlignment = .center
        higherCase.textColor = UIColor.white
        higherCase.font = UIFont.systemFont(ofSize: 20)
        higherCase.backgroundColor = UIColor.gray
        icon.addSubview(higherCase)
    }
    
    override func prepareForReuse() {
        self.isCurrentSelected = false
        self.currentSelect.isHidden = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
