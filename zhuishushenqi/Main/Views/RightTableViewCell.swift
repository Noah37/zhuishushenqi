//
//  RightTableViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/18.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRectMake(ScreenWidth*CGFloat(rightScaleX) + 10, 6.0, 30, 30)
        textLabel?.frame = CGRectMake(CGRectGetMaxX(imageView!.frame) + 15, 0, 150, 43.5)
        textLabel?.textColor = UIColor.whiteColor()
        textLabel?.font = UIFont.systemFontOfSize(14)
    }

}
