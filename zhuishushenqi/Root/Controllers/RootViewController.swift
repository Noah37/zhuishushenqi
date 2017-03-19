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

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"


class RootViewController: UIViewController {

    var bookShelfArr:[BookDetail]?
    var updateInfoArr:[UpdateInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(requestBookShelf), name: Notification.Name(rawValue: "BookShelfRefresh"), object: nil)
        
        initSubview()
        
        requetShelfMsg()
        requestBookShelf()
        updateInfo()
        
        testRequest()
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
    
    fileprivate func initSubview(){
        RootNavigationView.make(delegate: self)
        
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["追书架","追书社区"])
        segView.menuDelegate = self
        view.addSubview(segView)
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.qs_registerCellClass(SwipableCell.self)
        self.tableView = tableView
        view.addSubview(tableView)
        view.addSubview(communityView)
    }
    
    @objc func leftAction(_ btn:UIButton){
        SideViewController.sharedInstance.showLeftViewController()
    }
    
    @objc func rightAction(_ btn:UIButton){
        SideViewController.sharedInstance.showRightViewController()
    }
    
    lazy var shelfMsgLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 20,y: 0,width: ScreenWidth - 40,height: 44)
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    fileprivate lazy var communityView:CommunityView = {
       let com = CommunityView()
        com.frame = CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104)
        com.delegate = self
        com.isHidden = true
        return com
    }()
    
    var tableView:UITableView?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
    
    
    
    func requestAllChapters(withUrl url:String,param:[String:Any],index:Int){
        
        //先查询书籍来源，根据来源返回的id再查询所有章节
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            var res:[ResourceModel]?
            if let resources = response.json  {
                do{
                   res = try XYCBaseModel.model(withModleClass: ResourceModel.self, withJsArray: resources as! [Any]) as? [ResourceModel]
                }catch{
                    QSLog(error)
                }
            }
            
            if (res?.count ?? 0) > 0 {
                DispatchQueue.main.async {
                    let txtVC = TXTReaderViewController()
                    txtVC.id = res?[1]._id ?? ""
                    txtVC.bookId = self.bookShelfArr?[index]._id ?? ""
                    txtVC.resources = res!
                    self.present(txtVC, animated: true, completion: nil)
                }
            }
        }
    }
}

extension RootViewController:UITableViewDataSource,UITableViewDelegate{
    //MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelfArr?.count ?? 0 > 0 ? bookShelfArr!.count:0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell:SwipableCell? = tableView.qs_dequeueReusableCell(SwipableCell.self)
        cell?.delegate = self
        cell?.model =  bookShelfArr?.count ?? 0 > indexPath.row ? bookShelfArr![indexPath.row]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        let signIn = UIButton(type: .custom)
        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: UIControlState())
        signIn.setBackgroundImage(UIImage(named: "sign_bg"), for: .highlighted)
        signIn.frame = CGRect(x: -3, y: 54, width: ScreenWidth + 6, height: 72)
        
        let sign_gotoSign = UIButton(type: .custom)
        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: UIControlState())
        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), for: .highlighted)
        sign_gotoSign.frame = CGRect(x: ScreenWidth - 100 - 10, y: 17, width: 100, height: 37)
        signIn.addSubview(sign_gotoSign)
        headerView.addSubview(signIn)
        
        if shelfMsgLabel.text == nil || shelfMsgLabel.text == ""{
            signIn.frame = CGRect(x: -3, y: 0, width: ScreenWidth + 6, height: 72)
            sign_gotoSign.frame = CGRect(x: ScreenWidth - 100 - 10, y: 17, width: 100, height: 37)
        }
        headerView.addSubview(shelfMsgLabel)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if shelfMsgLabel.text == nil || shelfMsgLabel.text == ""{
            return 74
        }
        return 128
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        //来源
        //        http://api.zhuishushenqi.com/btoc?view=summary&book=51d11e782de6405c45000068
        let cell:SwipableCell? = self.tableView?.cellForRow(at: indexPath) as? SwipableCell
        let allChapterUrl = "\(baseUrl)/toc"
        requestAllChapters(withUrl: allChapterUrl,param:["view":"summary","book":cell?.model?._id ?? ""],index: indexPath.row)
    }
}

extension RootViewController:ComnunityDelegate{
    //MARK: - CommunityDelegate
    func didSelectCellAtIndex(_ index:Int){
        let dynamicVC = DynamicViewController()
        let dynamicApi = DynamicAPI()
        dynamicApi.startWithCompletionBlockWithHUD({ (request) in
            let timeline = request.object(forKey: "timeline")
            dynamicVC.timeline =  timeline as? NSArray ?? []
            SideViewController.sharedInstance.navigationController?.pushViewController(dynamicVC, animated: true)
        }) { (request) in
            
        }
    }
}

extension RootViewController:SwipableCellDelegate{
    func delete(model:BookDetail){
        for index in 0..<(self.bookShelfArr?.count ?? 0){
            let bookDetail:BookDetail = self.bookShelfArr![index]
            if bookDetail._id == model._id {
                self.bookShelfArr?.remove(at: index)
                self.tableView?.reloadData()
            }
        }
    }
}

extension RootViewController:SegMenuDelegate{
    func didSelectAtIndex(_ index: Int) {
        XYCLog("选择了第\(index)个")
        communityView.isHidden = (index == 0 ? true:false)
    }
}

