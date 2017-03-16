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
            if created.lengthOfBytes(using: String.Encoding.utf8) > 18{
                
                let year = created.subStr(to: 4)
                let month = created.sub(start: 5, end: 7)
                let day = created.sub(start: 8, length: 2)
                let hour = created.sub(start: 11, length: 2)
                let mimute = created.sub(start: 14, length: 2)
                let second = created.sub(start: 17, length: 2)
                let beginDate = NSDate.getWithYear(year, month: month, day: day, hour: hour, mimute: mimute, second: second)
                let endDate = Date()
                let formatter = DateIntervalFormatter()
                let out = formatter.timeInfo(from: beginDate!, to: endDate)
                self.new.text = "\(out)"
                print(out)
            }
            
            if self.model?.cover == "" {
                return;
            }
            let urlString = "\(picBaseUrl)\(self.model?.cover ?? "qqqqqqqq")"
            let url = URL(string: urlString)
            if let urlstring = url {
                let resource:QSResource = QSResource(url: urlstring)
                self.icon.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"), options: nil, progressBlock: nil, completionHandler: nil)
            }
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
