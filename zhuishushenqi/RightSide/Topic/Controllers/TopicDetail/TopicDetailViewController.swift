//
//  TopicDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class TopicDetailViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{
    
    var id:String? = ""
    var books:NSArray? = []

    
    fileprivate var booksModel:NSArray? = []
    
    fileprivate var headerModel:TopicDetailHeader?
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopicDetailCell.self)
        tableView.qs_registerCellNib(TopicDetailHeaderCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "主题书单"
        requestDetail()
        self.automaticallyAdjustsScrollViewInsets = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

    }
    
    fileprivate func requestDetail(){
//        http://api.zhuishushenqi.com/book-list/58b782f5a7674a5f67618731
        let urlString = "\(BASEURL)/book-list/\(self.id ?? "")"
        //        QSNetwork.setDefaultURL(url: BASEURL)
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let bookList = response.json?.object(forKey: "bookList") as? [AnyHashable : Any] {
                self.headerModel = TopicDetailHeader.model(with: bookList)
            }
            if let books = (response.json?.object(forKey: "bookList") as AnyObject).object(forKey:"books") {
                if let models = [TopicDetailModel].deserialize(from: books as? [Any]) as NSArray? {
                    self.booksModel = models
                }
            }
            DispatchQueue.main.async {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let headermodel:TopicDetailHeader = self.headerModel {
            if indexPath.section == 0 {
                if headermodel.descHeight > 45 {
                    return headermodel.descHeight - 45 + 176
                }else{
                    return 176 - (45 - headermodel.descHeight)
                }
            }
        }
        if let model:TopicDetailModel = self.booksModel?[indexPath.section - 1] as? TopicDetailModel {
            if model.commentHeight > 32 {
                return model.commentHeight - 32 + 108
            }
        }
        
        return 108
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return booksModel?.count ?? 0 > 0 ? (booksModel!.count + 1):1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let headerCell:TopicDetailHeaderCell? = tableView.qs_dequeueReusableCell(TopicDetailHeaderCell.self)
            headerCell?.backgroundColor = UIColor.white
            headerCell?.selectionStyle = .none
            headerCell?.model = headerModel
            return headerCell!
        }
        let cell:TopicDetailCell? = tableView.qs_dequeueReusableCell(TopicDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = booksModel?.count ?? 0 > indexPath.section ? booksModel![indexPath.section - 1] as? TopicDetailModel:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section > 0 {
            let bookDetailVC = BookDetailViewController()
            let book:TopicDetailModel? = booksModel![indexPath.section - 1] as? TopicDetailModel
            bookDetailVC.id = book?.book._id ?? ""
            self.navigationController?.pushViewController(bookDetailVC, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
