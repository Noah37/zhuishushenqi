//
//  PageViewController.swift
//  PageViewController
//
//  Created by Nory Chao on 16/10/9.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class PageViewController: UIViewController {

    var pageInfo:PageInfo?{
        didSet{
            pageView.attribute = pageInfo?.chapterInfo?.attribute ?? NSDictionary()
            if (pageInfo!.chapterInfo!.ranges?.count)! > 0 {
                let rangeString = pageInfo!.chapterInfo!.ranges![pageInfo?.pageIndex ?? 0]
                let range = NSRangeFromString(rangeString)
                var content = pageInfo!.chapterInfo!.cpContent! as NSString
                if content == "" {
                    content = pageInfo?.chapterInfo?.body as NSString? ?? ""
                }
                pageView.attributedText = NSMutableAttributedString(string: content.substring(with: range))
                currentPageLabel.text = "\((pageInfo?.pageIndex ?? 0) + 1)/\(pageInfo?.total ?? 0)"
                titleLabel.text = "\(pageInfo?.chapterInfo?.title ?? "")"
            }else{
                //只有一页，或者没有
                pageInfo!.chapterInfo!.ranges = ["{0,0}"]
                let rangeString = pageInfo!.chapterInfo!.ranges![pageInfo?.pageIndex ?? 0]
                let range = NSRangeFromString(rangeString)
                var content = pageInfo!.chapterInfo!.cpContent! as NSString
                if content == "" {
                    content = pageInfo?.chapterInfo?.body as NSString? ?? ""
                }
                pageView.attributedText = NSMutableAttributedString(string: content.substring(with: range))
                currentPageLabel.text = "\((pageInfo?.pageIndex ?? 0) + 1)/\(pageInfo?.total ?? 0)"
                titleLabel.text = "\(pageInfo?.chapterInfo?.title ?? "")"

            }
        }
    }
    
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
        pageView.frame = CGRect(x:20,y: 20,width: self.view.bounds.size.width - 40,height: self.view.bounds.size.height - 40)
        pageView.backgroundColor = UIColor.white
        return pageView
    }()
    
    lazy var titleLabel:UILabel = {
        let label = UILabel(frame: CGRect(x:0,y:0,width:UIScreen.main.bounds.size.width,height:20))
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var currentPageLabel:UILabel = {
        let label = UILabel(frame: CGRect(x:0,y:self.view.bounds.size.height - 30,width:self.view.bounds.size.width,height:30))
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
