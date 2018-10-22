//
//  ZSLoginViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/22.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSLoginViewController: BaseViewController {
    
    lazy var phoneImageView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 200))
        return imageView
    }()
    
    lazy var loginView:ZSLoginView = {
        let loginView = ZSLoginView(frame: CGRect(x: 0, y: self.phoneImageView.frame.maxY, width: self.view.bounds.width, height: 170))
        return loginView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.phoneImageView)
        self.view.addSubview(self.loginView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }

}
