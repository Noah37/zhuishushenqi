//
//  ZSTabBarController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/6/18.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSTabBarController: UITabBarController,UITabBarControllerDelegate {

    var lastSelectedIndex:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        delegate = self
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    private func setupSubviews() {
        let homeItem = UITabBarItem(title: "书架", image: UIImage(named: "tab_bookshelf")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_bookshelf_sel")?.withRenderingMode(.alwaysOriginal))
        let channelItem = UITabBarItem(title: "书城", image: UIImage(named: "tab_bookstore")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_bookstore_sel")?.withRenderingMode(.alwaysOriginal))
        let dynamicItem = UITabBarItem(title: "社区", image: UIImage(named: "tab_bbs")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_bbs_sel")?.withRenderingMode(.alwaysOriginal))
        let vipItem = UITabBarItem(title: "发现", image: UIImage(named: "tab_discover")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_discover_sel")?.withRenderingMode(.alwaysOriginal))
        let mineItem = UITabBarItem(title: "我的", image: UIImage(named: "tab_profile")?.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab_profile_sel")?.withRenderingMode(.alwaysOriginal))
        
        let homeVC = ZSBookShelfViewController()
        let homeNav = UINavigationController(rootViewController: homeVC)
        homeNav.tabBarItem = homeItem
        
        let channelVC = ZSBookStoreViewController()
        let channelNav = UINavigationController(rootViewController: channelVC)
        channelNav.tabBarItem = channelItem
        
        let dynamicVC = ZSCommunityViewController()
        let dynamicNav = UINavigationController(rootViewController: dynamicVC)
        dynamicNav.tabBarItem = dynamicItem
        
        let vipVC = ZSDiscoverViewController()
        let vipNav = UINavigationController(rootViewController: vipVC)
        vipNav.tabBarItem = vipItem
        
        let mineVC = ZSMineViewController()
        let mineNav = UINavigationController(rootViewController: mineVC)
        mineNav.tabBarItem = mineItem
        
        viewControllers = [homeNav, channelNav, dynamicNav, vipNav, mineNav]
        for (_, item) in tabBar.items!.enumerated() {
            let normalAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1.0)]
            let selectedAttributes = [NSAttributedString.Key.foregroundColor:UIColor.init(hexString: "#A70B0B")]
            item.setTitleTextAttributes(normalAttributes, for: .normal)
            item.setTitleTextAttributes(selectedAttributes as [NSAttributedString.Key : Any], for: .selected)
        }
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let baseNav = viewController as? UINavigationController else {
            return
        }
        guard let _ = baseNav.topViewController as? BaseViewController else {
            return
        }
        
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        lastSelectedIndex = selectedIndex
        if let index = tabBar.items?.firstIndex(of: item) {
            guard let navController = viewControllers?[index] as? UINavigationController else {
                return
            }
            guard let _ = navController.topViewController as? BaseViewController else {
                return
            }
        }
    }

}
