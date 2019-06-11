//
//  ZSDetailInfoCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/5/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSDetailInfoCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        authorLabel.textColor = UIColor.red
        authorLabel.font = UIFont.systemFont(ofSize: 11)
        
        majorLabel.textColor = UIColor.gray
        majorLabel.font = UIFont.systemFont(ofSize: 11)
        
        wordCountLabel.textColor = UIColor.gray
        wordCountLabel.font = UIFont.systemFont(ofSize: 11)
        
        updatedLabel.textColor = UIColor.gray
        updatedLabel.font = UIFont.systemFont(ofSize: 11)
        
        pursueButton.setBackgroundImage(UIImage(named: "bd_add"), for: .normal)
        pursueButton.setBackgroundImage(UIImage(named: "bd_cancel_selected"), for: .selected)
        pursueButton.layer.cornerRadius = 5
        pursueButton.layer.masksToBounds = true
        
        startReadingButton.backgroundColor = UIColor.red
        startReadingButton.setTitle("开始阅读", for: .normal)
        startReadingButton.layer.cornerRadius = 5
        startReadingButton.layer.masksToBounds = true
        
        contentView.addSubview(authorLabel)
        contentView.addSubview(majorLabel)
        contentView.addSubview(wordCountLabel)
        contentView.addSubview(updatedLabel)
        contentView.addSubview(pursueButton)
        contentView.addSubview(startReadingButton)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: 20, width: 36, height: 45)
        let marginX = imageView?.frame.maxX ?? 0
        textLabel?.frame = CGRect(x: marginX + 10, y: 20, width: bounds.width - marginX - 10, height: 15)
        let authorOriginY = textLabel?.frame.maxY ?? 0
        let authorWidth = authorLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 15)).width
        authorLabel.frame = CGRect(x: marginX, y: authorOriginY, width: authorWidth, height: 15)
        let majorWidth = majorLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 15)).width
        let majorOriginX = authorLabel.frame.maxX + 20
        majorLabel.frame = CGRect(x: majorOriginX, y: 15, width: majorWidth, height: 15)
        let wordCountOriginX = majorLabel.frame.maxX
        let wordCountWidth = wordCountLabel.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 15)).width
        wordCountLabel.frame = CGRect(x: wordCountOriginX, y: 15, width: wordCountWidth, height: 15)
        updatedLabel.frame = CGRect(x: 20, y: 30, width: bounds.width - marginX - 10 - 20, height: 15)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }

    var authorLabel:UILabel = UILabel(frame: .zero)
    var majorLabel:UILabel = UILabel(frame: .zero)
    var wordCountLabel:UILabel = UILabel(frame: .zero)
    var updatedLabel:UILabel = UILabel(frame: .zero)
    var pursueButton:UIButton = UIButton(type: .custom)
    var startReadingButton:UIButton = UIButton(type: .custom)
}
