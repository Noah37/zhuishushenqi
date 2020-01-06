//
//  ZSSearchInfoTableViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2020/1/5.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSSearchInfoTableViewCellDelegate:class {
    func infoCell(cell:ZSSearchInfoTableViewCell,click download:UIButton)
}

class ZSSearchInfoTableViewCell: UITableViewCell {
    
    weak var delegate:ZSSearchInfoTableViewCellDelegate?
    
    private lazy var downloadBtn:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("缓存", for: .normal)
        bt.setTitle("已缓存", for: .selected)
        bt.setTitleColor(UIColor.red, for: .normal)
        bt.setTitleColor(UIColor.gray, for: .selected)
        bt.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        bt.addTarget(self, action: #selector(downloadAction(bt:)), for: .touchUpInside)
        return bt
    }()

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
        accessoryView = self.downloadBtn
    }

    func downloadFinish() {
        self.downloadBtn.isSelected = true
    }
    
    override func prepareForReuse() {
        self.downloadBtn.isSelected = false
    }
    
    @objc
    private func downloadAction(bt:UIButton) {
        if bt.isSelected == false {
            delegate?.infoCell(cell: self, click: bt)
        }
    }
}
