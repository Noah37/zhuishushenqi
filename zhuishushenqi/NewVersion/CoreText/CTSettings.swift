//
//  CTSettings.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/11.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit

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

struct ZSBookData {
    var content:String = ""
    var type:ZSParseType = .book
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
