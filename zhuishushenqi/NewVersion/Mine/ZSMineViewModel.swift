//
//  ZSMineViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSMineViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    
    var service:ZSMyService = ZSMyService()
    
    var account:ZSAccount?
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestAccount()
        }
    }
    
    func requestAccount() {
        requestAccount { [weak self] in
            self?.reloadBlock()
        }
    }

    func requestAccount(completion:@escaping()->Void) {
        service.fetchAccount(token: ZSLogin.share.token) { (account) in
            self.account = account
            completion()
        }
    }
}
