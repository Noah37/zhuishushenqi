//
//  ThemeTopicViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class ThemeTopicViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var id:String? = ""
    var books:NSArray? = []
    fileprivate var selectedIndex = 0
    fileprivate var tag = ""
    fileprivate var gender = ""
    
    fileprivate var booksModel:NSArray? = []
    fileprivate var titleView:UIButton?
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(ThemeTopicCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestDetail(index: selectedIndex,tag: "",gender: "")
        titleView(title: "全部书单")
    }
    
    fileprivate func initSubview(){
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["本周最热","最新发布","最多收藏"])
        segView.menuDelegate = self
        view.addSubview(segView)
    }
    
    func titleView(title:String) -> Void {
        if let _ = self.titleView {
            self.titleView?.setTitle(title, for: .normal)
            let width = (self.titleView?.currentTitle ?? "").qs_width(UIFont.systemFont(ofSize: 17), height: 21)*1.3
            self.titleView?.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, -width)
            return
        }
        let titleView = UIButton(type: .custom)
        titleView.frame = CGRect(x: 0, y: 0, width: 200, height: 21)
        titleView.setImage(UIImage(named: "c_arrow_down"), for: .normal)
        titleView.setTitle(title, for: .normal)
        let width = (titleView.currentTitle ?? "").qs_width(UIFont.systemFont(ofSize: 17), height: 21)*1.3
        titleView.imageEdgeInsets = UIEdgeInsetsMake(0, width, 0, -width)
        titleView.setTitleColor(UIColor.black, for: .normal)
        titleView.addTarget(self, action: #selector(titleViewAction(btn:)), for: .touchUpInside)
        self.titleView = titleView
        self.navigationItem.titleView = self.titleView
        
    }
    
    @objc func titleViewAction(btn:UIButton){
        let filterVC = FilterThemeViewController()
        filterVC.clickAction =  { (index:Int,title:String,name:String) in
            var titleString = title
            let genders = ["male","female"]
            if name == "性别" {
                self.gender = genders[index]
                self.tag = ""
                titleString = "\(titleString)生小说"
            }else{
                self.gender = ""
                self.tag = title
            }
            self.titleView(title: titleString)
            self.requestDetail(index: self.selectedIndex, tag: self.tag, gender: self.gender)
        }
        self.navigationController?.pushViewController(filterVC, animated: true)
    }
    
    fileprivate func requestDetail(index:Int,tag:String,gender:String){
        var sorts:[String] = ["collectorCount","created","collectorCount"]
        var durations:[String] = ["last-seven-days","all","all"]
        //本周最热
//        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=last-seven-days&start=0
        
        //最新发布
//        http://api.zhuishushenqi.com/book-list?sort=created&duration=all&start=0
        
        //最多收藏 （全部书单）
//        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=all&start=0
        let urlString = "\(BASEURL)/book-list"
        let param = ["sort":sorts[index],"duration":durations[index],"start":"0","gender":gender,"tag":tag]
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            QSLog(response.json)
            do{
                if let books = response.json?.object(forKey: "bookLists") {
                    self.booksModel =  try XYCBaseModel.model(withModleClass: ThemeTopicModel.self, withJsArray:books as! [AnyObject]) as NSArray
                }
            }catch{
                
            }
            DispatchQueue.main.async {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        if selectedIndex == index {
            return
        }
        selectedIndex = index
        requestDetail(index: selectedIndex,tag: tag,gender: gender)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksModel?.count ?? 0 > 0 ? booksModel!.count:0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ThemeTopicCell? = tableView.qs_dequeueReusableCell(ThemeTopicCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = booksModel?.count ?? 0 > indexPath.row ? booksModel![indexPath.row] as? ThemeTopicModel:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookDetailVC = TopicDetailViewController()
        let book:ThemeTopicModel? = booksModel![indexPath.row] as? ThemeTopicModel
        bookDetailVC.id = book?._id ?? ""
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
