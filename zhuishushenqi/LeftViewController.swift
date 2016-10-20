//
//  LeftViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 16/9/16.
//  Copyright © 2016年 CNY. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,XYCActionSheetDelegate {

    var images:NSArray = ["hsm_default_avatar","hsm_icon_1","hsm_icon_2","hsm_icon_3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = UIColor.brownColor()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCellWithIdentifier(iden)
        if cell == nil {
            cell = UITableViewCell(style: .Default, reuseIdentifier: iden)
            cell?.backgroundColor = UIColor ( red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0 )
            cell?.selectionStyle = .None
        }
        let scale = SideViewController.sharedInstance.leftOffSetXScale
        let headIcon = UIImageView(frame: CGRectMake(ScreenWidth*scale/2 - 12.5, 10, 25, 25))
        cell?.contentView.addSubview(headIcon)
        headIcon.image = UIImage(named: images[indexPath.row] as! String)
        if indexPath.row == 0 {
            let label = UILabel(frame: CGRectMake(ScreenWidth*scale/2 - 20,35,40,10))
            label.font = UIFont.systemFontOfSize(9)
            label.text = "登录"
            label.textAlignment = .Center
            label.textColor = UIColor(white: 1.0, alpha: 0.5)
            cell?.contentView.addSubview(label)
        }
        let view = UIView(frame: CGRectMake(0,0,5,44))
        view.backgroundColor =  UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        view.tag = 12306 + indexPath.row
        view.hidden = true
        cell?.contentView.addSubview(view)
        if indexPath.row == 1 {
            view.hidden = false
        }
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        for index in 0..<images.count {
            let selectedImage = view.viewWithTag(12306 + index)
            selectedImage?.hidden = true
            if indexPath.row == index {
                selectedImage?.hidden = false
            }
        }
        if indexPath.row == 0 {
            showShare()
        }else{
            SideViewController.sharedInstance.closeSideViewController()
        }
    }
    
    func showShare(){
        maskView.addSubview(shareActionSheet)
        KeyWindow?.addSubview(maskView)
        UIView.animateWithDuration(0.35, animations: {
            self.shareActionSheet.frame = CGRectMake(0, ScreenHeight - 200, ScreenWidth, 200)
        }) { (finished) in
            
        }
    }
    
    func didSelectedAtIndex(index:Int,sheet:XYCActionSheet){
        if index == 3 {
            UIView.animateWithDuration(0.35, animations: {
                sheet.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200)
            }) { (finished) in
                self.maskView.removeFromSuperview()
                self.shareActionSheet.removeFromSuperview()
            }
        }
    }
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRectMake(0, 0, ScreenWidth, ScreenHeight), style: .Grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .None
        tableView.backgroundColor  = UIColor(red: 0.211, green: 0.211, blue: 0.211, alpha: 1.00)
        return tableView
    }()
    
    private lazy var maskView:UIView = {
        let maskView = UIView()
        maskView.frame = self.view.bounds
        maskView.backgroundColor = UIColor(white: 0.00, alpha: 0.2)
        return maskView
    }()

    private lazy var shareActionSheet:XYCActionSheet = {
        let showActionSheet = XYCActionSheet(frame: CGRectMake(0, ScreenHeight, ScreenWidth, 200), titles: ["新浪微博账号登录","QQ账号登录","微信登录"])
        showActionSheet.delegate = self
        return showActionSheet
    }()
    
}
