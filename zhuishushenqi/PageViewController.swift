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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        view.backgroundColor = UIColor.whiteColor()
        view.addSubview(pageView)
        view.addSubview(currentPageLabel)
        view.addSubview(titleLabel)
    }
    
    lazy var pageView:PageView = {
        let pageView = PageView()
        pageView.frame = CGRectMake(20, 20, self.view.bounds.size.width - 40, self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.whiteColor()
        return pageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRectMake(0,0,UIScreen.mainScreen().bounds.size.width,20))
        label.textAlignment = .Center
        label.font = UIFont.systemFontOfSize(11)
        label.textColor = UIColor.grayColor()
        return label
    }()
    
    var totalPage:Int = 0{
        didSet{
            self.currentPageLabel.text = "\(self.pageIndex + 1)/\(self.totalPage)"
        }
    }
    
    private lazy var currentPageLabel:UILabel = {
       let label = UILabel(frame: CGRectMake(0,self.view.bounds.size.height - 30,self.view.bounds.size.width,30))
        label.text = "\(self.pageIndex + 1)/\(self.totalPage)"
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        return label
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
