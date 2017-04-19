
//
//  FilterThemeViewController.swift
//  zhuishushenqi
//
//  Created by Nory Chao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

typealias ClickAction = (_ index:Int,_ title:String,_ name:String)->Void

class FilterThemeViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,FilterThemeCellDelegate {
    var data:NSArray?
    
    var clickAction:ClickAction?
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.white
        tableView.qs_registerCellClass(FilterThemeCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "筛选书单"
        // Do any additional setup after loading the view.
        requestDetail(index: 0)
    }
    
    fileprivate func requestDetail(index:Int){
//       http://api.zhuishushenqi.com/book-list/tagType
        let urlString = "\(BASEURL)/book-list/tagType"
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let books = response.json?.object(forKey: "data") as? NSArray {
                let mutAttay = NSMutableArray(array: books)
                mutAttay.insert(["name":"性别","tags":["男","女"]], at: 0)
                mutAttay.insert(["name":"all","tags":["全部书单"]], at: 0)
                self.data = mutAttay
            }
            DispatchQueue.main.async {
                
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.data?.count ?? 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:FilterThemeCell? = tableView.qs_dequeueReusableCell(FilterThemeCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.model = self.data![indexPath.section ] as? NSDictionary
        cell?.delegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return FilterThemeCell.cellHeight(cellModel: self.data![indexPath.section] as? NSDictionary)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func didSelectedTag(index:Int,title:String,name:String){
        if let click = self.clickAction {
            let popedVC = self.navigationController?.popViewController(animated: true)
            QSLog(popedVC)
            click(index,title,name)
        }
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
