//
//  UIAlertController+Alert.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit
import MBProgressHUD
import ZSAppConfig

typealias AlertCallback = (_ action:UIAlertAction)->Void

extension UIViewController{
    
    func alert(with title:String?,message:String?,okTitle:String?){
        self.alert(with: title, message: message, okTitle: okTitle, cancelTitle: nil, okAction: nil, cancelAction: nil)
    }
    
    func alert(with title:String?,message:String?,okTitle:String?,okAction:AlertCallback?){
        self.alert(with: title, message: message, okTitle: okTitle, cancelTitle: nil, okAction: okAction, cancelAction: nil)
    }
    
    func alert(with title:String?,message:String?,okTitle:String?,cancelTitle:String?,okAction:AlertCallback?,cancelAction:AlertCallback?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let title = okTitle {
            let ok = UIAlertAction(title: title, style: .default) { (alertAction) in
                if let action = okAction {
                    action(alertAction)
                }
            }
            alert.addAction(ok)
        }
        if let title = cancelTitle {
            let cancel = UIAlertAction(title: title, style: .default) { (alertAction) in
                if let action = cancelAction {
                    action(alertAction)
                }
            }
            alert.addAction(cancel)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func hudAddTo(view:UIView,text:String,animated:Bool){
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = .text
        hud.label.text = text
        hud.offset.y = ScreenHeight/4
        hud.hide(animated: animated, afterDelay: 3.0)
        
    }
    
    func hudAddedTo(view:UIView,text:String,timeInterVal:TimeInterval,animated:Bool){
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = MBProgressHUDMode.indeterminate
        hud.label.text = text
        hud.offset.y = ScreenHeight/4
        hud.hide(animated:animated, afterDelay:timeInterVal)
    }
    
    func pregressHUDTo(view:UIView,animated:Bool) ->Void {
        let hud = MBProgressHUD.showAdded(to: view, animated: animated)
        hud.mode = MBProgressHUDMode.indeterminate
    }
    

}
