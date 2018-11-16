//
//  ZSMultiplePayView.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/9.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSMultiplePayView: UIView {
    var maskingView:UIView!
    var backgroundView:UIView!
    var collapseBtn:UIButton!
    var startChapterTipTitleLabel:UILabel!
    var purchaseInfoBtn:UIButton!
    
    var chapterSelectionView:ZSChapterSelectView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        isUserInteractionEnabled = true
        maskingView = UIView(frame: self.bounds)
        maskingView.backgroundColor = UIColor(white: 0.2, alpha: 1.0)
        maskingView.isUserInteractionEnabled = true
        addSubview(maskingView)
        
        backgroundView = UIView(frame: CGRect(x: 0, y: 100, width: self.bounds.width, height: self.bounds.height - 100))
        backgroundView.backgroundColor = UIColor.white
        backgroundView.isUserInteractionEnabled = true
        addSubview(backgroundView)
        
        collapseBtn = UIButton(type: .custom)
        collapseBtn.setTitle("折叠", for: .normal)
        collapseBtn.setTitleColor(UIColor.gray, for: .normal)
        collapseBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        collapseBtn.frame = CGRect(x: 20, y: 15, width: 60, height: 30)
        addSubview(collapseBtn)
        
        startChapterTipTitleLabel = UILabel(frame: CGRect(x: 0, y: 15, width: self.bounds.width, height: 30))
        startChapterTipTitleLabel.textAlignment = .center
        startChapterTipTitleLabel.font = UIFont.systemFont(ofSize: 17)
        startChapterTipTitleLabel.textColor = UIColor.black
        addSubview(startChapterTipTitleLabel)
        
        purchaseInfoBtn = UIButton(type: .custom)
        purchaseInfoBtn.setTitle("购买说明", for: .normal)
        purchaseInfoBtn.setTitleColor(UIColor.gray, for: .normal)
        purchaseInfoBtn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        purchaseInfoBtn.frame = CGRect(x: 20, y: 15, width: 60, height: 30)
        addSubview(purchaseInfoBtn)
        
        
        chapterSelectionView = ZSChapterSelectView(frame: CGRect(x: 0, y: 60, width: self.bounds.width, height: 180), collectionViewLayout: UICollectionViewLayout())
        
        addSubview(chapterSelectionView)
    }

    
}
