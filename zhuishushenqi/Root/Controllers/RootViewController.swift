//
//  RootViewController.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import Alamofire
import QSNetwork
import QSPullToRefresh

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"


class RootViewController: UIViewController {
    let kHeaderViewHeight:CGFloat = 74
    fileprivate let kHeaderBigHeight:CGFloat = 128
    fileprivate let kCellHeight:CGFloat = 64

    var bookShelfArr:[BookDetail]?
    var updateInfoArr:[UpdateInfo]?
    var segMenu:SegMenu!
    var bookShelfLB:UILabel!
    var communityView:CommunityView!
    var headerView:UIView!
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.kCellHeight
        tableView.estimatedRowHeight = self.kCellHeight
        tableView.estimatedSectionHeaderHeight = self.kHeaderViewHeight
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.qs_registerCellClass(SwipableCell.self)
        let refresh = PullToRefresh(height: 20, position: .top, tip: "正在刷新")
        tableView.addPullToRefresh(refresh, action: { 
            self.requetShelfMsg()
            self.requestBookShelf()
            self.updateInfo()
        })
        return tableView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(requestBookShelf), name: Notification.Name(rawValue: "BookShelfRefresh"), object: nil)
        self.setupSubviews()
        self.requetShelfMsg()
        self.requestBookShelf()
        self.updateInfo()
    }
    
    func testRequest(){
        QSNetwork.request("http://api.zhuishushenqi.com/toc/58082f522b7dd74f37d9dfa3?view=chapters") { (response) in
            QSLog(response.json)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.cyan

        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @objc func leftAction(_ btn:UIButton){
        SideVC.showLeftViewController()
    }
    
    @objc func rightAction(_ btn:UIButton){
        SideVC.showRightViewController()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController:UITableViewDataSource,UITableViewDelegate{
    //MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bookShelf = bookShelfArr {
            return bookShelf.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SwipableCell? = tableView.qs_dequeueReusableCell(SwipableCell.self)
        cell?.delegate = self
        cell?.model =  bookShelfArr?.count ?? 0 > indexPath.row ? bookShelfArr![indexPath.row]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        if bookShelfLB.text == nil || bookShelfLB.text == ""{
//            return kHeaderViewHeight
//        }
        return kHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //来源
        //        http://api.zhuishushenqi.com/btoc?view=summary&book=51d11e782de6405c45000068
        let cell:SwipableCell? = self.tableView.cellForRow(at: indexPath) as? SwipableCell
        let allChapterUrl = "\(BASEURL)/toc"
        requestAllChapters(withUrl: allChapterUrl,param:["view":"summary","book":cell?.model?._id ?? ""],index: indexPath.row)
    }
}

extension RootViewController:ComnunityDelegate{
    //MARK: - CommunityDelegate
    func didSelectCellAtIndex(_ index:Int){
        let dynamicVC = DynamicViewController()
        SideVC.navigationController?.pushViewController(dynamicVC, animated: true)
    }
}

extension RootViewController:SwipableCellDelegate{
    func delete(model:BookDetail){
        for index in 0..<(self.bookShelfArr?.count ?? 0){
            let bookDetail:BookDetail = self.bookShelfArr![index]
            if bookDetail._id == model._id {
                self.bookShelfArr?.remove(at: index)
                self.tableView.reloadData()
            }
        }
    }
}

extension RootViewController:SegMenuDelegate{
    func didSelectAtIndex(_ index: Int) {
        QSLog("选择了第\(index)个")
        communityView.isHidden = (index == 0 ? true:false)
    }
}

