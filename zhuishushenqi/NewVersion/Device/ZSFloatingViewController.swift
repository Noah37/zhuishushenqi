//
//  ZSFloatingViewController.swift
//  zhuishushenqi
//
//  Created by daye on 2021/6/9.
//  Copyright © 2021 QS. All rights reserved.
//

import UIKit

class ZSFloatingViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.clear
    }
    
    override var prefersStatusBarHidden: Bool {
        return KeyWindow?.rootViewController?.prefersStatusBarHidden ?? true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return KeyWindow?.rootViewController?.preferredStatusBarStyle ?? .lightContent
    }
}
