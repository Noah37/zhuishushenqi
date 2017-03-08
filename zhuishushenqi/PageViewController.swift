//
//  PageViewController.swift
//  PageViewController
//
//  Created by caonongyun on 16/10/9.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var pageIndex:Int = 0
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.white
        view.addSubview(pageView)
        view.addSubview(currentPageLabel)
        view.addSubview(titleLabel)
    }
    
    lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = CGRect(x: 20, y: 20, width: self.view.bounds.size.width - 40, height: self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.white
        return pageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect(x: 0,y: 0,width: UIScreen.main.bounds.size.width,height: 20))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        return label
    }()
    
    var totalPage:Int = 0{
        didSet{
            self.currentPageLabel.text = "\(self.pageIndex + 1)/\(self.totalPage)"
        }
    }
    
    fileprivate lazy var currentPageLabel:UILabel = {
       let label = UILabel(frame: CGRect(x: 0,y: self.view.bounds.size.height - 30,width: self.view.bounds.size.width,height: 30))
        label.text = "\(self.pageIndex + 1)/\(self.totalPage)"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
