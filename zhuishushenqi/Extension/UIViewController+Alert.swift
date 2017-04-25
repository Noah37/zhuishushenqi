//
//  UIAlertController+Alert.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

typealias AlertCallback = (_ action:UIAlertAction)->Void

extension UIViewController{
    
    func alert(with title:String?,message:String?,okTitle:String?,cancelTitle:String?,okAction:AlertCallback?,cancelAction:AlertCallback?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: okTitle, style: .default) { (alertAction) in
            if let action = okAction {
                action(alertAction)
            }
        }
        let cancel = UIAlertAction(title: cancelTitle, style: .default) { (alertAction) in
            if let action = cancelAction {
                action(alertAction)
            }
        }
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
}
