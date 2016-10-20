//
//  SwipableCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/18.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class SwipableCell: UITableViewCell,UIScrollViewDelegate {

    var model:BookShelf?{
        didSet{
            title!.text = model?.title
            
            let date = NSDate()
            let dateFormat = NSDateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
            (model!.updated! as NSString).substringWithRange(NSMakeRange(5, 2))
            let dateString = "\((model!.updated! as NSString).substringToIndex(4))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(5, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(8, 2))) \((model!.updated! as NSString).substringWithRange(NSMakeRange(11, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(14, 2)))-\((model!.updated! as NSString).substringWithRange(NSMakeRange(17, 2)))"
            let beginDate = dateFormat.dateFromString(dateString)
            let  timeIn =  timeBetween(beginDate, endDate: date)
            if timeIn > 3600 && timeIn < 3600*24 {
                
                detailTitle!.text = "\(String(format: "%.0f",timeIn/3600 ))小时前更新:\(model!.lastChapter!)"
            }else if timeIn > 3600*24{
                detailTitle!.text = "\(String(format: "%.0f",timeIn/3600/24))天前更新:\(model!.lastChapter!)"
            }else{
                detailTitle!.text = "\(String(format: "%.0f",timeIn/60))分钟前更新:\(model!.lastChapter!)"
            }
            let urlString = (model!.cover! as NSString).substringFromIndex(7)
            let data = NSData(contentsOfURL: NSURL(string: urlString)!)
            if data != nil {
                imgView?.image = UIImage(data:data!)
            }
        }
    }
    
    var imgView: UIImageView?
    var title:UILabel?
    
    var detailTitle:UILabel?

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initSubview(){
        let scrollView = UIScrollView(frame: CGRectMake(0,0,ScreenWidth,64))
        scrollView.contentSize = CGSizeMake((ScreenWidth - 74)*2, 64)
        scrollView.pagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        //此处解决 UIScrollView屏蔽 UITableViewCell的点击事件，将 scrollView的手势识别交给他的父视图，苹果官方推荐的做法
        scrollView.userInteractionEnabled = false
        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        let imgView = UIImageView(frame: CGRectMake(15, 10, 34, 44))
        imgView.backgroundColor = UIColor.orangeColor()
        self.imgView = imgView
        
        let label = UILabel(frame: CGRectMake(CGRectGetMaxX(imgView.frame) + 10,10,ScreenWidth - CGRectGetMaxX(imgView.frame) - 20,20))
        label.font = UIFont.systemFontOfSize(13)
        self.title = label
        
        let detaillabel = UILabel(frame: CGRectMake(CGRectGetMaxX(imgView.frame) + 10,30,ScreenWidth - CGRectGetMaxX(imgView.frame) - 20,20))
        detaillabel.font = UIFont.systemFontOfSize(13)

        self.detailTitle = detaillabel
        
        
        scrollView.addSubview(self.imgView!)
        scrollView.addSubview(self.title!)
        scrollView.addSubview(self.detailTitle!)

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
        
    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(scrollView.contentOffset.x)
//        let offSetX = scrollView.contentOffset.x
//        if offSetX > (ScreenWidth - 74)/4 {
//            scrollView.setContentOffset(CGPointMake(ScreenWidth - 74, 0), animated:true)
//        }
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
