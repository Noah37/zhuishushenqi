//
//  ZSHorizonalMoveCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/9.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSHorizonalMoveCell: UICollectionViewCell {
    
    fileprivate var _pageViewController = PageViewController()
    var pageViewController:PageViewController {
        get {
            return _pageViewController
        }
    }
    
    var page:QSPage? {
        didSet {
            pageViewController.page = page
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(pageViewController.view)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pageViewController.page = nil
    }
    
}
