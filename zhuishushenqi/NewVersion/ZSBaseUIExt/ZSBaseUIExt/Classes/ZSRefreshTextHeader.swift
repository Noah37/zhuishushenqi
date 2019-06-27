//
//  ZSRefreshTextHeader.swift
//  ZSBaseUI
//
//  Created by caony on 2019/6/20.
//

import UIKit
import MJRefresh
import ZSThirdPartSDK

open class ZSRefreshTextHeader: MJRefreshHeader {

    open var tipBackgroundView:UIImageView!
    open var tipLabel:UILabel!
    open var gifView:UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func setText(text:String) {
        self.tipLabel.text = text
    }
    
    override open func prepare() {
        super.prepare()
        self.mj_h = 120
        guard let info = Bundle.init(for: ZSRefreshTextHeader.self).infoDictionary else { return }
        guard let executableName = info[kCFBundleExecutableKey as String] else { return }
        var bundlePath = Bundle.init(for: ZSRefreshTextHeader.self).resourcePath ?? ""
        bundlePath = bundlePath.appending("/\(executableName).bundle")
        let imagePath = bundlePath.appending("/bookstore_bg")
        let bgImage = UIImage(named: imagePath)
        tipBackgroundView = UIImageView(image: bgImage)
        addSubview(tipBackgroundView)
        
        tipLabel = UILabel(frame: CGRect.zero)
        tipLabel.textColor = UIColor(red:0.51, green:0.33, blue:0.32, alpha:1.00)
        tipLabel.font = UIFont.systemFont(ofSize: 13)
        tipLabel.text = "来年若是凌风起，你自长哭我长笑"
        tipLabel.textAlignment = .center
        tipBackgroundView.addSubview(tipLabel)
        
        let gifPath = bundlePath.appending("/mj_refresh")
        
        gifView = UIImageView(image: UIImage(named: gifPath))
        addSubview(gifView)
    }
    
    override open func placeSubviews() {
        super.placeSubviews()
        self.tipBackgroundView.frame = CGRect(x: 19, y: 10, width: self.bounds.width - 19*2, height: 59)
        self.tipLabel.frame = CGRect(x: 13, y: 12, width: tipBackgroundView.bounds.width - 26, height: 36)
        self.gifView.frame = CGRect(x: self.bounds.width/2 - 23/2, y: self.tipBackgroundView.frame.maxY + self.bounds.height/2 - self.tipBackgroundView.frame.maxY/2 - 16, width: 23, height: 32)
    }
    
}
