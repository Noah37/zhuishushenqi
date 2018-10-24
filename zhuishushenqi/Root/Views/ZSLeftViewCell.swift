//
//  ZSLeftViewCell.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/22.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSLeftViewCell: UITableViewCell {
    
    lazy var iconView:UIImageView = {
        let scale = SideVC.leftOffSetXScale
        let imageView = UIImageView(frame: CGRect(x: ScreenWidth*scale/2 - 12.5, y: 10, width: 25, height: 25))
        return imageView
    }()
    
    lazy var selectedView:UIView = {
        let view = UIView(frame: CGRect(x: 0,y: 0,width: 5,height: 44))
        view.backgroundColor =  UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        view.isHidden = true
        return view
    }()
    
    lazy var nameLabel:UILabel = {
        let scale = SideVC.leftOffSetXScale
        let label = UILabel(frame: CGRect(x: ScreenWidth*scale/2 - 20,y: 35,width: 40,height: 10))
        label.font = UIFont.systemFont(ofSize: 9)
        label.textAlignment = .center
        label.textColor = UIColor(white: 1.0, alpha: 0.5)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(self.iconView)
        contentView.addSubview(self.selectedView)
        contentView.addSubview(self.nameLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
