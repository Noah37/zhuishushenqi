//
//  QSLaunchRecView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/12.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias QSLaunchRecViewCallback = (_ btn:UIButton)->Void

class QSLaunchRecView: UIView {
    
    var closeCallback:QSLaunchRecViewCallback?
    var boyTipCallback:QSLaunchRecViewCallback?
    var girlTipCallback:QSLaunchRecViewCallback?
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var headerIcon: UIImageView!
    @IBOutlet weak var tipTitle: UILabel!
    @IBOutlet weak var tipDetail: UILabel!
    @IBOutlet weak var tipIcon: UIImageView!
    @IBOutlet weak var close: UIButton!
    @IBOutlet weak var parentView: UIView!
    
    @IBOutlet weak var boyBtn: UIButton!
    @IBOutlet weak var girlBtn: UIButton!
    @IBAction func closeAction(_ sender: Any) {
        if let close = closeCallback {
            close(sender as! UIButton)
        }
    }
    
    @IBAction func boyTip(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            girlBtn.isSelected = false
        }
        tipIcon.image = UIImage(named: "g_boy_tip")
        headerIcon.image = UIImage(named: "g_boy_avatar")
        headerView.backgroundColor = UIColor(red: 0.31, green: 0.75, blue: 1.0, alpha: 1.0)
        tipTitle.isHidden = true
        tipDetail.isHidden = true
        if let close = boyTipCallback {
            close(btn)
        }
    }
    
    @IBAction func girlTip(_ sender: Any) {
        let btn = sender as! UIButton
        btn.isSelected = !btn.isSelected
        if btn.isSelected {
            boyBtn.isSelected = false
        }
        tipIcon.image = UIImage(named: "g_girl_tip")
        headerIcon.image = UIImage(named: "g_girl_avatar")
        headerView.backgroundColor = UIColor(red: 1.0, green: 0.30, blue: 0.24, alpha: 1.0)

        tipTitle.isHidden = true
        tipDetail.isHidden = true
        if let close = girlTipCallback {
            close(btn)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        parentView.layer.cornerRadius = 5
        parentView.layer.masksToBounds = true
        
    }
}
