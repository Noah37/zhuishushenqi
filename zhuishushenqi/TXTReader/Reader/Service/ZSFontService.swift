//
//  ZSFontService.swift
//  zhuishushenqi
//
//  Created by caony on 2018/9/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

class ZSFontService {
    
    func fetchFont(url:String,_ handler:ZSBaseCallback<[String:Any]>?) {
        zs_download(url: url) { (json) in
            handler?(json)
        }
    }
}
