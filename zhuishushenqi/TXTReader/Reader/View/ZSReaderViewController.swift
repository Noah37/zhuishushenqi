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
    
    var noneAnimationViewController = ZSNoneAnimationViewController()
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    var book:BookDetail? {
        didSet{
            viewModel.book = book
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if animationStyle == .none {
            setupNoneAnimationController()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 全局设置
        animationStyle = AppStyle.shared.animationStyle
        switch animationStyle {
        case .none:
            setupNoneAnimationController()
        case .horMove:
            QSLog("horMove")
        default:
            QSLog("default")
        }
    }

    func setupNoneAnimationController(){
        noneAnimationViewController.viewModel = viewModel
        view.addSubview(noneAnimationViewController.view)
        addChildViewController(noneAnimationViewController)
    }
}
