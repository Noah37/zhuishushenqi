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

    var chapter:QSChapter?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func bind(model:QSChapter,index:Int){
        if model.content == "" {
            downloadBtn.isHidden = false
        }else{
            downloadBtn.isHidden = true
        }
        if model.curChapter == index {
            tittle.textColor = UIColor.red
        }
        count.text = "\(model.curChapter)"
    }
    
    override func prepareForReuse() {
        tittle.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
