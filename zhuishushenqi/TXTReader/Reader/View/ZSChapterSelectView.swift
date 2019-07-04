//
//  ZSChapterSelectView.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/9.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit
//import YYText
//import YYCategories

class ZSChapterSelectView: UICollectionView {
    
    var items:[ZSChapterSelectItemModel] = []
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width/2 - 10*3/2, height: 40)
        super.init(frame: frame, collectionViewLayout: flowLayout)
        self.qs_registerCellClass(ZSChapterSelectItem.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var numberOfSections: Int {
        return 1
    }

    override func numberOfItems(inSection section: Int) -> Int {
        return items.count
    }
    
    override func cellForItem(at indexPath: IndexPath) -> UICollectionViewCell? {
        let cell = self.qs_dequeueReusableCell(ZSChapterSelectItem.self, for: indexPath)
        if indexPath.item == 0 {
            cell.setTitle(title: "本章")
        } else if indexPath.item == items.count - 1 {
            cell.setTitle(title: "后xx章")
            cell.setDiscount(discount: "\(0.75 * 10)")
        } else {
            cell.setTitle(title: "后\(items[indexPath.item].num)章")
            cell.setDiscount(discount: "\(items[indexPath.item].discount * 10.0)")
        }
        return cell
    }

}

class ZSChapterSelectItem: UICollectionViewCell {
    
    private var titleLabel:YYLabel!
    
    var selectedItem:Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        titleLabel = YYLabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        contentView.addSubview(titleLabel)
    }
    
    override func prepareForReuse() {
        titleLabel.attributedText = nil
        titleLabel.text = nil
    }
    
    func setTitle(title:String?) {
        if (titleLabel.attributedText ?? NSAttributedString(string: "")).string == title {
            let titleText = title ?? ""
            let attr = NSMutableAttributedString(string: titleText)
            attr.yy_font = UIFont.systemFont(ofSize: 13)
            attr.yy_alignment = .center
            titleLabel.attributedText = attr
        } else {
            // 可能已经设置了discount
            let discount = titleLabel.attributedText?.string ?? ""
            setDiscount(discount: discount)
        }
    }
    
    func setDiscount(discount:String) {
        let title = titleLabel.attributedText ?? NSMutableAttributedString(string: "")
        let attr = NSMutableAttributedString(string: "\(title)\(discount)折")
        attr.yy_font = UIFont.systemFont(ofSize: 13)
        attr.yy_alignment = .center
        attr.yy_setTextHighlight(NSMakeRange(0, title.length), color: UIColor.gray, backgroundColor: UIColor.clear, userInfo: nil)
        attr.yy_setTextHighlight(NSMakeRange(title.length, (discount as NSString).length), color: UIColor.white, backgroundColor: UIColor.orange, userInfo: nil)
        titleLabel.attributedText = attr
    }
    
}
