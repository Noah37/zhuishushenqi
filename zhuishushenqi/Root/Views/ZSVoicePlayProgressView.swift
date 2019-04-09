//
//  ZSVoicePlayProgressView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/23.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSVoicePlayProgressView: UIView {

    fileprivate var startTimeLabel:UILabel!
    fileprivate var totalTimeLabel:UILabel!
    fileprivate var progress:UIProgressView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
