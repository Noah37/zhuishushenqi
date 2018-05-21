//
//  PageView.swift
//  PageViewController
//
//  Created by Nory Cao on 16/10/9.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

class PageView: CTDisplayView {

    // size color
    var attribute:NSDictionary {
        get {
            let config = CTFrameParserConfig()
            config.fontSize = CGFloat(fontSize)
            config.textColor = color
            let attributes = CTFrameParser.attributes(with: config)
            return attributes!
        }
        set {
            
        }
    }
    
    var fontSize:Int {
        get {
            return AppStyle.shared.readFontSize
        }
        set {
            
        }
    }
    
    var color:UIColor = UIColor.black
    
    var attributedText:String = "" {
        didSet{
            let config = CTFrameParserConfig()
            config.fontSize = CGFloat(fontSize)
            config.textColor = color
            config.width = self.bounds.size.width
            attribute = CTFrameParser.attributes(with: config)
            let data:CoreTextData = CTFrameParser.parseContent(attributedText, config: config)
            self.data = data
            setNeedsDisplay()
        }
    }
}
