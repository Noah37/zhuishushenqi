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
    var model:BookDetail?{
        didSet{
            name.text = model?.title
            
            let urlString = (model!.cover as NSString).substring(from: 7)
            let url = URL(string: urlString)
            let data = try? Data(contentsOf: url!)
            if data != nil {
                icon.image = UIImage(data: data!)
            }
            let mArr:[BookDetail]? = BookShelfInfo.books.bookShelf as? [BookDetail]
            for item in mArr ?? [] {
                if item._id == model?._id {
                    addButton.isSelected = true
                }
            }
            authorWidth.text = model?.author
            let widthttt = widthOfString(authorWidth.text!, font: UIFont.boldSystemFont(ofSize: 13), height: 21)
            authorWidthh.constant = widthttt
            
            typeWidth.text = model?.minorCate
            words.text = "\(Int(model!.wordCount)!/10000)万字"
            let date = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
            (model!.updated as NSString).substring(with: NSMakeRange(5, 2))
            let dateString = "\((model!.updated as NSString).substring(to: 4))-\((model!.updated as NSString).substring(with: NSMakeRange(5, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(8, 2))) \((model!.updated as NSString).substring(with: NSMakeRange(11, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(14, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(17, 2)))"
            let beginDate = dateFormat.date(from: dateString)
            let  timeIn =  timeBetween(beginDate, endDate: date)
            if timeIn > 3600 && timeIn < 3600*24 {
                new.text = "\(String(format: "%.0f",timeIn/3600 ))小时前更新"
            }else if timeIn > 3600*24{
                new.text = "\(String(format: "%.0f",timeIn/3600/24))天前更新"
            }else{
                new.text = "\(String(format: "%.0f",timeIn/60))分钟前更新"
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

    @IBOutlet weak var typeWidth: UILabel!
    
    @IBOutlet weak var addButton: UIButton!
    @IBAction func readingStart(_ sender: AnyObject) {
        
    }
    
    @IBAction func addBook(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        if let action = addBtnAction {
            if let model = self.model {
                action(sender.isSelected,model)
            }
        }
        
        
//        let addBookApi = AddBookAPI()
//        addBookApi.id = model?._id
//        addBookApi.startWithCompletionBlockWithHUD({ (request) in
//            
//            }) { (request) in
//                
//        }
    }
}
