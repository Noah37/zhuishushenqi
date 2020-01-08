//
//  BaseViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/20.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

typealias ZSBaseHandler = (_ result:Bool)->Void

class BaseViewController: UIViewController, IndicatableView {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false
        self.view.backgroundColor = UIColor.white
        self.view.backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        navigationController?.navigationBar.tintColor = UIColor.red
        navigationController?.navigationBar.barTintColor = UIColor.white
        let backItem = UIBarButtonItem(title: "返回", style: .plain, target: self, action: #selector(popAction))
        self.navigationItem.backBarButtonItem = backItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        navigationController?.isNavigationBarHidden = false
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }
    
    override var prefersStatusBarHidden : Bool {
        return false
    }

    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .all
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return .portrait
    }
    
    override var shouldAutorotate: Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func popAction(){
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - progress
    func showProgress() {
        self.indicatorView.center = self.view.center
        self.view.addSubview(self.indicatorView)
        self.view.bringSubviewToFront(self.indicatorView)
    }
    
    func hideProgress() {
        self.indicatorView.stopAnimating()
        self.indicatorView.removeFromSuperview()
    }
    
    func login(success:@escaping ZSBaseHandler) {
        if ZSLogin.share.hasLogin() {
            success(true)
            return
        }
        let loginVC = ZSLoginViewController()
        loginVC.loginResultHandler = { result in
            success(result)
        }
        present(loginVC, animated: true, completion: nil)
    }
    
    lazy var indicatorView:UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .gray)
        indicator.frame = CGRect(x: ScreenWidth/2 - 50 , y: ScreenHeight/2 - 50, width: 100, height: 100)
        indicator.startAnimating()
        return indicator
    }()
}
