//
//  ChangeSourceViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/16.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

typealias SelectAction = (_ index:Int)->Void

class ChangeSourceViewController: BaseViewController ,UITableViewDataSource,UITableViewDelegate{

    var sources:[ResourceModel]?
    let iden = "ChangeSourceCell"
    var id:String = ""
    var selectedIndex:Int = 1
    var selectAction:SelectAction?
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = 80
        tableView.register(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "选择来源"
        self.automaticallyAdjustsScrollViewInsets = false
        
        let rightBtn = UIButton(type: .custom)
        rightBtn.addTarget(self, action: #selector(close(btn:)), for: .touchUpInside)
        rightBtn.setImage(UIImage(named:"actionbar_close"), for: .normal)
        rightBtn.frame = CGRect(x: self.view.bounds.width - 45, y: 7, width: 30, height: 30)
        let rightBar = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightBar

        
        view.addSubview(self.tableView)
        requestData(id: self.id)
    }
    
    func close(btn:UIButton){
        dismiss(animated: true, completion: nil)
    }
    
    func requestData(id:String){
//        http://api.zhuishushenqi.com/toc?view=summary&book=57e0dac5de88e4e83c6c5297
        let urlString = "\(baseUrl)/toc"
        let param = ["view":"summary","book":"\(self.id)"]
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: param, headers: nil) { (response) in
            print(response.json ?? "No Data")
            if let resources = response.json  {
                do{
                    self.sources = try XYCBaseModel.model(withModleClass: ResourceModel.self, withJsArray: resources as! [Any]) as? [ResourceModel]
                }catch{
                    print(error)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 {
            return sources?.count ?? 0
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell:ChangeSourceCell? = tableView.dequeueReusableCell(withIdentifier: self.iden, for: indexPath) as? ChangeSourceCell
            if indexPath.row == self.selectedIndex {
                cell?.isCurrentSelected = true
            }
            cell?.model = sources?[indexPath.row]
            return cell!
        }else{
            let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Cell")
            cell.textLabel?.text = "自动选择"
            cell.accessoryType = .disclosureIndicator
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let headerView = UIView()
            let headerLabel = UILabel()
            headerLabel.frame = CGRect(x: 15, y: 30, width: self.view.bounds.width - 30, height: 30)
            headerLabel.text = "共搜索到\(self.sources?.count ?? 0)个网站"
            headerLabel.textColor = UIColor.darkGray
            headerLabel.font = UIFont.systemFont(ofSize: 13)
            headerView.addSubview(headerLabel)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let action = selectAction {
            action(indexPath.row)
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
