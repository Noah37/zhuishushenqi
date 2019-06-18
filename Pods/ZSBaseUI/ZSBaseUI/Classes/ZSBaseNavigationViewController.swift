//
//  ZSBaseNavigationViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/15.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

open class ZSBaseNavigationViewController: UINavigationController {

    override open func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupNavigationItem()
    }

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    open func setupNavigationItem(){
        let leftBar:UIBarButtonItem = UIBarButtonItem(title: "返回", style: UIBarButtonItem.Style.plain, target: self, action: #selector(popAction))
        self.navigationItem.leftBarButtonItem = leftBar
    }
    
    @objc func popAction(){
        self.popViewController(animated: true)
    }
    
    override open var shouldAutorotate: Bool {
        return self.topViewController?.shouldAutorotate ?? false
    }
    
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return topViewController?.supportedInterfaceOrientations ?? .all
    }
    
    override open var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation {
        return topViewController?.preferredInterfaceOrientationForPresentation ?? .portrait
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
