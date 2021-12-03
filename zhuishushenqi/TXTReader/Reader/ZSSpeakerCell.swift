//
//  ZSSpeakerCell.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/11.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSSpeakerCell: UITableViewCell {
    
    lazy var download:UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: 0, y: 0, width: 60, height: 30)
        btn.setTitle("下载", for: .normal)
        btn.setTitle("已下载", for: .selected)
        btn.setTitleColor(UIColor.blue, for: .normal)
        btn.addTarget(self, action: #selector(downloadAction), for: .touchUpInside)
        return btn
    }()
    
    var downloadHandler:ZSBaseCallback<Void>?
    
    
    @objc
    private func downloadAction() {
        downloadHandler?(nil)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: reuseIdentifier)
        self.accessoryView = self.download
        self.download.imageView?.startAnimating()
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
        self.imageView?.frame = CGRect(x: 15, y: 10, width: 50, height: 50)
        self.imageView?.qs_addCorner(radius: 25)
        self.textLabel?.frame = CGRect(x: 80, y: 15, width: 100, height: 20.34)
        self.detailTextLabel?.frame = CGRect(x: 80, y: 37, width: 100, height: 14.34)
    }

}
