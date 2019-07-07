//
//  ZSMineViewController.swift
//  ZSMine
//
//  Created by caony on 2019/6/18.
//

import UIKit
import MJRefresh

class ZSMineViewController: BaseViewController, ZSMineNavigationBarDelegate {

    lazy var navigationBar:ZSMineNavigationBar = {
        let navigationBar = ZSMineNavigationBar(frame: .zero)
        navigationBar.loginState(state: .logout, title: nil, icon: nil)
        navigationBar.delegate = self
        return navigationBar
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSDetailButtonCell.self)
        tableView.qs_registerHeaderFooterClass(ZSMineHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var menus:[ZSMineMenuItem] = []
    
    var viewModel:ZSMineViewModel = ZSMineViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        navigationBar.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavgationBarHeight)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - kTabbarBlankHeight - FOOT_BAR_Height)
        }
        observe()
        setupMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
        navigationBar.loginState(state: ZSLogin.share.hasLogin() ? .login:.logout, title: ZSThirdLogin.share.userInfo?.user?.nickname, icon: ZSThirdLogin.share.userInfo?.user?.avatar)
        tableView.reloadData()
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }

    //MARK: - custom
    private func setupMenu() {
        let account = ZSMineMenuItem(type: .account, disclosureType: .controllerWithTitle,cellType: .roundedIndicator, isSwitchOn: false, title: "我的账户", icon: "personal_icon_account_24_24_24x24_", detailTitle: nil, disclosureText: "充值")
        let vip = ZSMineMenuItem(type: .vip, disclosureType: .controllerWithTitle,cellType: .roundedIndicator, isSwitchOn: false, title: "我的VIP", icon: "personal_icon_vip_24_24_24x24_", detailTitle: nil, disclosureText: "开通")
        let id = ZSMineMenuItem(type: .id, disclosureType: .controllerWithTitle,cellType: .text, isSwitchOn: false, title: "我的ID", icon: "personal_icon_id_24_24_24x24_", detailTitle: "开通VIP，免广告阅读", disclosureText: "点击复制")
        let level = ZSMineMenuItem(type: .level, disclosureType: .controllerWithTitle,cellType: .textIndicator, isSwitchOn: false, title: "经验等级", icon: "personal_icon_level _24_24_24x24_", detailTitle: nil, disclosureText: "\(ZSThirdLogin.share.userInfo?.user?.lv ?? 0)级")
        let message = ZSMineMenuItem(type: .message, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "我的消息", icon: "profile_personal_icon_message_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let history = ZSMineMenuItem(type: .history, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "阅读历史", icon: "personal_icon_history_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let booklist = ZSMineMenuItem(type: .booklist, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "书单", icon: "personal_icon_booklist_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let topic = ZSMineMenuItem(type: .topic, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "话题", icon: "personal_icon_level3 _24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let question = ZSMineMenuItem(type: .question, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "我的书荒提问", icon: "personal_icon_huntbook_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let comment = ZSMineMenuItem(type: .comment, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "给追书神器好评", icon: "personal_icon_zslike_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let feedback = ZSMineMenuItem(type: .feedback, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "意见反馈", icon: "personal_icon_opinion_24_24_24x24_", detailTitle: nil, disclosureText: nil)
        let darkmode = ZSMineMenuItem(type: .darkmode, disclosureType: .controllerWithTitle,cellType: .swtch, isSwitchOn: false, title: "夜间模式", icon: "personal_icon_darkmode_24_24_23x23_", detailTitle: nil, disclosureText: nil)
        let setting = ZSMineMenuItem(type: .setting, disclosureType: .controllerWithTitle,cellType: .indicator, isSwitchOn: false, title: "设置", icon: "personal_icon_setting_24_24_24x24_", detailTitle: nil, disclosureText: nil)

        menus.append(account)
        menus.append(vip)
        menus.append(id)
        menus.append(level)
        menus.append(message)
        menus.append(history)
        menus.append(booklist)
        menus.append(topic)
        menus.append(question)
        menus.append(comment)
        menus.append(feedback)
        menus.append(darkmode)
        menus.append(setting)
        
    }
    
    private func observe() {
        self.viewModel.reloadBlock = {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        viewModel.requestAccount()
    }
    
    //MARK: - ZSMineNavigationBarDelegate
    func navigationBar(navigationBar: ZSMineNavigationBar, didClickLogin: UIButton) {
        login { (result) in
            
        }
    }
    
    func navigationBar(navigationBar: ZSMineNavigationBar, didClickIcon: UIButton) {
        login { [weak self] (result) in
            if result {
                let userInfoVC = ZSUserInfoViewController()
                userInfoVC.hidesBottomBarWhenPushed = true
                self?.navigationController?.pushViewController(userInfoVC, animated: true)
            }
        }
    }
}

extension ZSMineViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if ZSLogin.share.hasLogin() {
            return 55
        }
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if ZSLogin.share.hasLogin() {
            let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSMineHeaderView.self)
            headerView?.configure(account: viewModel.account)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSDetailButtonCell.self)
        let item = menus[indexPath.row]
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = menus[indexPath.row]
        switch item.type {
        case .account:
            
            break
        case .setting:
            let settingVC = ZSSettingViewController()
            settingVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(settingVC, animated: true)
            break
        default:
            break
        }
    }
}
