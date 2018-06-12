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

class ZSForumViewController: BaseViewController,UITableViewDelegate {
    
    var titles:NSArray = [["title":"动态","image":"d_icon"],["title":"综合讨论区","image":"f_ramble_icon"],["title":"书评区[找书必看]","image":"forum_public_review_icon"],["title":"书荒互助区","image":"forum_public_help_icon"],["title":"女生区","image":"f_girl_icon"],["title":"浏览记录","image":"f_invent_icon"]]
    
    var tableView:UITableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.qs_registerCellClass(UITableViewCell.self)
        $0.rowHeight = 50
        $0.estimatedRowHeight = 50
        $0.estimatedSectionHeaderHeight = 0.01
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
        let items = Observable.just(titles.map { $0 })

        items.bind(to: tableView.rx.items(cellIdentifier: "UITableViewCell", cellType: UITableViewCell.self)) { (row,element,cell) in
            cell.selectionStyle = .none
            let name = (element as! NSDictionary)["image"] as? String ?? ""
            let title = (element as! NSDictionary)["title"] as? String
            cell.textLabel?.text = title
            cell.imageView?.image = UIImage(named:name)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.accessoryType = .disclosureIndicator
        }
        .disposed(by: disposeBag)
        
        tableView.rx.setDelegate(self).disposed(by: disposeBag)

        
    }
    
    func configureNavigateOnRowClick(){
        tableView.rx.itemSelected.bind { [unowned self] indexPath in
            self.tableView.deselectRow(at: indexPath, animated: true)
            if indexPath.row == 3{
                let lookVC = LookBookViewController()
                SideVC.navigationController?.pushViewController(lookVC, animated: true)
                
            }else
                if indexPath.row == 5 {
                    let historyVC = ReadHistoryViewController()
                    SideVC.navigationController?.pushViewController(historyVC, animated: true)
                }
                else{
                    let dynamicVC = DynamicViewController()
                    SideVC.navigationController?.pushViewController(dynamicVC, animated: true)
            }
        }
        .disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
}
