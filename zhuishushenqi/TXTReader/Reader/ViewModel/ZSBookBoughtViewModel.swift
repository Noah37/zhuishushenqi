//
//  ZSBookBoughtViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/11/15.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSBookBoughtViewModel: NSObject {
    func boughtInfo(id:String, token:String, _ callback:ZSBaseCallback<ZSBoughtInfo>?) {
        let api = QSAPI.boughtChapters(id: id, token: token)
        zs_get(api.path, parameters: api.parameters) { (json) in
            if let info = ZSBoughtInfo.deserialize(from: json) {
                callback?(info)
            }
        }
    }
}
