//
//  ZSVoucherView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit
import YYText
import YYCategories

class ZSVoucherCell: UITableViewCell {
    
    var titleText:String = "" {
        didSet {
            titleLabel.attributedText = self.attributeText(number: titleText)
        }
    }
    var titleDetailText:String = "" {
        didSet {
            detailTitleLabel.text = "有效期至 \(titleDetailText)"
        }
    }
    var rightText:String = "" {
        didSet {
            rightLabel.text = "余额: \(rightText)"
        }
    }
    var rightDetailText:String = "" {
        didSet {
            rightDetailLabel.text = rightDetailText
        }
    }
    
    private var titleLabel:YYLabel!
    private var detailTitleLabel:UILabel!
    private var rightLabel:UILabel!
    private var rightDetailLabel:UILabel!

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubview() {
        titleLabel = YYLabel(frame: CGRect(x: 15, y: 0, width: 200, height: 30))
        titleLabel.textAlignment = .left
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.numberOfLines = 1
        titleLabel.preferredMaxLayoutWidth = 200
        
        

        detailTitleLabel = UILabel(frame: CGRect(x: 15, y: 30, width: 200, height: 30))
        detailTitleLabel.textAlignment = .left
        detailTitleLabel.textColor = UIColor.gray
        detailTitleLabel.font = UIFont.systemFont(ofSize: 13)
        detailTitleLabel.numberOfLines = 1
        
        rightLabel = UILabel(frame: CGRect(x: self.bounds.width - 100, y: 0, width: 100, height: 30))
        rightLabel.textAlignment = .right
        rightLabel.textColor = UIColor.black
        rightLabel.font = UIFont.systemFont(ofSize: 13)
        rightLabel.numberOfLines = 1
        
        rightDetailLabel = UILabel(frame: CGRect(x: self.bounds.width - 100, y: 30, width: 100, height: 30))
        rightDetailLabel.textAlignment = .right
        rightDetailLabel.textColor = UIColor.gray
        rightDetailLabel.font = UIFont.systemFont(ofSize: 13)
        rightDetailLabel.numberOfLines = 1
        
        addSubview(titleLabel)
        addSubview(detailTitleLabel)
        addSubview(rightLabel)
        addSubview(rightDetailLabel)
    }
    
    func attributeText(number:String) ->NSAttributedString {
        let attributeText = NSMutableAttributedString(string: "\(number) 追书券")
        attributeText.yy_font = UIFont.systemFont(ofSize: 15)
        attributeText.yy_color = UIColor.black
        attributeText.yy_alignment = .left
        attributeText.yy_setTextHighlight(NSMakeRange(0, number.count), color: UIColor.red, backgroundColor: UIColor.clear) { (containerView, text, range, rect) in
            
        }
        return attributeText
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: 15, y: 0, width: 200, height: 30)
        detailTitleLabel.frame = CGRect(x: 15, y: 30, width: 200, height: 30)
        rightLabel.frame = CGRect(x: self.bounds.width - 100 - 15, y: 0, width: 100, height: 30)
        rightDetailLabel.frame = CGRect(x: self.bounds.width - 100 - 15, y: 30, width: 100, height: 30)

    }
}
