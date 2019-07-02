//
//  ZSBookStoreViewController.swift
//  ZSBookStore
//
//  Created by caony on 2019/6/18.
//

import UIKit

class ZSBookStoreViewController: BaseViewController,ZSDiscoverNavigationBarDelegate {

    lazy var navgationBar:ZSDiscoverNavigationBar = {
        let nav = ZSDiscoverNavigationBar(frame: .zero)
        nav.delegate = self
        nav.searchButton.setImage(UIImage(named:"bookstore_def_classify_20_20_20x20_"), for: .normal)
        nav.searchButton.setTitle("分类", for: .normal)
        return nav
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(navgationBar)
        navgationBar.snp.remakeConstraints { (make) in
            make.left.top.right.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
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
        
    }

}
