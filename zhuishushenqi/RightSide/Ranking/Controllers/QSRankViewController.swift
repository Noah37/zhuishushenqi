//
//  QSRankViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class QSRankViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,QSRankViewProtocol {
    
    var presenter: QSRankPresenterProtocol?
    
    var tableView:UITableView!
    var ranks:[[QSRankModel]]?
    var show:[Bool] = [false,false]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        title = "排行榜"
        initSubview()
        presenter?.viewDidLoad()
    }
    
    fileprivate func initSubview(){
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsetsMake(0, 44, 0, 0)
        tableView.qs_registerCellClass(RankingViewCell.self)
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return show[section] ? (ranks?[section].count ?? 0):6
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return ranks?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RankingViewCell? = tableView.qs_dequeueReusableCell(RankingViewCell.self)
        cell?.imageView?.contentMode = .scaleAspectFill
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        var rank:[QSRankModel]? = ranks?[indexPath.section]
        cell?.model = rank?[indexPath.row]
        cell?.accessoryImageView.isSelected = self.show[indexPath.section]
        cell?.accessoryClosure = {
            self.presenter?.didClickOpenBtn(indexPath:indexPath,show: self.show)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
        let label = UILabel(frame: CGRect(x: 15,y: 15,width: 100,height: 15))
        label.textColor = UIColor.gray
        label.font = UIFont.systemFont(ofSize: 11)
        if section == 0 {
            label.text = "男生"
        }else if section == 1{
            label.text = "女生"
        }
        headerView.addSubview(label)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectResultRow(indexPath: indexPath)
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    func showRanks(ranks:[[QSRankModel]]){
        self.ranks = ranks
        self.tableView.reloadData()
    }
    
    func showEmpty(){
        
    }
    
    func show(show:[Bool]){
        self.show = show
        self.tableView.reloadData()
    }
}
