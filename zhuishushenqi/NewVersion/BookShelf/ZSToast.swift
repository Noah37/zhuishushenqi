//
//  ZSToast.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/17.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import PKHUD

enum ToastType {
    case success
    case failure
    case warning
}

class Toast: UIView {

    static func show(_ type:ToastType,_ delay:TimeInterval = 3) {
        switch type {
        case .success:
            HUD.flash(HUDContentType.success, delay: delay)
            break
        case .failure:
            HUD.flash(HUDContentType.error, delay: delay)
            break
        case .warning:
            HUD.flash(HUDContentType.progress, delay: delay)
            break
        default:
            break
        }
    }
    
    static func show(tip:String, _ type:ToastType = .success,_ delay:TimeInterval = 3) {
        switch type {
        case .success:
            HUD.flash(.labeledSuccess(title: tip, subtitle: nil), delay: delay)
            break
        case .failure:
            HUD.flash(.labeledError(title: tip, subtitle: nil), delay: delay)
            break
        case .warning:
            HUD.flash(.labeledProgress(title: tip, subtitle: nil), delay: delay)
            break
        default:
            break
        }
    }
}
