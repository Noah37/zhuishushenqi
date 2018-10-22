//
//  ZSMyCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSRLMyCell: UITableViewCell {
    
    var customView:UIView? {
        didSet {
            layoutSubviews()
        }
    }
    
    var rightLabel:UILabel!
    
    var rightTitle:String = "" {
        didSet {
            rightLabel.text = rightTitle
            let width = rightTitle.qs_width(UIFont.systemFont(ofSize: 13), height: 30)
            rightLabel.frame = CGRect(x: self.bounds.width - width - 40, y: self.bounds.height/2 - 15 , width: width, height: 30)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        rightLabel = UILabel(frame: CGRect.zero)
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        rightLabel.textColor = UIColor.red
        rightLabel.textAlignment = .center
        
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(self.rightLabel)
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if let customView = self.customView {
            rightLabel.isHidden = true
            customView.frame = CGRect(x: self.bounds.width - customView.bounds.width - 40, y: self.bounds.height/2 - customView.bounds.height/2, width: customView.bounds.width, height: customView.bounds.height)
            if let _ = customView.superview {
                customView.removeFromSuperview()
            }
            contentView.addSubview(customView)
        } else {
            let width = rightTitle.qs_width(UIFont.systemFont(ofSize: 13), height: 30)
            rightLabel.frame = CGRect(x: self.bounds.width - width - 40, y: self.bounds.height/2 - 15 , width: width, height: 30)
            rightLabel.isHidden = false
        }
    }
}

class ZSRTMyCell: UITableViewCell {
    
    private lazy var rightButton:UIButton = {
        let button = UIButton(type: .custom)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.setTitleColor(UIColor.red, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return button
    }()
    
    var rightTitle:String = "" {
        didSet {
            rightButton.setTitle(rightTitle, for: .normal)
            let width = rightTitle.qs_width(UIFont.systemFont(ofSize: 13), height: 30)
            rightButton.frame = CGRect(x: self.bounds.width - width - 40, y: self.bounds.height/2 - 15 , width: width, height: 30)
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        contentView.addSubview(self.rightButton)
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
        
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let width = rightTitle.qs_width(UIFont.systemFont(ofSize: 13), height: 30)
        rightButton.frame = CGRect(x: self.bounds.width - width - 20 - 40, y: self.bounds.height/2 - 13 , width: width + 20, height: 26)
        rightButton.layer.cornerRadius = 5
    }
}
