//
//  BookDetailHeader.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class BookDetailHeader: UIView {
    
    
    var model:BookDetail?{
        didSet{
            name.text = model?.title
            
            let urlString = (model!.cover! as NSString).substringFromIndex(7)
            let url = NSURL(string: urlString)
            let data = NSData(contentsOfURL: url!)
            if data != nil {
                icon.image = UIImage(data: data!)
            }
            
            
            authorWidth.text = model?.author
            let widthttt = widthOfString(authorWidth.text!, font: UIFont.systemFontOfSize(12), height: 21)
            authorWidthh.constant = widthttt
            
            typeWidth.text = model?.minorCate
            words.text = "\(Int(model!.wordCount!)!/10000)万字"
            let date = NSDate()
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
            (model!.updated! as NSString).substringWithRange(NSMakeRange(5, 2))
            let dateString = "\((model!.updated! as NSString).substringToIndex(4))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(5, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(8, 2))) \((model!.updated! as NSString).substringWithRange(NSMakeRange(11, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(14, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(17, 2)))"
            let beginDate = dateFormat.dateFromString(dateString)
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
    
    @IBAction func readingStart(sender: AnyObject) {
        
    }
    
    @IBAction func addBook(sender: AnyObject) {
        let addBookApi = AddBookAPI()
        addBookApi.id = model?._id
        addBookApi.startWithCompletionBlockWithHUD({ (request) in
            
            }) { (request) in
                
        }
    }
}
