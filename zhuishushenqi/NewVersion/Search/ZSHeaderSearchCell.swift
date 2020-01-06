//
//  ZSHeaderSearchCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum ZSHeaderSearchType {
    case hot
    case recommend
    case history
}

class ZSHeaderSearchCell: UITableViewCell {
    
    var clickHandler:ZSSearchClickHandler?
    
    private var type:ZSHeaderSearchType = .hot { didSet { reloadData() } }
    
    private var model:ZSHeaderSearch?
    
    private var hotView:ZSSearchHotView?
    private var recView:ZSSearchRecommendView?

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hotView?.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
        recView?.frame = CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: self.contentView.bounds.height)
    }
    
    func configure(model:ZSHeaderSearch) {
        self.model = model
        self.type = model.type
    }

    private func reloadData() {
        removeOtherSubview()
        switch self.type {
        case .hot:
            showHotView()
        case .recommend:
            showRecommendView()
        default:
            break
        }
    }
    
    private func showHotView() {
        let hotView = ZSSearchHotView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: (model?.height ?? 0)))
        hotView.cellsFrame = model?.items as! [ZSSearchHotwords]
        hotView.clickHandler = { [unowned self] model in
            self.clickHandler?(model)
        }
        self.hotView = hotView
        self.contentView.addSubview(hotView)
    }
    
    private func showRecommendView() {
       let hotView = ZSSearchRecommendView(frame: CGRect(x: 0, y: 0, width: self.contentView.bounds.width, height: (model?.height ?? 0)))
       hotView.cellsFrame = model?.items as! [ZSHotWord]
       hotView.clickHandler = { [unowned self] word in
           self.clickHandler?(word)
       }
       self.recView = hotView
       self.contentView.addSubview(hotView)
    }
    
    private func removeOtherSubview() {
        for subview in self.contentView.subviews {
            if !subview.isKind(of: ZSHeaderSearchTopView.self) {
                subview.removeFromSuperview()
            }
        }
    }
}

class ZSHeaderSearchTopView:UITableViewHeaderFooterView {
    lazy var titleLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.black
        lb.font = UIFont.systemFont(ofSize: 17)
        return lb
    }()
    
    lazy var detailButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitleColor(UIColor.gray, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        return bt
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(self.titleLabel)
        contentView.addSubview(self.detailButton)
        backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 20, y: 20, width: 200, height: 21)
        let width = self.detailButton.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: 55)).width
        self.detailButton.frame = CGRect(x: self.bounds.width - width - 20, y: 0, width: width, height: 55)
    }
}
