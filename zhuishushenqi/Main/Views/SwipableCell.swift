//
//  SwipableCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/18.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class SwipableCell: UITableViewCell,UIScrollViewDelegate {

    var model:BookDetail?{
        didSet{
            title!.text = model?.title
            
            let date = Date()
            let dateFormat = DateFormatter()
            dateFormat.dateFormat = "yyyy-MM-dd HH-mm-ss"
            (model!.updated as NSString).substring(with: NSMakeRange(5, 2))
            let dateString = "\((model!.updated as NSString).substring(to: 4))-\((model!.updated as NSString).substring(with: NSMakeRange(5, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(8, 2))) \((model!.updated as NSString).substring(with: NSMakeRange(11, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(14, 2)))-\((model!.updated as NSString).substring(with: NSMakeRange(17, 2)))"
            let beginDate = dateFormat.date(from: dateString)
            let  timeIn =  timeBetween(beginDate, endDate: date)
            if timeIn > 3600 && timeIn < 3600*24 {
                
                detailTitle!.text = "\(String(format: "%.0f",timeIn/3600 ))小时前更新:\(model?.updateInfo?.lastChapter ?? "")"
            }else if timeIn > 3600*24{
                detailTitle!.text = "\(String(format: "%.0f",timeIn/3600/24))天前更新:\(model?.updateInfo?.lastChapter ?? "")"
            }else{
                detailTitle!.text = "\(String(format: "%.0f",timeIn/60))分钟前更新:\(model?.updateInfo?.lastChapter ?? "")"
            }
            let urlString = (model!.cover as NSString).substring(from: 7)
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: URL(string: urlString)!)
                if let imageData = data {
                    DispatchQueue.main.async {
                        self.imgView?.image = UIImage(data:imageData)
                    }
                }
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
    
    fileprivate func initSubview(){
        let scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 64))
        scrollView.contentSize = CGSize(width: (ScreenWidth - 74)*2, height: 64)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        addSubview(scrollView)
        //此处解决 UIScrollView屏蔽 UITableViewCell的点击事件，将 scrollView的手势识别交给他的父视图，苹果官方推荐的做法
        scrollView.isUserInteractionEnabled = false
        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 10, width: 34, height: 44))
        imgView.backgroundColor = UIColor.orange
        imgView.image = UIImage(named: "default_book_cover")
        self.imgView = imgView
        
        let label = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 10,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        self.title = label
        
        let detaillabel = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 30,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        detaillabel.font = UIFont.systemFont(ofSize: 13)

        self.detailTitle = detaillabel
        
        
        scrollView.addSubview(self.imgView!)
        scrollView.addSubview(self.title!)
        scrollView.addSubview(self.detailTitle!)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
//    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        print(scrollView.contentOffset.x)
//        let offSetX = scrollView.contentOffset.x
//        if offSetX > (ScreenWidth - 74)/4 {
//            scrollView.setContentOffset(CGPointMake(ScreenWidth - 74, 0), animated:true)
//        }
//    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    

}
