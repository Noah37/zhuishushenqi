//
//  RightTableViewCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/18.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class RightTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: ScreenWidth*CGFloat(rightScaleX) + 10, y: 6.0, width: 30, height: 30)
        textLabel?.frame = CGRect(x: imageView!.frame.maxX + 15, y: 0, width: 150, height: 43.5)
        textLabel?.textColor = UIColor.white
        textLabel?.font = UIFont.systemFont(ofSize: 14)
    }

}
