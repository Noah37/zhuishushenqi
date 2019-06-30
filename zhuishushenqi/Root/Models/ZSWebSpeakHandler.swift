//
//  ZSWebSpeakHandler.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSWebSpeakHandler: ZSWebEventHandlerProtocol {
    static func canHandleWebItem(item: ZSWebItem) -> Bool {
        return true
    }
    
    func handleWebItem(item: ZSWebItem, context: ZSWebContext, block: (String) -> Void) {
        
    }
    
    
}
