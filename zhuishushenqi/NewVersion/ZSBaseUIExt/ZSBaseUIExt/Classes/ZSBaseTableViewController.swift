//
//  ZSBaseTableViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/6/7.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import ZSExtension
import ZSAppConfig

open class ZSBaseTableViewController: UITableViewController, IndicatableView {
    open func showActivityView() {
        
    }
    
    open func hideActivityView() {
        
    }
    
    open func showLoadingPageView() {
        
    }
    
    open func hideLoadingPageView() {
        
    }
    

    override open func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.tableView.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.red
        navigationController?.navigationBar.barTintColor = UIColor.white
        let backItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(popAction))
        self.navigationItem.backBarButtonItem = backItem
        register()
    }
    
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override open var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override open var prefersStatusBarHidden : Bool {
        return false
    }
    
    @objc func popAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    private func register(){
        let classes = registerCellClasses()
        for cls in classes {
            self.tableView.qs_registerCellClass(cls as! UITableViewCell.Type)
        }
        let nibClasses = registerCellNibs()
        for cls in nibClasses {
            self.tableView.qs_registerCellNib(cls as! UITableViewCell.Type)
        }
        
        let headerClasses = registerHeaderViewClasses()
        for cls in headerClasses {
            self.tableView.qs_registerHeaderFooterClass(cls as! UITableViewHeaderFooterView.Type)
        }
        let footerClasses = registerFooterViewClasses()
        for cls in footerClasses {
            self.tableView.qs_registerHeaderFooterClass(cls as! UITableViewHeaderFooterView.Type)
        }
    }
    
    open func registerHeaderViewClasses() -> Array<AnyClass> {
        return []
    }
    
    open func registerFooterViewClasses() -> Array<AnyClass> {
        return []
    }

    open func registerCellClasses() -> Array<AnyClass> {
        return []
    }
    
    open func registerCellNibs() -> Array<AnyClass> {
        return []
    }
    
    //MARK: - progress
    open func showProgress() {
        self.view.addSubview(self.indicatorView)
        self.view.bringSubviewToFront(self.indicatorView)
    }
    
    open func hideProgress() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeFromSuperview()
    }
    
    lazy open var indicatorView:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.frame = CGRect(x: ScreenWidth/2 - 50 , y: ScreenHeight/2 - 50, width: 100, height: 100)
        indicator.startAnimating()
        return indicator
    }()
}
