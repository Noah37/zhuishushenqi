//
//  ThemeTopicViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class ThemeTopicViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var id:String? = ""
    var books:NSArray? = []
    fileprivate let iden = "ThemeTopicCell"
    
    fileprivate var booksModel:NSArray? = []
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.register(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestDetail()
    }
    
    fileprivate func initSubview(){
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["本周最热","最新发布","最多收藏"])
        segView.menuDelegate = self
        view.addSubview(segView)
    }
    
    fileprivate func requestDetail(){
        //本周最热
//        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=last-seven-days&start=0
        
        //最新发布
//        http://api.zhuishushenqi.com/book-list?sort=created&duration=all&start=0
        
        //最多收藏 （全部书单）
//        http://api.zhuishushenqi.com/book-list?sort=collectorCount&duration=all&start=0
        
        let urlString = "\(baseUrl)/book-list"
        let param = ["sort":"collectorCount","duration":"last-seven-days","start":"0"]
        //        QSNetwork.setDefaultURL(url: baseUrl)
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            print(response.json ?? "")
            do{
                if let books = response.json?.object(forKey: "bookLists") {
                    self.booksModel =  try XYCBaseModel.model(withModleClass: ThemeTopicModel.self, withJsArray:books as! [AnyObject]) as NSArray
                }
            }catch{
                
            }
            DispatchQueue.main.sync {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
            //            http://api.zhuishushenqi.com/ranking/54d42d92321052167dfb75e3
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksModel?.count ?? 0 > 0 ? booksModel!.count:0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:ThemeTopicCell? = tableView.dequeueReusableCell(withIdentifier: iden,for: indexPath) as? ThemeTopicCell
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
