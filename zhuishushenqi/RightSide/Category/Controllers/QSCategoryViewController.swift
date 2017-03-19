//
//  CategoryViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

//http://api.zhuishushenqi.com/cats/lv2/statistics
class QSCategoryViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate,CategoryCellItemDelegate{
    
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
    
    fileprivate func requestDetail(){
        let urlString = "\(baseUrl)/cats/lv2/statistics"
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
            DispatchQueue.main.sync {
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func didSelectAtIndex(_ index:Int){
        
    }
    
    //CategoryCellDelegate
    func didSelected(at:Int,cell:CategoryCell){
//        http://api.zhuishushenqi.com/book/by-categories?gender=male&type=new&major=都市&minor=&start=0&limit=50
        let genders = ["male","female"]
//        let types = ["new","hot","reputation","over"]
        let indexPath = tableView.indexPath(for: cell)
        let major = ((self.books?[indexPath?.section ?? 0] as? NSArray)?.object(at: at) as AnyObject).object(forKey: "name")
        let gender:String = genders[indexPath?.section ?? 0]
        
        let param = ["gender":gender,"type":"new","major":"\(major ?? "")","minor":"","start":"0","limit":"50"]
        let detailVC = CategoryDetailViewController()
        detailVC.param = param
        self.navigationController?.pushViewController(detailVC, animated: true)
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.books?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let types =  self.books?[indexPath.section] as? NSArray
        let count = ((types?.count ?? 0)%3 == 0 ? (types?.count ?? 0)/3:(types?.count ?? 0)/3 + 1)
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
        // Dispose of any resources that can be recreated.
    }
    
}
