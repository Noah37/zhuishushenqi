//
//  CategoryTableViewCell.swift
//  PageViewController
//
//  Created by Nory Cao on 16/10/11.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol CategoryCellDelegate {
    func downloadBtnClicked(sender:Any) -> Void;
}

class CategoryTableViewCell: UITableViewCell {
    
    var cellDelegate:CategoryCellDelegate?
    @IBOutlet weak var head: UIView!
    @IBOutlet weak var count: UILabel!
    @IBOutlet weak var tittle: UILabel!
    @IBOutlet weak var downloadBtn: UIButton!
    
    
    @IBAction func downloadAction(_ sender: Any) {
        cellDelegate?.downloadBtnClicked(sender: sender)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(model:QSChapter?){
        if let _ = model {
            downloadBtn.isEnabled = false
            downloadBtn.setTitle("已缓存", for: .normal)
            if (model?.isVip ?? false) == true {
                downloadBtn.setTitle("", for: .normal)
                downloadBtn.setImage(UIImage(named: "directory_vip_chapter"), for: .normal)
            }
        }
        else {
            downloadBtn.isEnabled = true
            downloadBtn.setTitle("下载", for: .normal)
        }
    }
    
    override func prepareForReuse() {
        tittle.textColor = UIColor.black
        downloadBtn.setImage(nil, for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
