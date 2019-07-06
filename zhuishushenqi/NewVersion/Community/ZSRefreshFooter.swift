//
//  ZSRefreshFooter.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/5.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import MJRefresh

class ZSRefreshFooter: MJRefreshFooter {

    lazy var indicatorView:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.style = UIActivityIndicatorView.Style.white
        return view
    }()

    override func placeSubviews() {
        super.placeSubviews()
        
    }
    
    override func prepare() {
        super.prepare()
        
    }

}
