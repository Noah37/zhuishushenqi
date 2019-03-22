//
//  RightViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import ZSAPI
import SnapKit

class RightViewController: BaseViewController, UITableViewDataSource, UITableViewDelegate {

    var titles:[String]?
    
    var images:[String]?
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["搜索","书城","VIP专区","排行榜","主题书单","分类","免费专区","专属推荐","漫画专区","听书专区","随机看书","WIFI传书"]
        images = ["rsm_icon_0","rsm_icon_store","rsm_icon_monthly","rsm_icon_3","rsm_icon_4","rsm_icon_5","rsm_icon_exclusive","rsm_icon_recommended","rsm_icon_comic","rsm_icon_6","rsm_icon_7","rsm_icon_wifi"]
        tableView.backgroundColor  = UIColor(red: 0.211, green: 0.211, blue: 0.211, alpha: 1.00)
        
        tableView.frame = CGRect(x: self.view.bounds.width - SideVC.maximumRightOffsetWidth , y: 0, width: SideVC.maximumRightOffsetWidth, height: self.view.bounds.height)
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 55, bottom: 0, right: 0)
        tableView.qs_registerCellClass(RightTableViewCell.self)
        view.addSubview(tableView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
        tableView.snp.remakeConstraints { (make) in
            make.top.right.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(self.view.bounds.width - SideVC.maximumRightOffsetWidth)
        }
    }
    
    override func viewWillLayoutSubviews() {
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RightTableViewCell? = tableView.qs_dequeueReusableCell(RightTableViewCell.self)
        cell?.selectionStyle = .none
        
        cell?.backgroundColor = UIColor ( red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0 )
        cell?.imageView?.image = UIImage(named: images![indexPath.row])
        cell?.textLabel?.text = titles![indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {//搜索
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            let searchVC = ZSSearchViewController(style: .grouped)
            SideVC.navigationController?.pushViewController(searchVC, animated: true)
        } else if indexPath.row == 1 {
            let webVC = ZSWebViewController()
            let timeInterval = Date().timeIntervalSince1970
            webVC.url = "https://h5.zhuishushenqi.com/explore?timestamp=\(timeInterval)&platform=ios&gender=male&appversion=2.29.5&version=8"
            webVC.title = "书城"
            SideVC.navigationController?.pushViewController(webVC, animated: true)
            
        } else if indexPath.row == 2 {
            let webVC = ZSWebViewController()
            let timeInterval = Date().timeIntervalSince1970
            var url = ""
            if ZSLogin.share.hasLogin() {
                url = "https://h5.zhuishushenqi.com/monthly?platform=ios&gender=male&token=\(ZSLogin.share.token)&timeInterval=\(timeInterval*10)&appversion=2.29.5&timestamp=\(timeInterval)&version=8"
            } else {
                url = "https://h5.zhuishushenqi.com/monthly?platform=ios&gender=male&timeInterval=\(timeInterval*10)&appversion=2.29.5&timestamp=\(timeInterval)&version=8"
            }
            webVC.url = url
            webVC.title = "VIP专区"
            SideVC.navigationController?.pushViewController(webVC, animated: true)
        } else if indexPath.row == 3 {//排行榜
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            let rankVC = QSRankViewController()
            SideVC.navigationController?.pushViewController(rankVC, animated: true)
        } else if indexPath.row == 4 {//主题书单
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            SideVC.navigationController?.pushViewController(QSThemeTopicRouter.createModule(), animated: true)

        } else if indexPath.row == 5 {
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            let catelogVC = ZSCatelogViewController()
            SideVC.navigationController?.pushViewController(catelogVC, animated: true)
        } else if indexPath.row == 6 {
            let webVC = ZSWebViewController()
            let timeInterval = Date().timeIntervalSince1970
            webVC.url = "https://h5.zhuishushenqi.com/original?platform=ios&gender=male&timeInterval=\(timeInterval*10)&appversion=2.29.5&timestamp=\(timeInterval)&version=8"
            webVC.title = "免费专区"
            SideVC.navigationController?.pushViewController(webVC, animated: true)
        } else if indexPath.row == 7 {
            let webVC = ZSWebViewController()
            let timeInterval = Date().timeIntervalSince1970
            webVC.url = "https://h5.zhuishushenqi.com/original?platform=ios&gender=male&timeInterval=\(timeInterval*10)&appversion=2.29.5&timestamp=\(timeInterval)&version=8"
            webVC.title = "专属推荐"
            SideVC.navigationController?.pushViewController(webVC, animated: true)
        } else if indexPath.row == 8 {
            let webVC = ZSWebViewController()
            let timeInterval = Date().timeIntervalSince1970
            webVC.url = "https://h5.zhuishushenqi.com/cartoon?platform=ios&timestamp=\(timeInterval)&gender=male&appversion=2.29.5&version=8"
            webVC.title = "漫画专区"
            SideVC.navigationController?.pushViewController(webVC, animated: true)
        } else if indexPath.row == 9 {
            
        } else if indexPath.row == 10 {
//            https://api.zhuishushenqi.com/book/mystery-box
            let api = ZSAPI.mysteryBook()
            zs_get(api.path) { (json) in
                if let books = json?["books"] as? [[String:[String:Any]]] {
                    if let book = books[0]["book"] {
                        if let model = BookDetail.deserialize(from: book) {
                            let viewController = ZSReaderViewController()
                            viewController.viewModel.book = model
                            self.present(viewController, animated: true, completion: nil)
                        }
                    }
                }
            }
        } else if indexPath.row == 11 {
            
        }
    }
}


