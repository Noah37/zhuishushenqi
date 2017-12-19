//
//  ReaderStyle.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

enum Reader {
    case white
    case yellow
    case green
}

extension Reader {
    
    var backgroundImage:UIImage {
        switch self {
        case .yellow:
            return #imageLiteral(resourceName: "background_yellow")
        case .white:
            return #imageLiteral(resourceName: "background_white")
        case .green:
            return #imageLiteral(resourceName: "background_green")
        }
    }
    
}
