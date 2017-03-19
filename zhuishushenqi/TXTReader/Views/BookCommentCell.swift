//
//  BookCommentCell.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class BookCommentCell: UITableViewCell {
    @IBOutlet weak var readerIcon: UIImageView!
    @IBOutlet weak var readerName: UILabel!
    @IBOutlet weak var createTime: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var content: UILabel!
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
    
    @discardableResult
    func modelSetAction(model:BookComment?)->CGFloat{
        let created = model?.created ?? "2014-02-23T16:48:18.179Z"
        self.createTime.qs_setCreateTime(createTime: created,append: "")
        readerName.text = "\(model?.author.nickname ?? "") lv.\(model?.author.lv ?? 0)"
        title.text = "\(model?.title ?? "")"
        var height = heightOfString(title.text ?? "", font: UIFont.systemFont(ofSize: 13), width: self.bounds.width - 30)
        titleHeight.constant = height
        
        content.text = "\(model?.content ?? "")"
        height = heightOfString(content.text ?? "", font: UIFont.systemFont(ofSize: 13), width: self.bounds.width - 30)
        contentHeight.constant = height

        bookName.text = "\(model?.book.title ?? "")"
        
        let totalHeight = titleHeight.constant + contentHeight.constant + title.frame.minY + 19 + bgView.bounds.height
        toolBar(height:totalHeight)
        makeStarView()
        self.totalCellHeight = totalHeight + 80
        if model?.book.cover == "" {
            return totalHeight + 80
        }
        let cover = "\(model?.book.cover ?? "qqqqqqqq")"
        self.bookCover.qs_setBookCoverWithURLString(urlString: cover)
        if self.model?.author.avatar == "" {
            return totalHeight + 80
        }
        let urlString = "\(model?.author.avatar ?? "qqqqqqqq")"
        self.readerIcon.qs_setAvatarWithURLString(urlString: urlString)
        setNeedsDisplay()
        return totalHeight + 80
    }
    
    @IBAction func rightAction(_ sender: Any) {
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    static func height(model:BookComment?)->CGFloat{
        let cell:BookCommentCell? = UINib(nibName: "BookCommentCell", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as? BookCommentCell
        return cell?.modelSetAction(model: model)  ?? 300
    }
    
    func toolBar(height:CGFloat){
        let approveBtn = QSToolButton(type: .custom)
        approveBtn.frame = CGRect(x: 0, y: height, width: self.bounds.width/3, height: 80)
        approveBtn.setTitle("同感", for: .normal)
        approveBtn.setTitleColor(UIColor.darkGray, for: .normal)
        approveBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        approveBtn.setImage(UIImage(named: "forum_like_icon"), for: .normal)
        contentView.addSubview(approveBtn)
        
        let shareBtn = QSToolButton(type: .custom)
        shareBtn.frame = CGRect(x: self.bounds.width/3 , y: height, width: self.bounds.width/3, height: 80)
        shareBtn.setTitle("分享", for: .normal)
        shareBtn.setTitleColor(UIColor.darkGray, for: .normal)
        shareBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        shareBtn.setImage(UIImage(named: "forum_share_icon"), for: .normal)
        contentView.addSubview(shareBtn)
        
        
        let moreBtn = QSToolButton(type: .custom)
        moreBtn.frame = CGRect(x: self.bounds.width*2/3, y: height, width: self.bounds.width/3, height: 80)
        moreBtn.setTitle("更多", for: .normal)
        moreBtn.setTitleColor(UIColor.darkGray, for: .normal)
        moreBtn.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        moreBtn.setImage(UIImage(named: "forum_more_icon"), for: .normal)
        contentView.addSubview(moreBtn)
    }
    
    func makeStarView(){
        let lightRect = CGRect(x: readerRate.frame.maxX , y: readerRate.frame.minY + readerRate.frame.height/2 - 10/2, width: 60, height: 10)
        let rateView = RateView(frame: lightRect, darkImage: UIImage(named: "forum_gray_star"), lightImage: UIImage(named: "forum_red_star"))
        rateView.rate = model?.rating ?? 0
        bgView.addSubview(rateView)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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
