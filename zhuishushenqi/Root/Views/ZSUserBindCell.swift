//
//  ZSUserBindCell.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSUserBindHandler = (_ selected:Bool)->Void

class ZSUserBindCell: UITableViewCell {
    
    lazy var rightLabel:UILabel = {
        let label = UILabel()
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .right
        label.text = "未绑定"
        return label
    }()
    
    lazy var rightButton:UIButton = {
        let button = UIButton(type: .custom)
        button.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        button.setTitle("立即绑定", for: .normal)
//        button.setTitle("已绑定", for: .selected)
        button.setTitleColor(UIColor.red, for: .normal)
        button.setTitleColor(UIColor.gray, for: .selected)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.layer.borderColor = UIColor.red.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()
    
    var buttonHandler:ZSUserBindHandler?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.accessoryType = .disclosureIndicator
        
        contentView.addSubview(self.rightLabel)
        contentView.addSubview(self.rightButton)
        
        self.rightButton.addTarget(self, action: #selector(rightAction(btn:)), for: .touchUpInside)
    }
    
    @objc
    func rightAction(btn:UIButton) {
//        btn.isSelected = !btn.isSelected
        buttonHandler?(btn.isSelected)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.rightButton.frame = CGRect(x: self.bounds.width - 120, y: self.bounds.height/2 - 15, width: 80, height: 30)
        self.rightLabel.frame = CGRect(x: self.rightButton.frame.minX - 310, y: self.bounds.height/2 - 15, width: 300, height: 30)
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
