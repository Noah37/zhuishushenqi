//
//  ZSReaderBaseViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/11.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSReaderBaseViewController: UIViewController, ZSReaderControllerProtocol {
    var viewModel = ZSReaderViewModel()
    
    var pageViewController = PageViewController()
    
    
    typealias Item = Book
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
