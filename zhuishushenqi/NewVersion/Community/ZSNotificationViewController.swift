//
//  ZSNotificationViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum NotificationType {
    case message
    case notification
}

class ZSNotificationViewController: BaseViewController,UITableViewDataSource, UITableViewDelegate {
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.separatorStyle = .none
        tableView.qs_registerCellClass(ZSNotificationCell.self)
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.qs_registerHeaderFooterClass(ZSNotificationHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    private lazy var cell:ZSNotificationCell = {
        let cell = ZSNotificationCell(style: .default, reuseIdentifier: "\(ZSNotificationCell.self)")
        return cell
    }()
    
    var viewModel:ZSNotificationViewModel = ZSNotificationViewModel()
    
    var type:NotificationType = .message

    override func viewDidLoad() {
        super.viewDidLoad()

        title = type == .message ? "我的消息":"通知"
        observe()
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavgationBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenHeight - kNavgationBarHeight)
        }
        if type == .message {
            self.viewModel.requestImportant()
            self.viewModel.postRead { (result) in
                
            }
        } else {
            self.viewModel.requestUnimportant()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func observe() {
        self.viewModel.reloadBlock = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    func jumpToDynamic(indexPath:IndexPath) {
        if let trigger = self.viewModel.notifications[indexPath.row].trigger {
            let dynamicVC = ZSUserDynamicViewController()
            dynamicVC.id = trigger._id
            dynamicVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(dynamicVC, animated: true)
        }
    }
    
    //MARK: - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return type == .message ? 2:1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if type == .message {
            if section == 0 {
                return 1
            }
        }
        return self.viewModel.notifications.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if type == .message {
            if indexPath.section == 0 {
                return 50
            }
        }
        let noti = self.viewModel.notifications[indexPath.row]
        return cell.heightFor(model: noti)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if type == .message {
            if section == 0 {
                return 0.01
            }
        }
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if type == .message {
            if section == 0{
                return nil
            }
        }
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSNotificationHeaderView.self)
        headerView?.titlelabel.text = "已读"
        headerView?.contentView.backgroundColor = UIColor.white
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if type == .message {
            if indexPath.section == 0 {
                let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
                cell?.selectionStyle = .none
                cell?.textLabel?.text = "通知"
                cell?.accessoryType = .disclosureIndicator
                cell?.imageView?.image = UIImage(named: "notification_personal_icon_message_24_24_24x24_")
                return cell!
            }
        }
        let cell = tableView.qs_dequeueReusableCell(ZSNotificationCell.self)
        cell?.selectionStyle = .none
        cell?.configure(model: self.viewModel.notifications[indexPath.row])
        cell?.iconHandler = { [weak self] in
            self?.jumpToDynamic(indexPath: indexPath)
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if type == .message {
            if indexPath.section == 0 {
                let notiVC = ZSNotificationViewController()
                notiVC.type = .notification
                navigationController?.pushViewController(notiVC, animated: true)
            }
        }
    }

}

class ZSNotificationHeaderView: UITableViewHeaderFooterView {
    
    lazy var titlelabel:UILabel = {
        let label = UILabel(frame: .zero)
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = UIColor.black
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        contentView.addSubview(titlelabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titlelabel.frame = CGRect(x: 15, y: 0, width: bounds.width - 30, height: bounds.height)
    }
}

