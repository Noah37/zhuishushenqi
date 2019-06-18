//
//  QSRecommendCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import YYCategories

typealias BtnClickAction = (_ btn:Any)->Void

let RecBtnTag = 12345
//146
class QSRecommendCell: UITableViewCell,InterestdViewDelegate {
    var books:[Book]? {
        didSet{
            if let bookss = books {
                cacheImage(books: bookss)
            }
        }
    }
    
    let QSRecommendCellItemCount = 4
    let QSRecommendCellSpaceX:CGFloat = 15
    let QSRecommendCellSpaceY:CGFloat = 43
    let QSRecommendCellInterestdWidth:CGFloat = 69
    let QSRecommendCellInterestdHeight:CGFloat = 137
    
    var clickAction:BtnClickAction?
    
    @IBOutlet weak var more: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupSubviews()
    }

    @IBAction func moreAct(_ sender: UIView) {
        sender.tag = RecBtnTag + 4
        touchAction(btn: sender)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func cacheImage(books:[Book]){
        var index = 0
        for item in books {
            let title = item.title
            let cover = item.cover

            if let interView:QSInterestdView = self.viewWithTag(RecBtnTag + index) as? QSInterestdView {
                interView.imageView.qs_setBookCoverWithURLString(urlString: cover ?? "")
                interView.titleLabel.text = title
            }
            index = index + 1
        }
    }
    
    func didClick(_ interestdView: QSInterestdView) {
        self.touchAction(btn: interestdView)
    }
    
    func setupSubviews(){
        for item in 0..<QSRecommendCellItemCount {
            let btn:QSInterestdView? = QSInterestdView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            btn?.contentMode = .scaleAspectFit
            btn?.tag = RecBtnTag + item
            btn?.interestdViewDelegate = self
            if let interView = btn {
                self.contentView.addSubview(interView)
            }
        }
    }
    
    @objc func touchAction(btn:Any){
        if let action = clickAction {
            action(btn)
        }
    }
    
    func layoutUI(){
        var index = 0
        let spaceCenter:CGFloat = (ScreenWidth - QSRecommendCellInterestdWidth*CGFloat(QSRecommendCellItemCount) - QSRecommendCellSpaceX*2)/(CGFloat(QSRecommendCellItemCount) - 1)
        for item in 0..<QSRecommendCellItemCount {
            if let interView:QSInterestdView = self.viewWithTag(RecBtnTag + index) as? QSInterestdView {
                let x:CGFloat = QSRecommendCellSpaceX + CGFloat(item)*(QSRecommendCellInterestdWidth + spaceCenter)
                interView.frame = CGRect(x: x, y: QSRecommendCellSpaceY, width: QSRecommendCellInterestdWidth, height: QSRecommendCellInterestdHeight)
            }
            index = index + 1
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        layoutUI()
    }
}

protocol InterestdViewDelegate {
    func didClick(_ interestdView:QSInterestdView) -> Void
}

class QSInterestdView : UIView {
    
    var imageView: UIImageView!
    var titleLabel: UILabel!
    
    var interestdViewDelegate:InterestdViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
        self.imageView.contentMode = .scaleToFill
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupSubviews(){
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 69, height: 102))
        titleLabel = UILabel(frame: CGRect(x: 0, y: imageView.size.height, width: imageView.size.width, height: 137 - imageView.size.height))
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        titleLabel.textColor = UIColor.gray
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .center
        addSubview(imageView)
        addSubview(titleLabel)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc public func tapAction(sender:UITapGestureRecognizer){
        interestdViewDelegate?.didClick(self)
    }
}
