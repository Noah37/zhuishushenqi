//
//  BookCommentCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit



@available(iOS 9.0, *)
class BookCommentCell: UITableViewCell {
    @IBOutlet weak var readerIcon: UIImageView!
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var readerRate: UILabel!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var displayHeight: NSLayoutConstraint!
    
    @IBOutlet weak var displayView:CTDisplayView!
    
    static var totalCellHeight:CGFloat = 0
    
    var model:BookComment? {
        didSet{
            modelSetAction(model: model)
        }
    }
    
    var handler:CTDisplayHandler?
    
    @IBOutlet weak var stackView:UIStackView!
    
    @IBOutlet weak var approveBtn:QSToolButton!
    @IBOutlet weak var shareBtn:QSToolButton!
    @IBOutlet weak var moreBtn:QSToolButton!
    var rateView:RateView!
    
    @IBOutlet weak var stackViewTop: NSLayoutConstraint!
    var data:CoreTextData!
    
    let defaultTime = "2014-02-23T16:48:18.179Z"
    
    
    func layout(model:BookComment?, layout:ZSBookCTLayoutModel?) {
        let created = model?.created ?? defaultTime
        self.createTime.qs_setCreateTime(createTime: created,append: "")
        readerName.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
        title.text = "\(model?.title ?? "")"
        titleHeight.constant = layout?.titleHeight ?? 20
        displayHeight.constant = layout?.contentHeight ?? 20
        bookName.text = "\(model?.book.title ?? "")"
        if  model?.book.cover != "" {
            let cover = "\(model?.book.cover ?? "")"
            self.bookCover.qs_setBookCoverWithURLString(urlString: cover)
            rateView.rate = model?.rating ?? 0
            let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
            rateView.frame = lightRect
        } else {
            bgView.isHidden = true
            rateView.isHidden = true
            stackViewTop.constant = -bgView.frame.size.height
        }
        BookCommentCell.totalCellHeight = stackView.bottom
        let urlString = "\(model?.author.avatar ?? "qqqqqqqq")"
        self.readerIcon.qs_setAvatarWithURLString(urlString: urlString)
    }

    func modelSetAction(model:BookComment?){
        let created = model?.created ?? defaultTime
        self.createTime.qs_setCreateTime(createTime: created,append: "")
        readerName.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
        title.text = "\(model?.title ?? "")"
        title.sizeToFit()
        setupDisplayView(model: model)
        displayHeight.constant = data?.height ?? 0 
        bookName.text = "\(model?.book.title ?? "")"
        if  model?.book.cover != "" {
            let cover = "\(model?.book.cover ?? "")"
            self.bookCover.qs_setBookCoverWithURLString(urlString: cover)
            rateView.rate = model?.rating ?? 0
            let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
            rateView.frame = lightRect
        } else {
            bgView.isHidden = true
            rateView.isHidden = true
            stackViewTop.constant = -bgView.frame.size.height
        }
        BookCommentCell.totalCellHeight = stackView.bottom
        let urlString = "\(model?.author.avatar ?? "qqqqqqqq")"
        self.readerIcon.qs_setAvatarWithURLString(urlString: urlString)
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        makeStarView()
//        config.width = displayView.size.width
    }
    
    private func setupDisplayView(model:BookComment?) {
//        data = CTFrameParser.parseString(model?.content ?? "", config: config)
        displayView.data = data
        displayHeight.constant = data?.height ?? 21
        displayView.backgroundColor = UIColor.white
        displayView.handler = handler
    }
    
    func makeStarView(){
        let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
        rateView = RateView(frame: lightRect, darkImage: UIImage(named: "forum_gray_star"), lightImage: UIImage(named: "forum_red_star"))
        rateView.rate = model?.rating ?? 0
        bgView.addSubview(rateView)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class QSToolButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 0, y: 0, width: ScreenWidth/3, height: 70)
        self.imageView?.contentMode = .center
        
        self.titleLabel?.frame = CGRect(x: 0, y: 49, width: ScreenWidth/3, height: 21)
        self.titleLabel?.textAlignment = .center
        self.contentHorizontalAlignment = .center
    }
}
