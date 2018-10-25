//
//  ZSUserInfoViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/20.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSUserInfoViewController: ZSBaseTableViewController {
    
    var cells = [[["title":"头像","detail":"","image":"","center":"","type":"custom"],
                  ["title":"昵称","detail":"","image":"","center":"","type":"label"],
                  ["title":"性别","detail":"","image":"","center":"","type":"label"],
                  ["title":"用户ID","detail":"复制","image":"","center":"","type":"all"]],
                 [["title":"手机号","detail":"","image":"","center":"","type":"bind"],
                  ["title":"QQ","detail":"","image":"","center":"","type":"bind"],
                  ["title":"微信","detail":"","image":"","center":"","type":"bind"],
                  ["title":"微博","detail":"","image":"","center":"","type":"bind"]
                ]]
    
    
    lazy var iconView:UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 20
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    var viewModel:ZSMyViewModel = ZSMyViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.rowHeight = 50
        title = "个人信息"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        request()
    }
    
    func request() {
        view.showProgress()
        viewModel.fetchDetail(token: ZSLogin.share.token) { (detail) in
            self.view.hideProgress()
            self.updateUserInfo()
            self.tableView.reloadData()
        }
        viewModel.fetchUserBind(token: ZSLogin.share.token) { (bind) in
            self.view.hideProgress()
            self.updateBind()
            self.tableView.reloadData()
        }
    }
    
    func updateUserInfo() {
        cells[0][0]["image"] = viewModel.detail?.avatar ?? ""
        cells[0][1]["detail"] = viewModel.detail?.nickname ?? ""
        cells[0][2]["detail"] = genderHZ(gender: viewModel.detail?.gender ?? "")
        cells[0][3]["center"] = viewModel.detail?._id ?? ""
    }
    
    func updateBind() {
        if let bind = viewModel.bind {
            let mobile = bind.bind?.Mobile
            if mobile?.name != ""  {
                cells[1][0]["detail"] = "已绑定"
                cells[1][0]["center"] = mobile?.name ?? ""
            }
            let qq = bind.bind?.QQ
            if qq?.name != "" {
                cells[1][1]["detail"] = "已绑定"
                cells[1][1]["center"] = qq?.name ?? ""
            }
            let wx = bind.bind?.Weixin
            if wx?.name != "" {
                cells[1][2]["detail"] = "已绑定"
                cells[1][2]["center"] = wx?.name ?? ""
            }
            let wb = bind.bind?.SinaWeibo
            if wb?.name != ""  {
                cells[1][3]["detail"] = "已绑定"
                cells[1][3]["center"] = wb?.name ?? ""
            }
        }
    }
    
    func genderHZ(gender:String) -> String {
        var name = ""
        if gender == "female" {
            name = "女"
        } else if gender == "male" {
            name = "男"
        }
        return name
     }
    
    //MARK: -
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dict = cells[indexPath.section][indexPath.row]
        if let type = dict["type"] {
            if type == "custom" {
                let cell = tableView.qs_dequeueReusableCell(ZSRLMyCell.self)
                cell?.customView = self.iconView
                cell?.textLabel?.text = dict["title"]
                let image = dict["image"] ?? ""
                self.iconView.qs_setAvatarWithURLString(urlString: image)
                return cell!
            } else if type == "label" {
                let cell = tableView.qs_dequeueReusableCell(ZSRLMyCell.self)
                cell?.textLabel?.text = dict["title"]
                let right = dict["detail"] ?? ""
                cell?.rightTitle = right
                return cell!
            } else if type == "all" {
                let cell = tableView.qs_dequeueReusableCell(ZSUserBindCell.self)
                cell?.textLabel?.text = dict["title"]
                let center = dict["center"] ?? ""
                cell?.rightLabel.text = center
                cell?.rightButton.setTitle("复制", for: .normal)
                cell?.buttonHandler = { selected in
                    UIPasteboard.general.string = center
                    self.view.showTip(tip: "用户ID已复制到您的剪切板")
                }
                return cell!
            } else if type == "bind" {
                let cell = tableView.qs_dequeueReusableCell(ZSUserBindCell.self)
                let detail = dict["detail"]
                if detail != "" {
                    cell?.rightButton.isEnabled = false
                    cell?.rightButton.setTitle(detail, for: .normal)
                    cell?.rightLabel.text = dict["center"]
                }
                cell?.textLabel?.text = dict["title"]
                return cell!
            }
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let dict = cells[indexPath.section][indexPath.row]
                let nicknameVC = ZSModifyNicknameViewController()
                nicknameVC.title = "修改昵称"
                nicknameVC.nickname = dict["detail"] ?? ""
                self.navigationController?.pushViewController(nicknameVC, animated: true)
            }
        }
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSUserBindCell.self,ZSRLMyCell.self,ZSRTMyCell.self]
    }

}
