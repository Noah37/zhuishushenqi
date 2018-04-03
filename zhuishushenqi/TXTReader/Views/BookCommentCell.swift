//
//  BookCommentCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class BookCommentCell: UITableViewCell {
    @IBOutlet weak var readerIcon: UIImageView!
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var title: UILabel!
//    @IBOutlet weak var content: UILabel!
    @IBOutlet weak var bookCover: UIImageView!
    @IBOutlet weak var bookName: UILabel!
    @IBOutlet weak var readerRate: UILabel!

    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var titleHeight: NSLayoutConstraint!
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    
    var totalCellHeight:CGFloat = 44
    
    var model:BookComment? {
        didSet{
            modelSetAction(model: model)
        }
    }
    
    var approveBtn:QSToolButton!
    var shareBtn:QSToolButton!
    var moreBtn:QSToolButton!
    var rateView:RateView!
    var content: UILabel!

    func modelSetAction(model:BookComment?){
        let created = model?.created ?? "2014-02-23T16:48:18.179Z"
        self.createTime.qs_setCreateTime(createTime: created,append: "")
        readerName.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
        title.text = "\(model?.title ?? "")"
        titleHeight.constant = model?.titleHeight ?? 0
        
        content.text = "\(model?.content ?? "")"
        contentHeight.constant = model?.contentHeight ?? 0 + 20

        bookName.text = "\(model?.book.title ?? "")"
    
        let titleHeighttt = model?.titleHeight ?? 0
        let contentHeightttt = model?.contentHeight ?? 0
        let totalHeight = titleHeighttt + contentHeightttt  + title.frame.minY + 19 + bgView.bounds.height
        rateView.rate = model?.rating ?? 0

        resetframe(height: totalHeight)

        if model?.book.cover == "" {
            return
        }
        let cover = "\(model?.book.cover ?? "qqqqqqqq")"
        self.bookCover.qs_setBookCoverWithURLString(urlString: cover)
        if self.model?.author.avatar == "" {
            return
        }
        let urlString = "\(model?.author.avatar ?? "qqqqqqqq")"
        self.readerIcon.qs_setAvatarWithURLString(urlString: urlString)
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        toolBar(height: 0)
        makeStarView()
        content = UILabel(frame: CGRect(x: 8, y: 78, width: ScreenWidth - 16, height: 21))
        content.numberOfLines = 0;
        content.font = UIFont.systemFont(ofSize: 13)
        contentView.addSubview(content)
    }
    
    static func height(model:BookComment?)->CGFloat{
        let titleHeight = model?.titleHeight ?? 0
        let contentHeight = model?.contentHeight ?? 0
        let height = titleHeight + contentHeight + 210
        return height
    }
    
    func resetframe(height:CGFloat){
        approveBtn.frame = CGRect(x: 0, y: height, width: self.bounds.width/3, height: 80)
        shareBtn.frame = CGRect(x: self.bounds.width/3 , y: height, width: self.bounds.width/3, height: 80)
        moreBtn.frame = CGRect(x: self.bounds.width*2/3, y: height, width: self.bounds.width/3, height: 80)
        let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
        rateView.frame = lightRect
        content.frame = CGRect(x: 8, y: 78, width: ScreenWidth - 16, height: model?.contentHeight ?? 0)
    }
    
    func toolBar(height:CGFloat){
        approveBtn = QSToolButton(type: .custom)
        approveBtn.frame = CGRect(x: 0, y: height, width: self.bounds.width/3, height: 80)
        approveBtn.setTitle("同感", for: .normal)
        approveBtn.setTitleColor(UIColor.darkGray, for: .normal)
        approveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        approveBtn.setImage(UIImage(named: "forum_like_icon"), for: .normal)
        contentView.addSubview(approveBtn)
        
        shareBtn = QSToolButton(type: .custom)
        shareBtn.frame = CGRect(x: self.bounds.width/3 , y: height, width: self.bounds.width/3, height: 80)
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.setTitleColor(UIColor.darkGray, for: .normal)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        shareBtn.setImage(UIImage(named: "forum_share_icon"), for: .normal)
        contentView.addSubview(shareBtn)
        
        
        moreBtn = QSToolButton(type: .custom)
        moreBtn.frame = CGRect(x: self.bounds.width*2/3, y: height, width: self.bounds.width/3, height: 80)
        moreBtn.setTitle("更多", for: .normal)
        moreBtn.setTitleColor(UIColor.darkGray, for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        moreBtn.setImage(UIImage(named: "forum_more_icon"), for: .normal)
        contentView.addSubview(moreBtn)
    }
    
    func makeStarView(){
        let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
        rateView = RateView(frame: lightRect, darkImage: UIImage(named: "forum_gray_star"), lightImage: UIImage(named: "forum_red_star"))
        rateView.rate = model?.rating ?? 0
        bgView.addSubview(rateView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}

class QSToolButton:UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let origin = (UIScreen.main.bounds.width - 300)/6
        self.imageView?.frame = CGRect(x: origin, y: 0, width: 100, height: 70)
        self.imageView?.contentMode = .center
        
        self.titleLabel?.frame = CGRect(x: 0, y: (self.imageView?.bounds.maxY ?? 0) - 30, width: self.bounds.width, height: 21)
        self.titleLabel?.textAlignment = .center
    }
}
