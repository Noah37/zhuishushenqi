//
//  ZSSettingViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/15.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSSettingViewController: BaseViewController {
    
    var tableView:UITableView!
    
    var menu:[ZSMineMenuItem] = []
    
    var viewModel:ZSSettingViewModel = ZSSettingViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMenu()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
        tableView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupMenu() {
        let source = ZSMineMenuItem(type: .account, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "书源设置", icon: "personal_icon_account_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let regularVerify = ZSMineMenuItem(type: .level, disclosureType: .controllerWithTitle,cellType: .none, isSwitchOn: false, title: "书源规则验证", icon: "personal_icon_account_24_24_24x24_", detailTitle: nil, disclosureText: nil)

        let exchangeToOld = ZSMineMenuItem(type: .vip, disclosureType: .controllerWithTitle,cellType: .none, isSwitchOn: false, title: "切换旧版", icon: "personal_icon_account_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        menu.append(source)
        menu.append(regularVerify)
        menu.append(exchangeToOld)
    }
    
    func setupSubviews(){
        title = "设置"
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.qs_registerCellClass(ZSDetailButtonCell.self)
        tableView.qs_registerHeaderFooterClass(ZSMyFooterView.self)
        view.addSubview(tableView)
    }
}

extension ZSSettingViewController:UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSDetailButtonCell.self)
        let item = menu[indexPath.row]
        cell?.type = item.cellType
        cell?.configure(title: item.title ?? "", icon: item.icon ?? "", detail: item.detailTitle, detailButtonText: item.disclosureText)
        cell?.detailHandler = {
            
        }
        cell?.detailTextHandler = {
            
        }
        cell?.switchHandler = { isOn in
            
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = tableView.qs_dequeueReusableHeaderFooterView(ZSMyFooterView.self)
        footer?.footerHandler = { [weak self] in
            self?.view.showProgress()
            self?.viewModel.fetchLogout(token: ZSLogin.share.token , completion: { [weak self] (json) in
                self?.hideProgress()
                if let ok = json?["ok"] as? Bool {
                    if ok {
                        ZSLogin.share.logout()
                        //退出登录成功,关闭菜单
                        self?.navigationController?.popViewController(animated: false)
                    } else {
                        self?.view.showTip(tip: "退出登录失败,请稍后再试")
                    }
                }
            })
        }
        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menu[indexPath.row]
        switch item.type {
        case .account:
            let addSourceVC = ZSSourcesViewController()
            addSourceVC.title = item.title
            self.navigationController?.pushViewController(addSourceVC, animated: true)
            break
        case .vip:
            showExchangeAlert()
            break
        case .level:
            let regVC = ZSRegularVerifyViewController()
            regVC.title = item.title
            self.navigationController?.pushViewController(regVC, animated: true)
            break
        default:
            break
        }
    }
    
    func showExchangeAlert() {
        // 新版本弹窗入口
       let alertVC = UIAlertController(title: "提示", message: "是否切换至旧版？", preferredStyle: UIAlertController.Style.alert)
       let okAction = UIAlertAction(title: "确定", style: UIAlertAction.Style.default) { (action) in
           let sideVC = SideViewController.shared
           sideVC.contentViewController = ZSRootViewController()
           sideVC.rightViewController = RightViewController()
           sideVC.leftViewController = LeftViewController()
           let sideNavVC = ZSBaseNavigationViewController(rootViewController: sideVC)
           let delegate = UIApplication.shared.delegate as! AppDelegate
           let tabVC = delegate.window!.rootViewController!
           delegate.lastTabVC = tabVC
           UIView.transition(from: tabVC.view, to: sideNavVC.view, duration: 1, options: UIView.AnimationOptions.transitionCrossDissolve, completion: { (finished) in
                if finished {
                    delegate.window?.rootViewController = sideNavVC
                    UserDefaults.standard.setValue(true, forKey: rootVCKey)
                }
           })
       }
       let cancelAction = UIAlertAction(title: "取消", style: UIAlertAction.Style.default) { (action) in
           
       }
       alertVC.addAction(okAction)
       alertVC.addAction(cancelAction)
       present(alertVC, animated: true, completion: nil)
    }
}
