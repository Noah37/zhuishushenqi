//
//  ZSBookShelfViewModel.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSBookShelfViewModel {
    
    var viewDidLoad: ()->() = {}
    var reloadBlock: ()->() = {}
    var shelfMsg:ZSShelfMessage?
    fileprivate let shelvesWebService = ZSShelfWebService()
    
    init() {
        viewDidLoad = { [weak self] in
            self?.requestMsg(completion: {
                self?.reloadBlock()
            })
        }
    }
    
    func requestMsg() {
        requestMsg { [weak self] in
            self?.reloadBlock()
        }
    }
    
    func requestMsg(completion: @escaping()->Void) {
        shelvesWebService.fetchShelfMsg { (message) in
            self.shelfMsg = message
            completion()
        }
    }
    
    

}
