//
//  ZSReviewDetailView.swift
//  zhuishushenqi
//
//  Created by yung on 2018/10/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSReviewDetailHandler = (_ id:String )->Void

class ZSReviewDetailView: UIView {
    
    private var iconView:UIImageView!
    private var nameLabel:UILabel!
    private var createLabel:UILabel!
    private var titleLabel:UILabel!
    private var displayView:CTDisplayView!
    
    private var bookBgView:UIView!
    private var bookIconView:UIImageView!
    private var bookTitleLabel:UILabel!
    private var rateLabel:UILabel!
    private var rateStarView:RateView!
    private var gotoBookButton:UIButton!
    private var feelingView:ZSFeelingView!
    
    var detail:BookComment?
    
    var gotoBookHandler:ZSReviewDetailHandler?
    
    private var bookBgViewHeight:CGFloat = 74
    
    private let defaultTime = "2014-02-23T16:48:18.179Z"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupDetail(detail:BookComment, data:CoreTextData) {
        self.detail = detail
        let created = detail.created
        self.createLabel.qs_setCreateTime(createTime: created,append: "")
        nameLabel.text = "\(detail.author.nickname) lv.\(detail.author.lv)"
        titleLabel.text = "\(detail.title)"
        let titleTextHegiht = detail.title.qs_height(UIFont.systemFont(ofSize: 18), width: UIScreen.main.bounds.width - 40)
        titleLabel.height = titleTextHegiht
        bookTitleLabel.text = "\(detail.book.title)"
        if  detail.book.cover != "" {
            let cover = "\(detail.book.cover)"
            self.bookIconView.qs_setBookCoverWithURLString(urlString: cover)
            rateStarView.rate = detail.rating
            bookBgViewHeight = 74
        } else {
            bookBgViewHeight = 0
        }
        displayView.data = data
        displayView.height = data.height
        let urlString = "\(detail.author.avatar)"
        self.iconView.qs_setAvatarWithURLString(urlString: urlString)
        bookTitleLabel.text = detail.book.title
        layoutSubview()
    }
    
    @objc
    private func gotoBookAction(btn:UIButton) {
        if let id = detail?.book._id {
            gotoBookHandler?(id)
        }
    }
    
    private func layoutSubview() {
        
        displayView.origin.y = self.titleLabel.frame.maxY + 10
        bookBgView.origin.y = self.displayView.frame.maxY + 20
        bookBgView.height = bookBgViewHeight
        if bookBgViewHeight == 0 {
            bookBgView.isHidden = true
        }
        feelingView.frame = CGRect(x: 20, y: self.bookBgView.frame.maxY, width: self.bounds.width - 40 , height: 70)
    }
    
    private func setupSubviews() {
        isUserInteractionEnabled = true
        
        iconView = UIImageView(frame: CGRect(x: 20, y: 20, width: 36, height: 36))
        iconView.layer.cornerRadius = 5
        addSubview(iconView)
        
        nameLabel = UILabel(frame: CGRect(x: self.iconView.frame.maxX + 10, y: 20, width: self.bounds.width - (self.iconView.frame.maxX + 10) - 20, height: 20))
        nameLabel.textColor = UIColor(red: 0.82, green: 0.62, blue: 0.36, alpha: 1.0)
        nameLabel.font = UIFont.systemFont(ofSize: 17)
        nameLabel.textAlignment = .left
        addSubview(nameLabel)
        
        createLabel = UILabel(frame: CGRect(x: self.iconView.frame.maxX + 10, y: self.nameLabel.frame.maxY + 6, width: self.bounds.width - (self.iconView.frame.maxX + 10) - 20, height: 10))
        createLabel.textColor = UIColor.gray
        createLabel.font = UIFont.systemFont(ofSize: 11)
        createLabel.textAlignment = .left
        addSubview(createLabel)
        
        titleLabel = UILabel(frame: CGRect(x: 20, y: self.iconView.frame.maxY + 20, width: self.bounds.width - 20*2, height: 30))
        titleLabel.textColor = UIColor.black
        titleLabel.font = UIFont.systemFont(ofSize: 18)
        titleLabel.textAlignment = .left
        titleLabel.numberOfLines = 0
        addSubview(titleLabel)
        
        displayView = CTDisplayView(frame: CGRect(x: 20, y: self.titleLabel.frame.maxY + 10, width: self.bounds.width - 40, height: 0))
        displayView.isUserInteractionEnabled = true
        displayView.backgroundColor = UIColor.clear
        addSubview(displayView)
        
        bookBgView = UIView(frame: CGRect(x: 20, y: self.displayView.frame.maxY + 10, width: self.bounds.width - 40, height: bookBgViewHeight))
        bookBgView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        addSubview(bookBgView)
        
        bookIconView = UIImageView(frame: CGRect(x: 10, y: self.bookBgView.bounds.height/2 - 54/2, width: 36, height: 54))
        bookBgView.addSubview(bookIconView)
        
        bookTitleLabel = UILabel(frame: CGRect(x: self.bookIconView.frame.maxX + 10, y: 10, width: self.bookBgView.bounds.width - (self.bookIconView.frame.maxX + 10) - 20, height: 27))
        bookTitleLabel.textColor = UIColor.black
        bookTitleLabel.font = UIFont.systemFont(ofSize: 15)
        bookTitleLabel.textAlignment = .left
        bookBgView.addSubview(bookTitleLabel)
        
        rateLabel = UILabel(frame: CGRect(x: self.bookIconView.frame.maxX + 10, y: self.bookTitleLabel.frame.maxY, width: 60, height: 27))
        rateLabel.textColor = UIColor.gray
        rateLabel.font = UIFont.systemFont(ofSize: 12)
        rateLabel.textAlignment = .left
        rateLabel.text = "楼主打分:"
        bookBgView.addSubview(rateLabel)
        
        gotoBookButton = UIButton(type: .custom)
        gotoBookButton.frame = CGRect(x: self.bookBgView.bounds.width - 36 - 20, y: bookBgViewHeight/2 - 36/2, width: 36, height: 36)
        gotoBookButton.setImage(UIImage(named: "forum_book_entry"), for: .normal)
        gotoBookButton.addTarget(self, action: #selector(gotoBookAction(btn:)), for: .touchUpInside)
        bookBgView.addSubview(gotoBookButton)
        
        let lightRect = CGRect(x: rateLabel.frame.maxX , y: rateLabel.frame.minY + rateLabel.frame.height/2 - 10/2, width: 60, height: 10)
        rateStarView = RateView(frame: lightRect, darkImage: UIImage(named: "forum_gray_star"), lightImage: UIImage(named: "forum_red_star"))
        bookBgView.addSubview(rateStarView)
        
        feelingView = ZSFeelingView(frame: CGRect(x: 20, y: self.bookBgView.frame.maxY, width: self.bounds.width - 40 , height: 70))
        addSubview(feelingView)
    }
}
