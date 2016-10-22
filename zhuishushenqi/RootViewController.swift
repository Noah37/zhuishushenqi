//
//  RootViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/16.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit
import Alamofire

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"


class RootViewController: UIViewController,SegMenuDelegate,UITableViewDelegate,UITableViewDataSource {

    var bookShelfArr:[BookShelf]?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initSubview()
        
        let config = XYCNetworkConfig.sharedInstance
        config.baseUrl = "http://api.zhuishushenqi.com"
        let shelfMsgApi = ShelfMessageAPI()
        shelfMsgApi.startWithCompletionBlockWithHUD({ (request) in
                XYCLog("request:\(request.objectForKey("message"))")
            let postLink = request.objectForKey("message")?.objectForKey("postLink")
            self.shelfMsgLabel.text = "\((self.postLinkArchive(postLink).1))"
            }) { (request) in
        }
        requestBookShelf()
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.cyanColor()

        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        UIApplication.sharedApplication().statusBarHidden = false

    }
    
    private func requestBookShelf(){
        let bookShelfApi = BookShelfAPI()
        bookShelfApi.startWithCompletionBlockWithHUD({ (request) in
                XYCLog(request)
            if let bookshelf = request["bookshelf"] as? NSArray{
                do {
                    self.bookShelfArr = try  XYCBaseModel.modelWithModleClass(BookShelf.self, withJsArray: bookshelf as [AnyObject]) as? [BookShelf]
                    self.tableView?.reloadData()
                }catch {
                    
                }
            }
            self.tableView!.reloadData()
            }) { (request) in
                
        }
    }
    
    private func postLinkArchive(postLink:AnyObject?) ->(String,String){
        if postLink == nil{
            return ("","")
        }
        let rangeRight = postLink?.rangeOfString("]]")
        let rangeBet = postLink?.rangeOfString(":")
        let rangeOfSpace = postLink?.rangeOfString("【")
        let urlLink = postLink?.substringWithRange(NSMakeRange(rangeBet!.location + 1, rangeOfSpace!.location - rangeBet!.location-1))
        let title = postLink?.substringWithRange(NSMakeRange(rangeOfSpace!.location, rangeRight!.location - rangeOfSpace!.location))
        return (urlLink!,title!)
    }
    
    
    private func initSubview(){
        let leftBtn = BarButton(type: .Custom)
        leftBtn .addTarget(self, action: #selector(leftAction(_:)), forControlEvents: .TouchUpInside)
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu"), forState: .Normal)
        leftBtn.setBackgroundImage(UIImage(named: "nav_home_side_menu_selected"), forState: .Highlighted)
        leftBtn.frame = CGRectMake(0, 0, 40, 40)
        let leftBar = UIBarButtonItem(customView: leftBtn)
        
        let rightBtn = BarButton(type: .Custom)
        rightBtn.addTarget(self, action: #selector(rightAction(_:)), forControlEvents: .TouchUpInside)
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book"), forState: .Normal)
        rightBtn.setBackgroundImage(UIImage(named: "nav_add_book_selected"), forState: .Highlighted)
        rightBtn.frame = CGRectMake(0, 0, 40, 40)
        let rightBar = UIBarButtonItem(customView: rightBtn)
    
        navigationItem.leftBarButtonItem = leftBar
        navigationItem.rightBarButtonItem = rightBar
        let titleImg = UIImageView(image: UIImage(named: "zssq_image"))
        navigationItem.titleView = titleImg
        
        let segView = SegMenu(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, 40), WithTitles: ["追书架","追书社区"])
        segView.menuDelegate = self
        view.addSubview(segView)
        let tableView = UITableView(frame: CGRectMake(0, 104, ScreenWidth, ScreenHeight - 104), style: UITableViewStyle.Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
        view.addSubview(tableView)
    }
    
    @objc private func leftAction(btn:UIButton){
        SideViewController.sharedInstance.showLeftViewController()
    }
    
    @objc private func rightAction(btn:UIButton){
        SideViewController.sharedInstance.showRightViewController()
    }
    
    func didSelectAtIndex(index: Int) {
        XYCLog("选择了第\(index)个")
    }
    
    private lazy var shelfMsgLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRectMake(20,0,ScreenWidth - 40,44)
        label.textColor = UIColor.grayColor()
        label.font = UIFont.systemFontOfSize(13)
        label.textAlignment = .Center
        return label
    }()
    
    var tableView:UITableView?

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
    
    //MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bookShelfArr?.count > 0 ? bookShelfArr!.count:0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIden:String = "cellIden"
        var cell:SwipableCell? = tableView.dequeueReusableCellWithIdentifier(cellIden) as? SwipableCell
        if cell == nil{
            cell = SwipableCell.init(style: UITableViewCellStyle.Default, reuseIdentifier: cellIden)
        }
        cell?.model =  bookShelfArr?.count > indexPath.row ? bookShelfArr![indexPath.row]:nil
        if indexPath.row == 0 {
            
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        let signIn = UIButton(type: .Custom)
        signIn.setBackgroundImage(UIImage(named: "sign_bg"), forState: .Normal)
        signIn.setBackgroundImage(UIImage(named: "sign_bg"), forState: .Highlighted)
        signIn.frame = CGRectMake(-3, 54, ScreenWidth + 6, 72)
        
        let sign_gotoSign = UIButton(type: .Custom)
        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), forState: .Normal)
        sign_gotoSign.setBackgroundImage(UIImage(named: "sign_gotoSign"), forState: .Highlighted)
        sign_gotoSign.frame = CGRectMake(ScreenWidth - 100 - 10, 17, 100, 37)
        signIn.addSubview(sign_gotoSign)
         headerView.addSubview(signIn)
        
        if shelfMsgLabel.text == nil || shelfMsgLabel.text == ""{
            signIn.frame = CGRectMake(-3, 0, ScreenWidth + 6, 72)
            sign_gotoSign.frame = CGRectMake(ScreenWidth - 100 - 10, 17, 100, 37)
        }
        headerView.addSubview(shelfMsgLabel)
        
        return headerView
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 64
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if shelfMsgLabel.text == nil || shelfMsgLabel.text == ""{
            return 74
        }
        return 128
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
//        let chapterUrl =  "http://api.zhuishushenqi.com/ctoc/\(bookShelfArr![indexPath.row]._id!)"
        requestAllChapters(withUrl: AllChapterUrl)
    }
    
    func requestAllChapters(withUrl url:String){
        HUD.showProgressHud(true)
        Alamofire.request(.GET, url, parameters: ["view":"chapters"])
            .validate()
            .responseJSON { response in
                HUD.hide()
                print("request:\(response.request)")  // original URL request
                print("response:\(response.response)") // URL response
                //                print("data:\(response.data)")     // server data
                print("result:\(response.result.value)")   // result of response serialization
                switch response.result {
                case .Success:
                    let vc = OnlineViewController()
                    let model = PageInfoModel()
                    model.type = .Online
                    vc.currentPage = model.pageIndex
                    vc.currentChapter = model.chapter
                    vc.chapters = (response.result.value as! NSDictionary)["chapters"] as! NSArray
                    vc.bookName = (response.result.value as! NSDictionary)["_id"] as! String
                    print("Validation Successful")
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide()
                        self.presentViewController(vc, animated: true, completion: nil)
                    })
                    
                case .Failure(let error):
                    print(error)
                    
                }
        }
    }

    
    
    
}

