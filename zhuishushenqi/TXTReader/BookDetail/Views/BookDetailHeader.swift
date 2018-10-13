//
//  BookDetailHeader.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

typealias AddButtonAction = (_ isSelected:Bool,_ model:BookDetail)->Void

class BookDetailHeader: UIView {

    var addBtnAction:AddButtonAction?
    var startReading:AddButtonAction?
    var model:BookDetail?{
        didSet{
            name.text = model?.title
            if let book = model {
                let exist = ZSBookManager.shared.existBook(book: book)
                if exist{
                    addButton.isSelected = true
                }
            }
            authorWidth.text = model?.author
            let widthttt = (authorWidth.text ?? "").qs_width(UIFont.boldSystemFont(ofSize: 13), height: 21)
            authorWidthh.constant = widthttt
            
            typeWidth.text = model?.minorCate == "" ? model?.majorCate : model?.minorCate
            let typeConst = (typeWidth.text ?? "").qs_width(UIFont.systemFont(ofSize: 13), height: 21)
            typeWidthConst.constant = typeConst + 5
            
            words.text = "\(Int(model?.wordCount ?? "0")!/10000)万字"
            
            let created = model?.updated ?? "2014-02-23T16:48:18.179Z"
            self.new.qs_setCreateTime(createTime: created,append: "")
            self.icon.qs_setBookCoverWithURLString(urlString: self.model?.cover ?? "qqqqqqqq")
        }
    }
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var icon: UIImageView!
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
