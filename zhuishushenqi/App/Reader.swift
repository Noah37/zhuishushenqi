//
//  ReaderStyle.swift
//  zhuishushenqi
//
//  Created by yung on 2017/8/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

enum Reader:Int {
    case white
    case yellow
    case green
    case blackgreen
    case pink
    case sheepskin
    case violet
    case water
    case weekGreen
    case weekPink
    case coffee
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
        case .blackgreen:
            return #imageLiteral(resourceName: "new_nav_night_normal")
        case .pink:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .sheepskin:
            return #imageLiteral(resourceName: "beijing")
        case .violet:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .water:
            return #imageLiteral(resourceName: "sheepskin_mode_bg")
        case .weekPink:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .weekGreen:
            return #imageLiteral(resourceName: "violet_mode_bg")
        case .coffee:
            return #imageLiteral(resourceName: "pf_header_bg")
        default:
            return #imageLiteral(resourceName: "violet_mode_bg")
        }
    }
    
    var textColor:UIColor {
        switch self {
        case .yellow,.white,.green:
            return UIColor.black
        case .blackgreen,.coffee:
            return UIColor.white
        default:
            return UIColor.black
        }
    }
    
    var batteryColor:UIColor {
        switch self {
        case .yellow,.white,.green:
            return UIColor.darkGray
        case .blackgreen,.coffee:
            return UIColor.white
        default:
            return UIColor.darkGray
        }
    }
    
}
