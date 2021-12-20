//
//  ZSDiscoverViewController.swift
//  ZSDiscover
//
//  Created by caony on 2019/6/18.
//

import UIKit

enum ZSDiscover {
    case rank(time:TimeInterval,token:String,userId:String,packageName:String)
    case booklist(time:TimeInterval,token:String,userId:String,packageName:String)
    case vip(time:TimeInterval,token:String,packageName:String)
    case free(time:TimeInterval,token:String,packageName:String)
    case cartoon(time:TimeInterval,token:String,userId:String,packageName:String)
    case exclusiveList(time:TimeInterval,token:String,packageName:String)
    
    var url:String {
        switch self {
        case let .rank(time, token, userId, packageName):
            return "https://h5.zhuishushenqi.com/v2/ranking.html?timestamp=\(time)&platform=ios&gender=female&version=14&token=\(token)&userId=\(userId)&packageName=\(packageName)"
        case let .booklist(time, token, userId, packageName):
            return "https://h5.zhuishushenqi.com/v2/booklist.html?timestamp=\(time)&platform=ios&gender=female&version=14&token=\(token)&userId=\(userId)&packageName=\(packageName)"
        case let .vip(time, token, packageName):
            return "https://h5.zhuishushenqi.com/v2/vip3.html?posCode=B1&id=f3ac27f5c72542b897a8d9ad0632ab32&platform=ios&gender=female&timeInterval=\(time * 1000)&token=\(token)&timestamp=\(time)&version=14&packageName=\(packageName)"
        case let .free(time, token, packageName):
            return "https://h5.zhuishushenqi.com/v2/free.html?posCode=B1&id=a4c7b8b791044c9abc413c277dd0b2f3&platform=ios&gender=female&timeInterval=\(time * 1000)&token=\(token)&timestamp=\(time)&version=14&packageName=\(packageName)"
        case let .cartoon(time, token, userId, packageName):
            return "https://h5.zhuishushenqi.com/v2/cartoon.html?id=5a04005af958913a73b2ecdc&platform=ios&timestamp=\(time)&gender=female&version=14&token=\(token)&userId=\(userId)&packageName=\(packageName)"
        case let .exclusiveList(time, token, packageName):
            return "https://h5.zhuishushenqi.com/v2/exclusiveList.html?token=\(token)&timestamp=\(time)&gender=female&version=14&platform=ios&packageName=\(packageName)"
        default:
            return ""
        }
    }
}

class ZSDiscoverViewController: BaseViewController, ZSDiscoverNavigationBarDelegate, UITableViewDataSource, UITableViewDelegate {
    
    lazy var navgationBar:ZSDiscoverNavigationBar = {
        let nav = ZSDiscoverNavigationBar(frame: .zero)
        nav.delegate = self
        return nav
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
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.qs_registerHeaderFooterClass(ZSDiscoverHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var menus:[ZSDiscoverItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(navgationBar)
        view.addSubview(tableView)
        navgationBar.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavgationBarHeight)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - FOOT_BAR_Height)
        }
        setupMenus()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupMenus() {
        let vipItem = ZSDiscoverItem(type: .vip, title: "VIP专区", icon: "discover_icon_vip_26_26_26x26_")
        let freeItem = ZSDiscoverItem(type: .free, title: "免费专区", icon: "discover_icon_free_26_26_26x26_")
        let manhuaItem = ZSDiscoverItem(type: .manhua, title: "漫画专区", icon: "discover_icon_comics_26_26_26x26_")
        let audioItem = ZSDiscoverItem(type: .vip, title: "有声小说", icon: "discover_icon_audiobook_26_26_26x26_")
        let ramdomItem = ZSDiscoverItem(type: .vip, title: "随机看书", icon: "discover_icon_random_26_26_26x26_")
        let personalItem = ZSDiscoverItem(type: .personal, title: "专属定制", icon: "discover_icon_exclusive_26_26_26x26_")
        let huntItem = ZSDiscoverItem(type: .vip, title: "书荒互助", icon: "personal_icon_huntbook_24_24_24x24_")
        
        menus.append(vipItem)
        menus.append(freeItem)
        menus.append(manhuaItem)
        menus.append(audioItem)
        menus.append(ramdomItem)
        menus.append(personalItem)
        menus.append(huntItem)
    }
    
    func jumpTo(index:Int) {
        let timeInterval = Date().timeIntervalSince1970
        var url:String = ""
        var title:String = ""
        if index == 0 {
            let catelogVC = ZSCatelogViewController()
            catelogVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(catelogVC, animated: true)
            return
        } else if index == 1 {
            url = ZSDiscover.rank(time: timeInterval, token: ZSLogin.share.token, userId: ZSLogin.share.userInfo()?.user?._id ?? "", packageName: "com.ifmoc.ZhuiShuShenQi").url
            title = "排行"
        } else if index == 2 {
            url = ZSDiscover.booklist(time: timeInterval, token: ZSLogin.share.token, userId: ZSLogin.share.userInfo()?.user?._id ?? "", packageName: "com.ifmoc.ZhuiShuShenQi").url
            title = "书单"
        }
        jump(url: url, title: title)
    }
    
    func jump(url:String, title:String) {
        let webVC = ZSWebViewController()
        webVC.hidesBottomBarWhenPushed = true
        webVC.url = url
        webVC.title = title
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    //MARK: - ZSDiscoverNavigationBarDelegate
    func nav(nav: ZSDiscoverNavigationBar, didClickSearch: UIButton) {
        let searchVC = ZSSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(searchVC, animated: true)
    }
    
    //MARK - UITableViewDataSource, UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menus.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSDiscoverHeaderView.self)
        headerView?.handler = { [weak self] index in
            self?.jumpTo(index: index)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        let menuItem = menus[indexPath.row]
        cell?.imageView?.image = UIImage(named: "\(menuItem.icon ?? "")")
        cell?.textLabel?.text = "\(menuItem.title ?? "")"
        cell?.accessoryType = .disclosureIndicator
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let menuItem = menus[indexPath.row]
        switch menuItem.type {
        case .vip:
            let timeInterval = Date().timeIntervalSince1970
            let url = ZSDiscover.vip(time: timeInterval, token: ZSLogin.share.token, packageName: "com.ifmoc.ZhuiShuShenQi").url
            jump(url: url, title: menuItem.title ?? "")
            break
        case .free:
            let timeInterval = Date().timeIntervalSince1970
            let url = ZSDiscover.free(time: timeInterval, token: ZSLogin.share.token, packageName: "com.ifmoc.ZhuiShuShenQi").url
            jump(url: url, title: menuItem.title ?? "")
            break
        case .manhua:
            let timeInterval = Date().timeIntervalSince1970
            let url = ZSDiscover.cartoon(time: timeInterval, token: ZSLogin.share.token, userId: ZSLogin.share.userInfo()?.user?._id ?? "", packageName: "com.ifmoc.ZhuiShuShenQi").url
            jump(url: url, title: menuItem.title ?? "")
            break
        case .personal:
            let timeInterval = Date().timeIntervalSince1970
            let url = ZSDiscover.exclusiveList(time: timeInterval, token: ZSLogin.share.token, packageName: "com.ifmoc.ZhuiShuShenQi").url
            jump(url: url, title: menuItem.title ?? "")
            break
        default:
            break
        }
    }
}
