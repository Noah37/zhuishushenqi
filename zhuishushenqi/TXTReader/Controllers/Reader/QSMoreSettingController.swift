//
//  QSMoreSettingController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/2/8.
//  Copyright © 2018年 QS. All rights reserved.
//

typealias QSMoreSettingCallbackAction = (_ obj:Int)->Void

import UIKit

class QSMoreSettingController: UIViewController {

    private let settings = [["title":"翻页方式","list":["拟真","简洁","滑动"],"tip":"选择要使用的翻页方式"],
                            ["title":"简繁转换","list":["简体","繁体"],"tip":"选择使用简体或繁体"],
                            ["title":"字体设置","list":["默认","兰亭黑","楷体","魏碑","雅痞","翩翩体","隶书","日文字体"]],
                            ["title":"自动购买","switch":"off"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.addSubview(self.tableView)
        setupNavigationItem()
        automaticallyAdjustsScrollViewInsets = false
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame =  CGRect(x: 0, y: kNavgationBarHeight, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight)
    }
    
    private func setupNavigationItem(){
        self.title = "更多设置"
        let leftItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(dismissVC))
        navigationItem.leftBarButtonItem = leftItem
    }
    
    @objc private func dismissVC(){
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame:  CGRect(x: 0, y: 0, width: 0, height: 0), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.qs_registerCellClass(QSMoreSettingCell.self)
        tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        return tableView
    }()
}

extension QSMoreSettingController:UITableViewDataSource,UITableViewDelegate{
    func addSwitch() -> UIControl{
        let autoSwitch = UISwitch()
        autoSwitch.onTintColor = UIColor.red
        autoSwitch.isOn = false
        return autoSwitch
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(QSMoreSettingCell.self)
        let title = settings[indexPath.row]["title"] as? String
        cell?.textLabel?.text = title
        cell?.accessoryType = .disclosureIndicator
        if indexPath.row == settings.count - 1 {
            cell?.accessoryType = .none
        }
        let autoSwitch = settings[indexPath.row]["switch"]
        if let _ = autoSwitch {
            let switchView = addSwitch()
            switchView.center = CGPoint(x: ScreenWidth - 34, y: 22)
            cell?.contentView.addSubview(switchView)
        }
        let detail = [QSReaderSetting.shared.pageStyle.rawValue,
                      QSReaderSetting.shared.chineseFontStyle.rawValue,
                      QSReaderSetting.shared.fontStyle.rawValue]
        let list = settings[indexPath.row]["list"] as? [String]
        if indexPath.row < detail.count {
            cell?.detailTextLabel?.text = list?[detail[indexPath.row]]
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.row < settings.count - 1 {
            let list = settings[indexPath.row]["list"] as? [String]
            let tip = settings[indexPath.row]["tip"] as? String
            if let ttip = tip,let llist = list {
                actionSheet(title: ttip, message: "", list: llist, callback: { (obj) in
                    QSLog("点击了第\(obj)个")
                    if (indexPath.row == 0) {
                        QSReaderSetting.shared.pageStyle = QSReaderPageStyle(rawValue: obj) ?? .curlPage
                    } else if indexPath.row == 1 {
                        QSReaderSetting.shared.chineseFontStyle = QSReaderChineseFontStyle(rawValue: obj) ?? .simpleChinese
                    } else if indexPath.row == 2 {
                        QSReaderSetting.shared.fontStyle = QSReaderFontStyle(rawValue: obj) ?? .system
                    }
                    tableView.reloadRow(at: indexPath, with: .automatic)
                })
            }
        }
    }
    
    //MARK: - ActionSheet
    func actionSheet(title:String,message:String,list:[String],callback: QSMoreSettingCallbackAction?){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        var index = 0
        for li in list {
            let callbackIndex = index
            let action = UIAlertAction(title: li, style: .default, handler: { (action) in
                if let handler = callback {
                    handler(callbackIndex)
                }
            })
            alertController.addAction(action)
            index += 1
        }
        let action = UIAlertAction(title: "取消", style: .cancel, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

//fileprivate extension UITableViewCell {
//    convenience init(style: UITableViewCellStyle, reuseIdentifier: String?) {
//        self.init(style: .value1, reuseIdentifier: reuseIdentifier)
//    }
//}

@objcMembers
class QSMoreSettingCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
