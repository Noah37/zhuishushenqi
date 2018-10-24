//
//  ZSMyViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSMyViewController: ZSBaseTableViewController {
    
    let cells = [[],
                 [["title":"我的账户",
                  "image":"userCenter_account",
                  "rightB":"充值"],
                 ["title":"经验等级",
                  "image":"userCenter_experience",
                  "rightL":"1级"],
                 ["title":"激活兑换码",
                  "image":"userCenter_exchange",
                  ]],
                 [["title":"阅读历史",
                  "image":"userCenter_history",
                  ]
                  ],
                 [["title":"消息",
                   "image":"userCenter_msg",
                   ],
                  ["title":"书荒提问",
                   "image":"userCenter_rate",
                   ],
                  ["title":"话题",
                   "image":"userCenter_topic",
                   ],
                  ["title":"书单",
                   "image":"userCenter_bookList",
                   ]
                 ],
                 [["title":"给追书神器好评",
                   "image":"userCenter_comment",
                   "rightL":"+15经验"],
                  ["title":"微信公众号",
                   "image":"userCenter_wechat",
                   "rightL":"送书券"],
                  ["title":"设置",
                   "image":"userCenter_setting2",
                   ]
                 ]
                 ]
    let viewModel:ZSMyViewModel = ZSMyViewModel()
    
    var backHandler:ZSLoginVCBackHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "我"
        request()
    }
    
    func request() {
        self.view.showProgress()
        viewModel.fetchAccount(token: ZSLogin.share.token) { (account) in
            self.view.hideProgress()
            self.tableView.reloadData()
        }
        viewModel.fetchCoin(token: ZSLogin.share.token) { (coin) in
            self.view.hideProgress()
            self.tableView.reloadData()
        }
    }
    
    override func popAction() {
        backHandler?()
        super.popAction()
    }
    
    //MARK: -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionModel = cells[section]
        return sectionModel.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = cells[indexPath.section][indexPath.row]
        if let right = model["rightB"] {
            let cell = tableView.qs_dequeueReusableCell(ZSRTMyCell.self)
            cell?.rightTitle = right
            cell?.textLabel?.text = model["title"]
            cell?.imageView?.image = UIImage(named: model["image"] ?? "")
            return cell!
        } else if let right = model["rightL"] {
            let cell = tableView.qs_dequeueReusableCell(ZSRLMyCell.self)
            cell?.rightTitle = right
            cell?.textLabel?.text = model["title"]
            cell?.imageView?.image = UIImage(named: model["image"] ?? "")
            return cell!
        } else {
            let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
            cell?.textLabel?.text = model["title"]
            cell?.imageView?.image = UIImage(named: model["image"] ?? "")
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let header = tableView.qs_dequeueReusableHeaderFooterView(ZSMyHeaderView.self)
            header?.userInfo = ZSThirdLogin.share.userInfo
            header?.account = viewModel.account
            header?.coin = viewModel.coin
            header?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 260)
            header?.handler = {
                let userInfoVC = ZSUserInfoViewController.init(style: .grouped)
                self.navigationController?.pushViewController(userInfoVC, animated: true)
            }
            return header
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if section == cells.count - 1 {
            let footer = tableView.qs_dequeueReusableHeaderFooterView(ZSMyFooterView.self)
            footer?.footerHandler = {
                self.view.showProgress()
                self.viewModel.fetchLogout(token: ZSLogin.share.token , completion: { (json) in
                    self.hideProgress()
                    if let ok = json?["ok"] as? Bool {
                        if ok {
                            ZSLogin.share.logout()
                            //退出登录成功,关闭菜单
                            self.navigationController?.popViewController(animated: false)
                            SideVC.closeSideViewController()
                        } else {
                            self.view.showTip(tip: "退出登录失败,请稍后再试")
                        }
                    }
                })
            }
            return footer
        }
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 260
        }
        return 0.01
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 0 {
            return 50
        } else if section == cells.count - 1 {
            return 100
        }
        return 20
    }
    
    //MARK: -
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSRLMyCell.self,ZSRTMyCell.self,UITableViewCell.self]
    }
    
    override func registerHeaderViewClasses() -> Array<AnyClass> {
        return [ZSMyHeaderView.self,ZSMyFooterView.self]
    }

}

typealias ZSMyFooterHandler = ()->Void

class ZSMyFooterView: UITableViewHeaderFooterView {
    
    var button:UIButton!
    
    var footerHandler:ZSMyFooterHandler?
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        button = UIButton(type: .custom)
        button.setTitle("退出登录", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor.red
        button.frame = CGRect(x: 20, y: 25, width: self.bounds.width - 40, height: 50)
        button.addTarget(self, action: #selector(footerAction(btn:)), for: .touchUpInside)
        self.addSubview(button)
    }
    
    @objc
    func footerAction(btn:UIButton) {
        footerHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        button.frame = CGRect(x: 20, y: 25, width: self.bounds.width - 40, height: 50)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
