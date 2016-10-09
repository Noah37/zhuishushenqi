//
//  TopDetailViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/10/4.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class TopDetailViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{

    var id:String? = ""
    var books:NSArray? = []
    private let iden = "TopDetailCell"

    private var booksModel:NSArray? = []
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 104, ScreenWidth, ScreenHeight - 104), style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.min
        tableView.sectionFooterHeight = CGFloat.min
        tableView.rowHeight = 93
        tableView.registerNib(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestDetail()
    }
    
    private func initSubview(){
        let segView = SegMenu(frame: CGRectMake(0, 64, UIScreen.mainScreen().bounds.size.width, 40), WithTitles: ["周榜","月榜","总榜"])
        segView.menuDelegate = self
        view.addSubview(segView)
    }
    
    private func requestDetail(){
        let rankDetail = RankingDetailAPI()
        rankDetail.id = id!
        rankDetail.startWithCompletionBlockWithHUD({ (request) in
            XYCLog(request)
            if let books:NSArray =  request.objectForKey("ranking")?.objectForKey("books") as? NSArray{
                do {
                    self.booksModel = try  XYCBaseModel.modelWithModleClass(Book.self, withJsArray: books as [AnyObject])
                    self.view.addSubview(self.tableView)
                    self.tableView.reloadData()
                }catch {
                    
                }
            }
            
        }) { (request) in
            
        }
    }
    
    func didSelectAtIndex(index:Int){
        
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksModel?.count > 0 ? booksModel!.count:0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.dequeueReusableCellWithIdentifier(iden,forIndexPath: indexPath) as? TopDetailCell
        cell?.backgroundColor = UIColor.whiteColor()
        cell?.selectionStyle = .None
        cell!.model = booksModel?.count > indexPath.row ? booksModel![indexPath.row] as? Book:nil
        return cell!
    }

    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let bookDetailVC = BookDetailViewController()
        let book:Book? = booksModel![indexPath.row] as? Book
        bookDetailVC.id = book?._id ?? ""
        self.navigationController?.pushViewController(bookDetailVC, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
