//
//  ZSBookCTLayoutModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/15.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSBookCTLayoutModel: NSObject {
    
    var contentHeight:CGFloat = 0
    
    var titleHeight:CGFloat = 0
    
    var config = CTFrameParserConfig()
    
    init(book:BookComment,data:CoreTextData) {
        super.init()
        contentHeight = data.height
        titleHeight = book.title.qs_height(13, width: ScreenWidth - 16)
        
    }

}
