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
    
    var color:UIColor = UIColor.black
    
    var attributedText:String = "" {
        didSet{
            let fontSize = QSReaderSetting.shared.fontSize
            let lineSpace = QSReaderSetting.shared.lineSpace
            let config = CTFrameParserConfig()
            config.fontSize = CGFloat(fontSize)
            config.textColor = color
            config.width = QSReaderFrame.width
            config.lineSpace = lineSpace
            config.paragraphSpace = QSReaderSetting.shared.paragraphSpace
//            attribute = CTFrameParser.attributes(with: config)
            let data:CoreTextData = CTFrameParser.parseContent(attributedText, config: config)
            self.data = data
            setNeedsDisplay()
        }
    }
}
