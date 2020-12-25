//
//  ZSShelfTableViewCell.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/10.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import UICircularProgressRing

protocol ZSShelfTableViewCellDelegate:class {
    func shelfCell(cell:ZSShelfTableViewCell, clickMore:UIButton)
}

class ZSShelfTableViewCell: UITableViewCell {
    
    weak var delegate:ZSShelfTableViewCellDelegate?
    
    lazy var booknameLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textAlignment = .left
        lb.textColor = UIColor.black
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
    
    lazy var latestChapterLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textAlignment = .left
        lb.textColor = UIColor.red
        lb.font = UIFont.systemFont(ofSize: 13)
        return lb
    }()
    
    lazy var updateLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textAlignment = .left
        lb.textColor = UIColor.white
        lb.backgroundColor = UIColor.red
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.layer.cornerRadius = 5
        lb.layer.masksToBounds = true
        return lb
    }()
    
    lazy var moreBT:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "bbs_icon_more_big_26_26"), for: .normal)
        bt.addTarget(self, action: #selector(moreAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var darkRingBackground:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        view.isHidden = true
        return view
    }()
    
    lazy var progressRing:UICircularProgressRing = {
        let ring = UICircularProgressRing()
        ring.style = .ontop
        ring.font = UIFont.systemFont(ofSize: 13)
        ring.isHidden = true
        return ring
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(booknameLB)
        contentView.addSubview(authorLB)
        contentView.addSubview(moreBT)
        contentView.addSubview(updateLB)
        contentView.addSubview(latestChapterLB)
        imageView?.addSubview(darkRingBackground)
        imageView?.addSubview(progressRing)
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        finish()
    }
    
    @objc
    private func moreAction(bt:UIButton) {
        delegate?.shelfCell(cell: self, clickMore: bt)
    }
    
    func latestColor(update:Bool) -> UIColor {
        if update {
            return UIColor.red
        }
        return UIColor.gray
    }
    
    func configure(model:ZSShelfModel) {
        booknameLB.text = model.bookName
        authorLB.text = model.author
        latestChapterLB.text = "最近更新: \(model.latestChapterName)"
        updateLB.isHidden = (!model.update || model.bookType == .local)
        latestChapterLB.isHidden = model.bookType == .local
        latestChapterLB.textColor = latestColor(update: model.update)
        let icon = model.icon
        let resource = QSResource(url: URL(string: icon) ?? URL(string: "https://www.baidu.com")!)
        imageView?.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"))
    }
    
    func progress(value:CGFloat, max:CGFloat) {
        progressRing.isHidden = false
        darkRingBackground.isHidden = false
        progressRing.startProgress(to: value * 100 / max, duration: 0.3)
    }
    
    func finish() {
        progressRing.isHidden = true
        darkRingBackground.isHidden = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = CGRect(x: 20, y: 10, width: 60, height: bounds.height - 20)
        darkRingBackground.frame = CGRect(x: 0, y: 0, width: 60, height: bounds.height - 20)
        booknameLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 10, y: 10, width: bounds.width - 60 - (imageView?.frame.maxX ?? 0) - 10, height: 20)
        authorLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 10, y: 40, width: 200, height: 20)
        latestChapterLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 10, y: bounds.height - 30, width: self.bounds.width - (imageView?.frame.maxX ?? 0) - 10, height: 20)
        let booknameSize = booknameLB.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 20))
        updateLB.frame = CGRect(x: (imageView?.frame.maxX ?? 0) + 20 + booknameSize.width, y: 15, width: 10, height: 10)
        moreBT.frame = CGRect(x: bounds.width - 60, y: 10, width: 40, height: 40)
        progressRing.frame = imageView?.bounds  ?? CGRect(x: 0, y: 0, width: 60, height: bounds.height - 20)
        separatorInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: -20)
    }

}
