//
//  ZSSearchResultCell.swift
//  zhuishushenqi
//
//  Created by yung on 2019/10/27.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import Kingfisher

class ZSSearchResultCell: UITableViewCell {
    
    lazy var bookIconView:UIImageView = {
        let icon = UIImageView(frame: .zero)
        return icon
    }()
    
    lazy var bookNameLB:UILabel = {
        let icon = UILabel(frame: .zero)
        icon.textColor = UIColor.black
        icon.font = UIFont.systemFont(ofSize: 15)
        return icon
    }()
    
    lazy var authorLB:UILabel = {
        let icon = UILabel(frame: .zero)
        icon.textColor = UIColor.black
        icon.font = UIFont.systemFont(ofSize: 13)
        return icon
    }()
    
    lazy var typeLB:UILabel = {
        let icon = UILabel(frame: .zero)
        icon.textColor = UIColor.gray
        icon.font = UIFont.systemFont(ofSize: 15)
        return icon
    }()
    
    lazy var sourceLB:UILabel = {
        let icon = UILabel(frame: .zero)
        icon.textColor = UIColor.gray
        icon.font = UIFont.systemFont(ofSize: 15)
        icon.textAlignment = .right
        return icon
    }()
    
    lazy var bookDescLB:UILabel = {
        let icon = UILabel(frame: .zero)
        icon.textColor = UIColor.gray
        icon.font = UIFont.systemFont(ofSize: 13)
        icon.numberOfLines = 0
        return icon
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.bookIconView.frame = CGRect(x: 15, y: 15, width: 80, height: 100)
        self.bookNameLB.frame = CGRect(x: self.bookIconView.frame.maxX + 20, y: 15, width: 200, height: 15)
        self.sourceLB.frame = CGRect(x: self.contentView.bounds.width - 100 - 15, y: 20, width: 100, height: 15)
        self.authorLB.frame = CGRect(x: self.bookIconView.frame.maxX + 20, y: self.bookNameLB.frame.maxY + 5, width: 200, height: 15)
        self.bookDescLB.frame = CGRect(x: self.bookIconView.frame.maxX + 20, y: self.authorLB.frame.maxY + 5, width: self.contentView.bounds.width - self.bookIconView.frame.maxX - 20 - 20, height: 45)
    }
    
    func configure(model:ZSAikanParserModel) {
        let icon = model.bookIcon.length != 0 ? model.bookIcon:model.detailBookIcon
        let resource = QSResource(url: URL(string: "\(icon)") ?? URL(string: "https://www.baidu.com")!)
        self.bookIconView.kf.setImage(with: resource,placeholder: UIImage(named: "default_book_cover"))
        self.bookDescLB.text = model.bookDesc.length != 0 ? model.bookDesc:model.detailBookDesc
        self.sourceLB.text = model.name
        self.authorLB.text = model.bookAuthor
        self.bookNameLB.text = model.bookName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.bookIconView)
        contentView.addSubview(self.bookNameLB)
        contentView.addSubview(self.authorLB)
        contentView.addSubview(self.typeLB)
        contentView.addSubview(self.sourceLB)
        contentView.addSubview(self.bookDescLB)

    }
    
    override func prepareForReuse() {

        let resource = QSResource(url: URL(string: "") ?? URL(string: "https://www.baidu.com")!)
        self.bookIconView.kf.setImage(with: resource)
        self.bookDescLB.text = ""
        self.sourceLB.text = ""
        self.authorLB.text = ""
        self.bookNameLB.text = ""
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
