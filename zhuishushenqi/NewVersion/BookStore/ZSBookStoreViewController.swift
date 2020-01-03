//
//  ZSBookStoreViewController.swift
//  ZSBookStore
//
//  Created by caony on 2019/6/18.
//

import UIKit

class ZSBookStoreViewController: BaseViewController,ZSDiscoverNavigationBarDelegate, ZSWebViewControllerDelegate {

    lazy var navgationBar:ZSDiscoverNavigationBar = {
        let nav = ZSDiscoverNavigationBar(frame: .zero)
        nav.delegate = self
        nav.searchButton.setImage(UIImage(named:"bookstore_def_classify_20_20_20x20_"), for: .normal)
        nav.searchButton.setTitle("分类", for: .normal)
        nav.titleLabel.text = "书城"
        return nav
    }()
    
    var webViewController:ZSWebViewController = ZSWebViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let timeInterval = Date().timeIntervalSince1970
        webViewController.url = "https://h5.zhuishushenqi.com/v2/index3.html?id=e5fe6058afa449e4a8b9b3fb843c2bcd&posCode=B1&timestamp=\(timeInterval)&gender=male&version=14&platform=ios&packageName=com.ifmoc.ZhuiShuShenQi"
        webViewController.delegate = self
        view.addSubview(self.navgationBar)
        view.addSubview(self.webViewController.view)
//        addChild(self.webViewController)
        navgationBar.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        webViewController.view.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navgationBar.snp.bottom)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - FOOT_BAR_Height - kTabbarBlankHeight)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - ZSDiscoverNavigationBarDelegate
    func nav(nav: ZSDiscoverNavigationBar, didClickSearch: UIButton) {
        let catelogVC = ZSCatelogViewController()
        catelogVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(catelogVC, animated: true)
    }

}
