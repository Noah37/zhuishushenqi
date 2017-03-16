//
//  BookDetailHeader.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

typealias AddButtonAction = (_ isSelected:Bool,_ model:BookDetail)->Void

class BookDetailHeader: UIView {

    var addBtnAction:AddButtonAction?
    var startReading:AddButtonAction?
    var model:BookDetail?{
        didSet{
            name.text = model?.title
            let mArr:[BookDetail]? = BookShelfInfo.books.bookShelf as? [BookDetail]
            for item in mArr ?? [] {
                if item._id == model?._id {
                    addButton.isSelected = true
                }
            }
            authorWidth.text = model?.author
            let widthttt = widthOfString(authorWidth.text ?? "", font: UIFont.boldSystemFont(ofSize: 13), height: 21)
            authorWidthh.constant = widthttt
            
            typeWidth.text = model?.minorCate == "" ? model?.majorCate : model?.minorCate
            let typeConst = widthOfString(typeWidth.text ?? "", font: UIFont.systemFont(ofSize: 13), height: 21)
            typeWidthConst.constant = typeConst + 5
            
            words.text = "\(Int(model?.wordCount ?? "0")!/10000)万字"
            
            let created = model?.updated ?? "2014-02-23T16:48:18.179Z"
            self.new.qs_setCreateTime(createTime: created,append: "")
            self.icon.qs_setBookCoverWithURLString(urlString: self.model?.cover ?? "qqqqqqqq")
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
//    [UIColor colorWithRed:0.69f green:0.04f blue:0.04f alpha:1.00f];
    @IBOutlet weak var authorWidthh: NSLayoutConstraint!
    @IBOutlet weak var new: UILabel!
    @IBOutlet weak var words: UILabel!
    @IBOutlet weak var authorWidth: UILabel!

    @IBOutlet weak var typeWidthConst: NSLayoutConstraint!
    @IBOutlet weak var typeWidth: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBAction func readingStart(_ sender: UIButton) {
        if let action = startReading {
            if let model = self.model {
                action(sender.isSelected,model)
            }
        }
    }
    
    @IBAction func addBook(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let action = addBtnAction {
            if let model = self.model {
                action(sender.isSelected,model)
            }
        }
    }
}
