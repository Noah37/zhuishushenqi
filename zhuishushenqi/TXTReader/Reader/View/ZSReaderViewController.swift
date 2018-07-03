//
//  ZSReaderViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSReaderViewController: UIViewController {
    
    var animationStyle:ZSReaderAnimationStyle = .none

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 全局设置
        animationStyle = AppStyle.shared.animationStyle
    }

}
