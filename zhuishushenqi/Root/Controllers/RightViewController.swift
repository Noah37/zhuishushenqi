//
//  RightViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class RightViewController: UITableViewController {

    var titles:[String]?
    
    var images:[String]?

    override init(style: UITableViewStyle) {
        super.init(style: style)
        let scale = SideVC.leftOffSetXScale
        self.tableView.frame = CGRect(x: ScreenWidth*scale + 20, y: 0, width: ScreenWidth*(1-scale) - 20, height: ScreenHeight)
        self.tableView.rowHeight = 60
        self.tableView.qs_registerCellClass(RightTableViewCell.self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        titles = ["搜索","排行榜","主题书单","分类","听书专区","随机看书"]
        images = ["rsm_icon_0","rsm_icon_3","rsm_icon_4","rsm_icon_5","rsm_icon_6","rsm_icon_7"]
        tableView.backgroundColor  = UIColor(red: 0.211, green: 0.211, blue: 0.211, alpha: 1.00)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        automaticallyAdjustsScrollViewInsets = false
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RightTableViewCell? = tableView.qs_dequeueReusableCell(RightTableViewCell.self)
        cell?.selectionStyle = .none
        
        cell?.backgroundColor = UIColor ( red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0 )
        cell?.imageView?.image = UIImage(named: images![indexPath.row])
        cell?.textLabel?.text = titles![indexPath.row]
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row == 0 {//搜索
//            let rankVC = QSSearchViewController()
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            SideVC.navigationController?.pushViewController(QSSearchRouter.createModule(), animated: true)
        }else if indexPath.row == 1 {//排行榜
//            let rankVC = RankingViewController()
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            SideVC.navigationController?.pushViewController(QSRankRouter.createModule(), animated: true)
        }else if indexPath.row == 2 {//主题书单
            _ = ThemeTopicViewController()
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            SideVC.navigationController?.pushViewController(QSThemeTopicRouter.createModule(), animated: true)

        }else if indexPath.row == 3 {
            self.navigationItem.backBarButtonItem?.tintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
            SideVC.navigationController?.pushViewController(QSCatalogRouter.createModule(), animated: true)
        }
    }
}


