//
//  QSBatteryView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/19.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSBatteryView: UIView {

    var batteryLevel:CGFloat = 1.0 {
        didSet{
            setNeedsLayout()
        }
    }
    
    private var `internal`:UIView!
    private var external:UIView!
    private var header:UIView!
    private var headerWidth:CGFloat = 0

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSubviews(){
        self.backgroundColor = UIColor.clear
        
        
        external = UIView()
        external.backgroundColor = UIColor.clear
        external.layer.borderColor  = UIColor.darkGray.cgColor
        external.layer.borderWidth = 1
        
        `internal` = UIView()
        `internal`.backgroundColor = UIColor.darkGray
        
        header = UIView()
        header.backgroundColor = UIColor.darkGray
        
        self.addSubview(external)
        self.addSubview(`internal`)
        self.addSubview(header)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let spaceX:CGFloat = 2
        let spaceY:CGFloat = 2
        let headerHeight = self.bounds.height/2
        let headerWidth = self.bounds.height/3
        if batteryLevel < 0 {
            batteryLevel = 1.0
        }
         let width = (self.bounds.width - 4 - headerWidth)*batteryLevel
        `internal`.frame = CGRect(x: spaceX, y: spaceY, width: width, height: self.bounds.height - 4)
        external.frame = CGRect(x: 0, y: 0, width: self.bounds.width - headerWidth, height: self.bounds.height)
        header.frame = CGRect(x: self.bounds.width - headerWidth, y: self.bounds.height/2 - headerHeight/2, width: headerWidth, height: headerHeight)
    }
}
