//
//  RankingViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/19.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class RankingViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    private var tableView:UITableView?
    
    private var maleRank:NSArray? = []
    private var femaleRank:NSArray? = []
    private var maleImage:NSArray = ["zuire","zuire","zuire","zuire","zuire","zuire"]
    private var femaleImage:NSArray = ["zuire","zuire","zuire","zuire","zuire","zuire"]

    private var showMale:Bool = false
    private var showFemale:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        title = "排行榜"
        initSubview()
        requestData()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if self.navigationController?.navigationBarHidden == false{
            self.tableView!.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight)
        }
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    private func initSubview(){
        let tableView = UITableView(frame: CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64), style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        self.tableView = tableView
    }
    
    private func requestData(){
        let rank = RankingAPI()
        rank.startWithCompletionBlockWithHUD({ (request) in
            XYCLog("request:\(request)")
            self.maleRank = ((request as! NSDictionary).objectForKey("male") ?? []) as? NSArray
            self.femaleRank = ((request as! NSDictionary).objectForKey("female") ?? []) as? NSArray
            self.view.addSubview(self.tableView!)
            
        }) { (request) in
            
        }
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return (showMale ? maleRank!.count : 6)
        }else if section == 1{
            return (showFemale ? femaleRank!.count : 6)
        }
        return 0
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCellWithIdentifier(iden)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: iden)
            cell?.backgroundColor = UIColor.whiteColor()
            cell?.selectionStyle = .None
        }
        if indexPath.section == 0   {
            if !showMale {
                cell?.imageView?.image = UIImage(named: "zuire")
                cell?.imageView?.contentMode = .ScaleToFill
                
            }
            if maleRank?.count > indexPath.row {
                cell?.textLabel?.text = maleRank?[indexPath.row].objectForKey("title") as? String
            }
        }else if(indexPath.section == 1){
            if !showFemale {
                cell?.imageView?.image = UIImage(named:"zuire")
            }
            if femaleRank?.count > indexPath.row {
                cell?.textLabel?.text = femaleRank?[indexPath.row].objectForKey("title") as? String
            }

        }
        if indexPath.row == 5 {
            cell?.textLabel?.text = "别人家的排行榜"
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = UIView(frame: CGRectMake(0,0,ScreenWidth,60))
            let label = UILabel(frame: CGRectMake(15,15,100,15))
            label.textColor = UIColor.grayColor()
            label.font = UIFont.systemFontOfSize(11)
            label.text = "男生"
            headerView.addSubview(label)
            return headerView;
        }else if section == 1{
            let headerView = UIView(frame: CGRectMake(0,0,ScreenWidth,60))
            let label = UILabel(frame: CGRectMake(15,15,100,15))
            label.textColor = UIColor.grayColor()
            label.font = UIFont.systemFontOfSize(11)
            label.text = "女生"
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 5 {
                showMale = !showMale
            }else{
                let topVC = TopDetailViewController()
                topVC.id = maleRank![indexPath.row].objectForKey("_id") as? String
                topVC.title = maleRank?[indexPath.row].objectForKey("title") as? String
                self.navigationController?.pushViewController(topVC, animated: true)
            }
        }else{
            if indexPath.row == 5 {
                showFemale = !showFemale
            }else{
                let topVC = TopDetailViewController()
                topVC.id = femaleRank![indexPath.row].objectForKey("_id") as? String
                topVC.title = maleRank?[indexPath.row].objectForKey("title") as? String
                self.navigationController?.pushViewController(topVC, animated: true)
            }
        }
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .Default
    }
    
}
