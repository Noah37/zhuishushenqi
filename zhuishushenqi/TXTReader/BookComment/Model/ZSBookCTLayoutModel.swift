//
//  ZSBookCTLayoutModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/10/15.
//  Copyright © 2018 QS. All rights reserved.
//

import UIKit

class ZSBookCTLayoutModel: NSObject {
    
    var nameLabelOriginY:CGFloat = 20
    var nameLabelHeight:CGFloat = 20
    
    var createLabelOriginY:CGFloat = 6
    var createLabelHeight:CGFloat = 10
    
    var titleLabelOriginY:CGFloat = 20
    var titleLabelHeight:CGFloat = 30
    
    var displayViewOriginY:CGFloat = 10
    var displayViewHeight:CGFloat = 0
    
    var bookBgViewOriginY:CGFloat = 20
    var bookBgViewHeight:CGFloat = 74
    
    var feelingViewOriginY:CGFloat = 0
    var feelingViewHeight:CGFloat = 70
    
    var totalHeight:CGFloat = 0
    
    
    // depreted
    var contentHeight:CGFloat = 0
    
    var titleHeight:CGFloat = 0
    
    var config = CTFrameParserConfig()
    
    init(book:BookComment,data:CoreTextData) {
        super.init()
        // 废弃
        contentHeight = data.height
        titleHeight = book.title.qs_height(13, width: ScreenWidth - 16)
        
        setupLayout(book: book, data: data)
    }
    
    func setupLayout(book:BookComment,data:CoreTextData) {
        // 开始计算高度
        let titleTextHegiht = book.title.qs_height(UIFont.systemFont(ofSize: 18), width: UIScreen.main.bounds.width - 40)
        titleLabelHeight = titleTextHegiht
        
        displayViewHeight = data.height
        if book.book.cover == "" {
            bookBgViewHeight = 0
        }
        totalHeight = nameLabelOriginY + nameLabelHeight + createLabelOriginY + createLabelHeight + titleLabelOriginY + titleLabelHeight + displayViewOriginY + displayViewHeight + bookBgViewOriginY + bookBgViewHeight + feelingViewOriginY + feelingViewHeight
    }

}
