//
//  LeftViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class LeftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,XYCActionSheetDelegate {

    var images = ["hsm_default_avatar","hsm_icon_1","hsm_icon_2","hsm_icon_3"]
    
    var selectedIndex = 1
    
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
        let cell = tableView.qs_dequeueReusableCell(ZSLeftViewCell.self)
        cell?.backgroundColor = UIColor ( red: 0.16, green: 0.16, blue: 0.16, alpha: 1.0 )
        cell?.selectionStyle = .none
        if indexPath.row == 0 {
            if ZSLogin.share.hasLogin() {
                cell?.iconView.qs_setAvatarWithURLString(urlString: ZSThirdLogin.share.userInfo?.user?.avatar ?? "")
                cell?.nameLabel.text = ZSThirdLogin.share.userInfo?.user?.nickname ?? ""
            } else {
                cell?.iconView.image =  UIImage(named: images[indexPath.row])
                cell?.nameLabel.text = "登录"
            }
        } else {
            cell?.iconView.image =  UIImage(named: images[indexPath.row])
            cell?.nameLabel.text = ""
        }
        if indexPath.row == selectedIndex {
            cell?.selectedView.isHidden = false
        } else {
            cell?.selectedView.isHidden = true
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        if indexPath.row == 0 {
            if ZSLogin.share.hasLogin() {
                let myVC = ZSMyViewController.init(style: .grouped)
                myVC.backHandler = {
                    self.selectedIndex = 1
                    self.tableView.reloadData()
                }
                SideVC.closeSideViewController()
                SideVC.navigationController?.pushViewController(myVC, animated: true)
            } else {
                let loginVC = ZSLoginViewController()
                loginVC.backHandler = {
                    self.selectedIndex = 1
                    self.tableView.reloadData()
                }
                loginVC.loginResultHandler = { success in
                    NotificationCenter.qs_postNotification(name: LoginSuccess, obj: nil)
                }
                SideVC.closeSideViewController()
                SideVC.present(loginVC, animated: true, completion: nil)
            }
        }else{
            SideVC.closeSideViewController()
        }
        self.tableView.reloadData()
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
        tableView.qs_registerCellClass(ZSLeftViewCell.self)
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
