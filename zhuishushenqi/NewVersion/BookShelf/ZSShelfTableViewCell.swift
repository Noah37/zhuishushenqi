//
//  ZSShelfTableViewCell.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/10.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSShelfTableViewCellDelegate:class {
    func shelfCell(cell:ZSShelfTableViewCell, clickMore:UIButton)
}

class ZSShelfTableViewCell: UITableViewCell {
    
    weak var delegate:ZSShelfTableViewCellDelegate?
    
    lazy var booknameLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textAlignment = .left
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var authorLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textAlignment = .left
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: 15)
        return lb
    }()
    
    lazy var moreBT:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "bbs_icon_more_big_26_26"), for: .normal)
        bt.addTarget(self, action: #selector(moreAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(booknameLB)
        contentView.addSubview(authorLB)
        contentView.addSubview(moreBT)
    }
    
    required init?(coder: NSCoder) {
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
    
    @objc
    private func moreAction(bt:UIButton) {
        delegate?.shelfCell(cell: self, clickMore: bt)
    }
    
    func configure(model:ZSShelfModel) {
        booknameLB.text = model.bookName
        authorLB.text = model.author
        let icon = model.icon
        let resource = QSResource(url: URL(string: icon) ?? URL(string: "www.baidu.com")!)
        imageView?.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: 10, width: 60, height: bounds.height - 20)
        booknameLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 10, y: 10, width: 200, height: 20)
        authorLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 10, y: bounds.height - 30, width: 200, height: 20)
        moreBT.frame = CGRect(x: bounds.width - 60, y: 10, width: 40, height: 40)
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
    }

}
