//
//  RootViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/16.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire
import QSNetwork

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"


class RootViewController: UIViewController,SegMenuDelegate,UITableViewDelegate,UITableViewDataSource,ComnunityDelegate {

    var bookShelfArr:[BookDetail]?
    var updateInfoArr:[UpdateInfo]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NotificationCenter.default.addObserver(self, selector: #selector(requestBookShelf), name: Notification.Name(rawValue: "BookShelfRefresh"), object: nil)
        
        initSubview()
//        http://api.zhuishushenqi.com/notification/shelfMessage?platform=ios
        let shelfUrl = "\(baseUrl)/notification/shelfMessage"
//        QSNetwork.setDefaultURL(url: baseUrl)
        QSNetwork.request(shelfUrl, method: HTTPMethodType.get, parameters: ["platform":"ios"], headers: nil) { (response) in
            if let _ = response.json {
                let message:AnyObject? = response.json?["message"] as AnyObject
                if message?.isKind(of: NSNull.self) == false {
                    let postLink = message?.object(forKey: "postLink")
                    DispatchQueue.main.async {
                        self.shelfMsgLabel.text = "\(self.postLinkArchive(postLink as AnyObject?).1)"
                        self.tableView?.reloadData()
                    }
                }
            }
        }
        
//        let config = XYCNetworkConfig.sharedInstance
//        config.baseUrl = "http://api.zhuishushenqi.com"
//        let shelfMsgApi = ShelfMessageAPI()
//        shelfMsgApi.startWithCompletionBlockWithHUD({ (request) in
//                XYCLog("request:\(request.object(forKey: "message"))")
//            let postLink = (request.object(forKey: "message") as AnyObject).object(forKey: "postLink")
//            self.shelfMsgLabel.text = "\((self.postLinkArchive(postLink as AnyObject?).1))"
//            }) { (request) in
//        }
        requestBookShelf()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.cyan

        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @objc func requestBookShelf(){
        //已登录状态的书架
//        let bookShelfApi = BookShelfAPI()
//        bookShelfApi.startWithCompletionBlockWithHUD({ (request) in
//                XYCLog(request)
//            if let bookshelf = request["bookshelf"] as? NSArray{
//                do {
//                    self.bookShelfArr = try  XYCBaseModel.model(withModleClass: BookShelf.self, withJsArray: bookshelf as [AnyObject]) as? [BookShelf]
//                    self.tableView?.reloadData()
//                }catch {
//                    
//                }
//            }
//            self.tableView!.reloadData()
//            }) { (request) in
//
//        }
        
        //未登录中状态下，图书的信息保存在userdefault中
        if !User.user.isLogin {
            self.bookShelfArr = BookShelfInfo.books.bookShelf as? [BookDetail]
            updateInfo()
            let url:NSString = "http://www.luoqiu.com/read/175859"
            print(url.lastPathComponent)
            print(url.deletingLastPathComponent)
            print(url.pathComponents)
            print(url.pathExtension)
            if url.pathExtension == "" {
                print(url.pathExtension)
            }
        }
    }
    
    //匹配当前书籍的更新信息
    func updateInfo(){
//        http://api.zhuishushenqi.com/book?view=updated&id=5816b415b06d1d32157790b1,51d11e782de6405c45000068
        let url = "\(baseUrl)/book"
        let param = ["view":"updated","id":"\(self.param())"]
        QSNetwork.setDefaultURL(url: baseUrl)
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            if let json:[Any] = response.json as? [Any] {
                do{
                    self.updateInfoArr = try XYCBaseModel.model(withModleClass: UpdateInfo.self, withJsArray: json as [Any]!) as? [UpdateInfo]
                    self.updateToModel()
                }catch{
                    
                }
            }
        }
    }
    
