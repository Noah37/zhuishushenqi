//
//  ZSSettingViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/15.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSSettingViewModel: NSObject {

    var sections:[[String:Any]] = []
    
    let webService = ZSMyService()
    
    func fetchSetting(){
        
    }
    
    func fetchLogout(token:String, completion:@escaping ZSBaseCallback<[String:Any]>) {
        webService.fetchLogout(token: token) { (json) in
            completion(json)
        }
    }
}
