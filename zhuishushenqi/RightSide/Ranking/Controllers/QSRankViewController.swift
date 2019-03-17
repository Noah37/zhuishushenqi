//
//  QSRankViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class QSRankViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {
    
    var viewModel = ZSRankViewModel()
    
    var tableView:UITableView!
    var ranks:[[QSRankModel]]?
    var show:[Bool] = [false,false]
    let kCellHeaderHeight:CGFloat = 60
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        // Do any additional setup after loading the view.
        title = "排行榜"
        initSubview()
        viewModel.fetchRanking { (_) in
            self.tableView.reloadData()
        }
    }
    
    fileprivate func initSubview(){
        tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = kCellHeaderHeight
        tableView.sectionFooterHeight = 0.001
        tableView.separatorInset = UIEdgeInsets(top: 0, left: kCellHeaderHeight, bottom: 0, right: 0)
        tableView.qs_registerCellClass(RankingViewCell.self)
        self.view.addSubview(self.tableView)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let models = viewModel.showRanks[section]
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.showRanks.count

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:RankingViewCell? = tableView.qs_dequeueReusableCell(RankingViewCell.self)
        cell?.imageView?.contentMode = .scaleAspectFill
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        
        let models = viewModel.showRanks[indexPath.section]
        cell?.model  = models[indexPath.row]
        cell?.accessoryImageView.isSelected = (indexPath.section == 0 ? viewModel.showMaleRank:viewModel.showFemaleRank)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 60))
        let label = UILabel(frame: CGRect(x: 15,y: 0,width: 100,height: 60))
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
        return kCellHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.clickRow(indexPath: indexPath) { (models) in
            if let _ = models {            
                self.tableView.reloadData()
            } else {
                let detailVC = ZSRankViewController()
                detailVC.rank = self.viewModel.showRanks[indexPath.section][indexPath.row]
                detailVC.title = detailVC.rank?.title
                self.navigationController?.pushViewController(detailVC, animated: true)
            }
        }
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
    
    func collapse(maleRank:[QSRankModel]?)->Int{
        var collapseIndex = 0
        if let models = maleRank {
            for model in models {
                if model.collapse == 1 {
                    break
                }
                collapseIndex += 1
            }
        }
        return collapseIndex
    }
}
