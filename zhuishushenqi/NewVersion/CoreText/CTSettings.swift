//
//  CTSettings.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/11.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit
import HandyJSON
//{{type:book,id:5ec6a64273f1fa0f00ca4122,title:我的徒弟都是大反派,author:谋生任转蓬,cover:/agent/http%3A%2F%2Fimg.13***%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F3458246%2F3458246_c43a9d1461c04a6ea6eb8425ecc6e980.jpg%2F,allowFree:true,latelyFollower:23815,wordCount:4417679,allowMonthly:true,contentType:txt,superscript:,isSerial:false,retentionRatio:79.81,majorCateV2:,minorCateV2:东方玄幻,onShelve:true}}

struct ZSImageData {
    var parse:ZSImageParse?
    var position:Int = 0
    // coretext frame
    var imagePosition:CGRect = .zero
    var image:UIImage?
}

struct ZSLinkData {
    var title:String = ""
    var url:String = ""
    // post或者booklist
    var linkTo:String = ""
    var key:String = ""
    var type:ZSParseType = .link
}

struct ZSBookData:HandyJSON {
    var content:String = ""
    var type:ZSParseType = .book
    var id:String = ""
    var title:String = ""
    var author:String = ""
    var cover:String = ""
    var allowFree:Bool = true
    var latelyFollower:Int = 0
    var wordCount:Int = 0
    var allowMonthly:Bool = false
    var contentType:String = "txt"
    var superscript:String = ""
    var isSerial:Bool = false
    var retentionRatio:Double = 0
    var majorCateV2:String = ""
    var minorCateV2:String = ""
    var onShelve:Bool = false
}

struct ZSTextData {
    var ctFrame:CTFrame?
    var height:CGFloat = 0
    var images:[ZSImageData] = []
    var links:[ZSLinkData] = []
    var books:[ZSBookData] = []
    var content:NSAttributedString?
}

class CTSettings {
    
    //1
    // MARK: - Properties
    var margin: CGFloat = 20 {
        didSet { setMargin(margin: margin) }
    }
    var columnsPerPage: CGFloat!
    var pageRect: CGRect!
    var columnRect: CGRect!
    
    static let shared = CTSettings()
    
    // MARK: - Initializers
    init() {
        //2
        columnsPerPage = UIDevice.current.userInterfaceIdiom == .phone ? 1 : 2
        //3
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)
        //4
        columnRect = CGRect(x: 0,
                            y: 0,
                            width: pageRect.width / columnsPerPage,
                            height: pageRect.height).insetBy(dx: margin, dy: margin)
    }
    
    func setMargin(margin:CGFloat) {
        pageRect = UIScreen.main.bounds.insetBy(dx: margin, dy: margin)
        columnRect = CGRect(x: 0,
                            y: 0,
                            width: pageRect.width / columnsPerPage,
                            height: pageRect.height).insetBy(dx: margin, dy: margin)
    }

}
