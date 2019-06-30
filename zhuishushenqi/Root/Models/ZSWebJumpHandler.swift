//
//  ZSWebJumpHandler.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSWebEventHandlerProtocol {
    static func canHandleWebItem(item:ZSWebItem) ->Bool
    func handleWebItem(item:ZSWebItem, context:ZSWebContext, block:(_ result:String)->Void)
}

class ZSWebJumpHandler: ZSWebEventHandlerProtocol {
    func handleWebItem(item: ZSWebItem, context: ZSWebContext, block: (String) -> Void) {
        
    }
    
    
    static func canHandleWebItem(item:ZSWebItem) ->Bool {
        
        
        return true
    }

}
