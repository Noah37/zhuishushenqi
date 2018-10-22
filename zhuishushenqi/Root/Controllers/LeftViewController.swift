//
//  LeftViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,XYCActionSheetDelegate {

    var images:NSArray = ["hsm_default_avatar","hsm_icon_1","hsm_icon_2","hsm_icon_3"]
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.backgroundColor = UIColor.brown
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let iden = "CellIden"
        var cell = tableView.dequeueReusableCell(withIdentifier: iden)
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: iden)
            cell?.backgroundColor = UIColor ( red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0 )
            cell?.selectionStyle = .none
        }
        let scale = SideVC.leftOffSetXScale
        
        var headIcon:UIImageView? = cell?.contentView.viewWithTag(12321) as? UIImageView
        if (headIcon != nil) {
            headIcon?.removeFromSuperview()
        }
        headIcon = UIImageView(frame: CGRect(x: ScreenWidth*scale/2 - 12.5, y: 10, width: 25, height: 25))
        headIcon?.image = UIImage(named: images[indexPath.row] as! String)
        headIcon?.tag = 12321
        cell?.contentView.addSubview(headIcon!)
        if indexPath.row == 0 {
            if ZSLogin.share.hasLogin() {
                headIcon?.qs_setAvatarWithURLString(urlString: ZSThirdLogin.share.userInfo?.user?.avatar ?? "")
            }
            var label:UILabel? = cell?.contentView.viewWithTag(12323) as? UILabel
            if label != nil {
                label?.removeFromSuperview()
            }
            label = UILabel(frame: CGRect(x: ScreenWidth*scale/2 - 20,y: 35,width: 40,height: 10))
            label?.font = UIFont.systemFont(ofSize: 9)
            if ZSLogin.share.hasLogin() {
                label?.text = ZSThirdLogin.share.userInfo?.user?.nickname ?? ""
            } else {
                label?.text = "登录"
            }
            label?.textAlignment = .center
            label?.textColor = UIColor(white: 1.0, alpha: 0.5)
            cell?.contentView.addSubview(label!)
        }
        let view = UIView(frame: CGRect(x: 0,y: 0,width: 5,height: 44))
        view.backgroundColor =  UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        view.tag = 12306 + indexPath.row
        view.isHidden = true
        cell?.contentView.addSubview(view)
        if indexPath.row == 1 {
            view.isHidden = false
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for index in 0..<images.count {
            let selectedImage = view.viewWithTag(12306 + index)
            selectedImage?.isHidden = true
            if indexPath.row == index {
                selectedImage?.isHidden = false
            }
        }
        if indexPath.row == 0 {
            if ZSLogin.share.hasLogin() {
                let myVC = ZSMyViewController.init(style: .grouped)
                SideVC.closeSideViewController()
                SideVC.navigationController?.pushViewController(myVC, animated: true)
            } else {
//                showShare()
                let loginVC = ZSLoginViewController()
                SideVC.closeSideViewController()
                SideVC.navigationController?.pushViewController(loginVC, animated: false)
            }
        }else{
            SideVC.closeSideViewController()
        }
    }
    
    func showShare(){
        maskView.addSubview(shareActionSheet)
        KeyWindow?.addSubview(maskView)
        UIView.animate(withDuration: 0.35, animations: {
            self.shareActionSheet.frame = CGRect(x: 0, y: ScreenHeight - 200, width: ScreenWidth, height: 200)
        }, completion: { (finished) in
            
        }) 
    }
    
    func didSelectedAtIndex(_ index:Int,sheet:XYCActionSheet){
        SideVC.closeSideViewController()
        self.maskView.removeFromSuperview()
        self.tableView.reloadData()
//        let indexPath = IndexPath(row: 1, section: 0)
//        self.tableView.selectRow(at: indexPath, animated: true, scrollPosition: .middle)
        if index == 1 {
            ZSThirdLogin.share.successHandler = {
                self.tableView.reloadData()
            }
            ZSThirdLogin.share.QQAuth()
            self.shareActionSheet.removeFromSuperview()
        } else if index == 2 {
            ZSThirdLogin.share.successHandler = {
                self.tableView.reloadData()
            }
            ZSThirdLogin.share.WXAuth()
            self.shareActionSheet.removeFromSuperview()
        }
        if index == 3 {
            UIView.animate(withDuration: 0.35, animations: {
                sheet.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: 200)
            }, completion: { (finished) in
                self.maskView.removeFromSuperview()
                self.shareActionSheet.removeFromSuperview()
            }) 
        }
    }
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.backgroundColor  = UIColor(red: 0.211, green: 0.211, blue: 0.211, alpha: 1.00)
        return tableView
    }()
    
    fileprivate lazy var maskView:UIView = {
        let maskView = UIView()
        maskView.frame = self.view.bounds
        maskView.backgroundColor = UIColor(white: 0.00, alpha: 0.2)
        return maskView
    }()

    fileprivate lazy var shareActionSheet:XYCActionSheet = {
        let showActionSheet = XYCActionSheet(frame: CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: 200), titles: ["新浪微博账号登录","QQ账号登录","微信登录"])
        showActionSheet.delegate = self
        return showActionSheet
    }()
    
}