    //需要将对应的update信息赋给model
    func updateToModel(){
        for index in 0..<(self.updateInfoArr?.count ?? 0) {
            let updateInfo = self.updateInfoArr![index]
            for y in 0..<(self.bookShelfArr?.count ?? 0) {
                let bookShelf = self.bookShelfArr![y]
                if updateInfo._id == bookShelf._id {
                    bookShelf.updateInfo = updateInfo
                    let bookShelfMutable = NSMutableArray(array: self.bookShelfArr ?? [])
                    bookShelfMutable.replaceObject(at: y, with: bookShelf)
                    let bookShelfUnMutable = NSArray(array: bookShelfMutable)
                    self.bookShelfArr = bookShelfUnMutable as? [BookDetail]
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView?.reloadData()
        }
    }
    
    func param()->String{
        var idString = ""
        if let bookArr:[BookDetail] = self.bookShelfArr{
            var index = 0
            for item in bookArr {
                idString = idString.appending(item._id)
                if index != bookArr.count - 1 {
                    idString = idString.appending(",")
                }
                index += 1
            }
        }
        return idString
    }
    
    fileprivate func postLinkArchive(_ postLink:AnyObject?) ->(String,String){
        if postLink == nil{
            return ("","")
        }
        let rangeRight = postLink?.range(of: "]]")
        let rangeBet = postLink?.range(of: ":")
        let rangeOfSpace = postLink?.range(of: "【")
        let urlLink = postLink?.substring(with: NSMakeRange(rangeBet!.location + 1, rangeOfSpace!.location - rangeBet!.location-1))
        let title = postLink?.substring(with: NSMakeRange(rangeOfSpace!.location, rangeRight!.location - rangeOfSpace!.location))
        return (urlLink!,title!)
    }
    
    
    fileprivate func initSubview(){
        let leftBtn = BarButton(type: .custom)
        leftBtn .addTarget(self, action: #selector(leftAction(_:)), for: .touchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu"), for: UIControlState())
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu_selected"), for: .highlighted)
        leftBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let leftBar = UIBarButtonItem(customView: leftBtn)
        
        let rightBtn = BarButton(type: .custom)
        rightBtn.addTarget(self, action: #selector(rightAction(_:)), for: .touchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book"), for: UIControlState())
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book_selected"), for: .highlighted)
        rightBtn.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let rightBar = UIBarButtonItem(customView: rightBtn)
    
        navigationItem.leftBarButtonItem = leftBar
        navigationItem.rightBarButtonItem = rightBar
        let titleImg = UIImageView(image: UIImage(named: "zssq_image"))
        navigationItem.titleView = titleImg
        
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["追书架","追书社区"])
        segView.menuDelegate = self
        view.addSubview(segView)
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: UITableViewStyle.grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        view.addSubview(tableView)
        view.addSubview(communityView)
    }
    
    @objc fileprivate func leftAction(_ btn:UIButton){
        SideViewController.sharedInstance.showLeftViewController()
    }
    
    @objc fileprivate func rightAction(_ btn:UIButton){
        SideViewController.sharedInstance.showRightViewController()
    }
    
    
    func didSelectAtIndex(_ index: Int) {
        XYCLog("选择了第\(index)个")
        communityView.isHidden = (index == 0 ? true:false)
    }
    
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
    
    fileprivate lazy var shelfMsgLabel:UILabel = {
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
    
    //MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelfArr?.count ?? 0 > 0 ? bookShelfArr!.count:0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIden:String = "cellIden"
        var cell:SwipableCell? = tableView.dequeueReusableCell(withIdentifier: cellIden) as? SwipableCell
        if cell == nil{
            cell = SwipableCell.init(style: UITableViewCellStyle.default, reuseIdentifier: cellIden)
        }
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
        requestAllChapters(withUrl: allChapterUrl,param:["view":"summary","book":cell?.model?._id ?? ""])
    }
    
    func requestAllChapters(withUrl url:String,param:[String:Any]){
        //先查询书籍来源，根据来源返回的id再查询所有章节
        QSNetwork.request(url, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            var res:NSArray = [ResourceModel]() as NSArray
            if let resources = response.json as? NSArray {
                do{
                   res = try XYCBaseModel.model(withModleClass: ResourceModel.self, withJsArray: resources as! [Any]) as NSArray
                }catch{
                    print(error)
                }
            }
            
            if let json:NSDictionary = (response.json as? NSArray)?.object(at: 1) as? NSDictionary {
                DispatchQueue.main.async {
                    let txtVC = TXTReaderViewController()
                    txtVC.id = json["_id"] as? String ?? ""
                    txtVC.resources = res
                    self.present(txtVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func chapterLink(allSources:NSArray,id:String)->NSDictionary{
        //获取免费来源
        for index in 0..<allSources.count {
            if let source:NSDictionary = allSources[index] as! NSDictionary {

            }
        }
        return allSources[0] as? NSDictionary ?? ["":""]
    }
}

