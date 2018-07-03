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
            return #imageLiteral(resourceName: "yellow_mode_bg")
        case .white:
            return #imageLiteral(resourceName: "white_mode_bg")
        case .green:
            return #imageLiteral(resourceName: "green_mode_bg")
        }
    }
    
}

// 翻页方式属于全局
enum ZSReaderAnimationStyle:Int {
    case none = 0 // 无翻页动画
    case horizonal // 左右覆盖
    case vertical // 上下覆盖
    case horMove // 左右平移
    case verMove //上下平移
    case verScroll //上下滚屏
    case curlPage // 仿真翻页
}
