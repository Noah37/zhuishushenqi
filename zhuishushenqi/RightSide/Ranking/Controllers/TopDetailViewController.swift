//
//  TopDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import QSNetwork

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}


class TopDetailViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate{

    var id:String? = ""
    var selectedIndex = 0
    var model:QSRankModel?
    var books:NSArray? = []

    fileprivate var booksModel:NSArray? = []
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        requestDetail(idString: model?._id ?? "")
    }
    
    fileprivate func initSubview(){
        let segView = SegMenu(frame: CGRect(x: 0, y: 64, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["周榜","月榜","总榜"])
        segView.menuDelegate = self
        view.addSubview(segView)
        self.tableView.checkEmpty()

    }
    
    fileprivate func requestDetail(idString:String){
        let urlString = "\(BASEURL)/ranking/\(idString)"
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let json = response.json {
                if let books = (json.object(forKey: "ranking") as AnyObject).object(forKey: "books") {
                    do{
                        self.booksModel =  try XYCBaseModel.model(withModleClass: Book.self, withJsArray:books as! [AnyObject]) as NSArray
                    }catch{
                        
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.removeFromSuperview()
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
                self.tableView.checkEmpty()
            }
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        if selectedIndex == index {
            return
        }
        selectedIndex = index
        let ids:[String] = [model?._id ?? "1",model?.monthRank ?? "2",model?.totalRank ?? "3"]
        requestDetail(idString: ids[selectedIndex])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return booksModel?.count > 0 ? booksModel!.count:0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = booksModel?.count > indexPath.row ? booksModel![indexPath.row] as? Book:nil
        tableView.checkEmpty()
        return cell!
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
