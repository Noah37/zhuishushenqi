//
//  ZSForumViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Then
import SnapKit

class ZSForumViewController: BaseViewController,UITableViewDelegate, UITableViewDataSource {
    
    var titles:[[String:String]] = [
        ["title":"动态","image":"d_icon"],
        ["title":"综合讨论区","image":"f_ramble_icon"],
        ["title":"书评区[找书必看]","image":"forum_public_review_icon"],
        ["title":"书荒互助区","image":"forum_public_help_icon"],
        ["title":"活动福利","image":"fuliv3"],
        ["title":"原创写作","image":"yuanchuangv3"],
        ["title":"女生区","image":"nvshengv3"],
        ["title":"电子竞技","image":"jinjiv3"],
        ["title":"二次元","image":"erciyuanv3"],
        ["title":"网文江湖","image":"wangwenv3"],
        ["title":"大话历史","image":"lishiv3"],
        ["title":"浏览记录","image":"f_invent_icon"],
        ["title":"导入本地书籍","image":"f_invent_icon"]]
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.qs_registerCellClass(ZSForumCell.self)
    }
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableDataSource()
        configureNavigateOnRowClick()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )

    }
    
    func configureTableDataSource(){
        view.addSubview(tableView)
        tableView.dataSource = self
//        let items = Observable.just(titles.map { $0 })
//
//        items.bind(to: tableView.rx.items(cellIdentifier: "ZSForumCell", cellType: ZSForumCell.self)) { (row,element,cell) in
//            cell.selectionStyle = .none
//            let name = (element as! NSDictionary)["image"] as? String ?? ""
//            let title = (element as! NSDictionary)["title"] as? String
//            cell.textLabel?.text = title
//            cell.imageView?.image = UIImage(named:name)
//            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
//            cell.accessoryType = .disclosureIndicator
//        }
//        .disposed(by: disposeBag)
        
//        tableView.rx.setDelegate(self).disposed(by: disposeBag)
        
        tableView.delegate = self
        
    }
    
    func configureNavigateOnRowClick(){
        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 1 {
                let discussVC = ZSDiscussViewController()
                discussVC.title = self.titles[indexPath.row]["title"]
                discussVC.block = "ramble"
                SideVC.navigationController?.pushViewController(discussVC, animated: true)

            } else if indexPath.row == 2 {
                let reviewVC = ZSBookReviewViewController()
                
                SideVC.navigationController?.pushViewController(reviewVC, animated: true)

            } else if indexPath.row == 3{
                let lookVC = LookBookViewController()
                SideVC.navigationController?.pushViewController(lookVC, animated: true)
                
            }else if indexPath.row == 4{
                let lookVC = ZSDiscussViewController()
                lookVC.block = "fuli"
                lookVC.title = self.titles[indexPath.row]["title"]

                SideVC.navigationController?.pushViewController(lookVC, animated: true)
                
            }else if indexPath.row == 5{
                let lookVC = ZSDiscussViewController()
                lookVC.block = "original"
                lookVC.title = self.titles[indexPath.row]["title"]

                SideVC.navigationController?.pushViewController(lookVC, animated: true)
            }
            else if indexPath.row == 6 {
                let femaleVC = ZSFemaleViewController()
                SideVC.navigationController?.pushViewController(femaleVC, animated: true)

            }else if indexPath.row == 7 {
                let femaleVC = ZSDiscussViewController()
                femaleVC.title = self.titles[indexPath.row]["title"]

                femaleVC.block = "yingxiong"
                SideVC.navigationController?.pushViewController(femaleVC, animated: true)
                
            }else if indexPath.row == 8 {
                let femaleVC = ZSDiscussViewController()
                femaleVC.title = self.titles[indexPath.row]["title"]

                femaleVC.block = "erciyuan"
                SideVC.navigationController?.pushViewController(femaleVC, animated: true)
                
            }else if indexPath.row == 9 {
                let femaleVC = ZSDiscussViewController()
                femaleVC.title = self.titles[indexPath.row]["title"]

                femaleVC.block = "wangwen"
                SideVC.navigationController?.pushViewController(femaleVC, animated: true)
                
            }else if indexPath.row == 10 {
                let femaleVC = ZSDiscussViewController()
                femaleVC.title = self.titles[indexPath.row]["title"]
                femaleVC.block = "dahua"
                SideVC.navigationController?.pushViewController(femaleVC, animated: true)
                
            }
            else if indexPath.row == 11 {
                    let historyVC = ReadHistoryViewController()
                    SideVC.navigationController?.pushViewController(historyVC, animated: true)
                } else if indexPath.row == 12 {
                    let importBookVC = ZSImportBookViewController()
                    SideVC.navigationController?.pushViewController(importBookVC, animated: true)
                }
                else{
                    let dynamicVC = DynamicViewController()
                    SideVC.navigationController?.pushViewController(dynamicVC, animated: true)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSForumCell.self) as ZSForumCell
        cell.selectionStyle = .none
        let element = titles[indexPath.row]
        let name = element["image"] ?? ""
        let title = element["title"]
        cell.textLabel?.text = title
        cell.imageView?.image = UIImage(named:name)
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

class ZSForumCell:UITableViewCell{
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.frame = CGRect(x: 20, y: 9, width: 30, height: 30)
        self.textLabel?.frame = CGRect(x: 65, y: 0, width: self.bounds.width - 65 - 38, height: 49.67)

        self.separatorInset = UIEdgeInsets(top: 0, left: 65, bottom: 0, right: 0)
    }
}
