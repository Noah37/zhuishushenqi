//
//  ZSUserAccountViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSUserAccountViewController: ZSBaseTableViewController {
    
    var viewModel:ZSMyViewModel = ZSMyViewModel()
    
    var cells = [
        ["header":"财产","section":[
            ["title":"追书币","detail":"","image":"a_zhuishubi_new","center":"","type":"btlabel","rightLabelTitle":"","rightTitle":"充值"],
            ["title":"追书券","detail":"","image":"a_zhuishuquan_new","center":"","type":"label","rightLabelTitle":""],
            ["title":"兑换追书券","detail":"","image":"a_exchange_new","center":"","type":"none"]
          ]],
         ["header":"记录","section":[
            ["title":"充值记录","detail":"","image":"a_charge_record_new","center":"","type":"none"],
            ["title":"消费记录","detail":"","image":"a_purchase_record_new","center":"","type":"none"]
          ]
        ],
         ["header":"","section":[
            ["title":"版本号","detail":"用户ID","image":"","center":"","type":"detail"]
            ]
        ]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        title = "个人账户"
        setupSubviews()
        viewModel.fetchAccount(token: ZSLogin.share.token) { (account) in
            if let acc = account {
                self.updateCells(acc: acc)
            }
        }
    }
    
    func updateCells(acc:ZSAccount) {
        let sectionOne = cells[0]
        let list = sectionOne["section"] as! [[String:String]]
        var zhuishubi = list[0]
        var zhuishuquan = list[1]
        let addquan = list[2]
        zhuishubi["rightLabelTitle"] = "余额: \(acc.balance)"
        zhuishuquan["rightLabelTitle"] = "\(acc.voucherCount)张"
        cells[0]["section"] = [zhuishubi,zhuishuquan,addquan]
        
        self.tableView.reloadData()
    }
    
    func setupSubviews() {
        
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSRLTMyCell.self,ZSRLMyCell.self,UITableViewCell.self]
    }
    
    override func registerHeaderViewClasses() -> Array<AnyClass> {
        return [ZSUserAccountHeaderView.self]
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sectionInfo = cells[section]["section"] as? [[String:String]] {
            return sectionInfo.count
        }
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sectionInfo = cells[indexPath.section]["section"] as! [[String:String]]
        let dict = sectionInfo[indexPath.row]
        let type = dict["type"] ?? ""
        let title = dict["title"] ?? ""
        let image = dict["image"] ?? ""
        if type == "btlabel" {
            let rightTitle = dict["rightLabelTitle"] ?? ""
            let rightBtTitle = dict["rightTitle"] ?? ""
            let cell = tableView.qs_dequeueReusableCell(ZSRLTMyCell.self)
            cell?.textLabel?.text = title
            cell?.imageView?.image = UIImage(named: image)
            cell?.rightTitle = rightBtTitle
            cell?.rightLabelTitle = rightTitle
            return cell!
        } else if type == "label" {
            let rightBtTitle = dict["rightLabelTitle"] ?? ""
            let cell = tableView.qs_dequeueReusableCell(ZSRLMyCell.self)
            cell?.textLabel?.text = title
            cell?.imageView?.image = UIImage(named: image)
            cell?.rightTitle = rightBtTitle
            cell?.accessoryType = .disclosureIndicator
            return cell!
        } else {
            let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
            cell?.textLabel?.text = title
            cell?.imageView?.image = UIImage(named: image)
            cell?.accessoryType = .disclosureIndicator
            return cell!
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let section = cells[section]
        let title = section["header"] as? String
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSUserAccountHeaderView.self)
        headerView?.titleLabel.text = title
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 0 {
            if indexPath.row == 1 {
                let sectionInfo = cells[indexPath.section]["section"] as! [[String:String]]
                let dict = sectionInfo[indexPath.row]
                let title = dict["title"] ?? ""
                let voucherVC = ZSVoucherParentViewController()
                voucherVC.title = title
                self.navigationController?.pushViewController(voucherVC, animated: true)
            }
        }
    }
}

class ZSUserAccountHeaderView: UITableViewHeaderFooterView {
    
    var titleLabel:UILabel!
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        titleLabel = UILabel(frame: CGRect(x: 20, y: 20, width: 200, height: 20))
        titleLabel.textColor = UIColor.gray
        titleLabel.font = UIFont.systemFont(ofSize: 11)
        addSubview(titleLabel)
    }
}
