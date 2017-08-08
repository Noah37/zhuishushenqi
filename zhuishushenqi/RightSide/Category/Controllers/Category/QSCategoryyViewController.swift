//
//  CategoryViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

//http://api.zhuishushenqi.com/cats/lv2/statistics
class QSCategoryyViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate,CategoryCellItemDelegate{
    
    var id:String? = ""
    var books:NSMutableArray? = NSMutableArray()
    
    fileprivate var male:NSArray? = []
    fileprivate var female:NSArray? = []
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 50
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(CategoryCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        title = "分类"
        requestDetail()
    }
    
    func requestDetail(){
        let urlString = "\(BASEURL)/cats/lv2/statistics"
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let books:NSArray = response.json?.object(forKey: "male") as? NSArray {
                self.male = books
                self.books?.add(self.male ?? books)
            }
            if let femaleTypes:NSArray = response.json?.object(forKey: "female") as? NSArray {
                self.female = femaleTypes
                self.books?.add(self.female ?? femaleTypes)
            }
            self.view.addSubview(self.tableView)
            self.tableView.reloadData()
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        
    }
    
    //CategoryCellDelegate
    func didSelected(at:Int,cell:CategoryCell){
        let genders = ["male","female"]
        let indexPath = tableView.indexPath(for: cell)
        let dict = self.books?[indexPath?.section ?? 0] as? [NSDictionary]
        let major = dict?[at]["name"]
        let gender:String = genders[indexPath?.section ?? 0]
        let param = ["gender":gender,"major":"\(major ?? "")"]
        self.navigationController?.pushViewController(QSCategoryDetailRouter.createModule(param: param), animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let types =  self.books?[indexPath.section] as? NSArray
        var count = 0
        if (types?.count ?? 0)%3 == 0 {
            count = (types?.count ?? 0)/3
        }else{
            count = (types?.count ?? 0)/3
        }
        
        let height = count * 60
        return CGFloat(height)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:CategoryCell? = tableView.qs_dequeueReusableCell(CategoryCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        cell!.models = self.books?.count ?? 0 > indexPath.section ? books![indexPath.section] as? NSArray:nil
        cell?.itemDelegate = self
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let sections = ["男生","女生"]
        let headerView = UIView()
        headerView.backgroundColor = UIColor.white
        let label = UILabel(frame: CGRect(x: 15, y: 0, width: 200, height: 50))
        label.text = sections[section]
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        headerView.addSubview(label)
        return headerView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
