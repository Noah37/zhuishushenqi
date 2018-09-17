//
//  ZSFontViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2018/9/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

class ZSFontViewModel {
    
    var webService = ZSFontService()
    //        http://statics.zhuishushenqi.com/fonts/fz-qkbys.TTF
//    http://statics.zhuishushenqi.com/fonts/fz-yhzx.TTF
//    http://statics.zhuishushenqi.com/fonts/fz-xjlt-new.ttf
//    http://statics.zhuishushenqi.com/fonts/fz-sxslkt.ttf
//    http://statics.zhuishushenqi.com/fonts/fz-mwt.ttf
    var fonts = [["key":"system",
                 "name":"系统默认",
                 "image":""],
                 ["key":"fz-yhzx.TTF",
                  "name":"方正悠黑",
                  "image":"fzyouhei"],
                 ["key":"fz-qkbys.TTF",
                  "name":"方正清刻本悦宋",
                  "image":"fzqingke"],
                 ["key":"fz-xjlt-new.ttf",
                  "name":"方正金陵细",
                  "image":"fzxijinling"],
                 ["key":"fz-sxslkt.ttf",
                  "name":"方正苏新诗柳楷",
                  "image":"fzsuxinshil"],
                 ["key":"fz-mwt.ttf",
                  "name":"方正喵呜",
                  "image":"fzmiaowu"],
                 ["key":"ltt.ttf",
                  "name":"兰亭黑",
                  "image":"lantingh"],
                 ["key":"fz-kt.ttf",
                  "name":"楷体",
                  "image":"kai"],
                 ["key":"fz-wbt.ttf",
                  "name":"魏碑",
                  "image":"weibei"],
                 ["key":"ypt.ttf",
                  "name":"雅痞",
                  "image":"yapi"],
                 ["key":"hkppt.ttf",
                  "name":"翩翩体",
                  "image":"pianpian"],
                 ["key":"hylst.ttf",
                  "name":"隶书",
                  "image":"li"],
                 ["key":"Redocn.ttf",
                  "name":"日文字体",
                  "image":"riwen"]
                ]
    
    var selectedIndexPath = IndexPath(item: 0, section: 0)
    
    func fetchFont(indexPath:IndexPath, handler:ZSBaseCallback<Bool>?) {
        var dict = fonts[indexPath.row]
        let path:String = "\(NSHomeDirectory())/Documents/\(dict["key"] ?? "")"
        if FileManager.default.fileExists(atPath: path) {
            handler?(true)
        } else {
            let url = "http://statics.zhuishushenqi.com/fonts/\(dict["key"] ?? "")"
            webService.fetchFont(url: url) { (json) in
                if let _ = json?["url"] {
                    handler?(true)
                } else {
                    handler?(false)
                }
            }
        }
    }
    
    func fileExist(indexPath:IndexPath) -> Bool {
        var dict = fonts[indexPath.row]
        let path:String = "\(NSHomeDirectory())/Documents/\(dict["key"] ?? "")"
        let exist = FileManager.default.fileExists(atPath: path)
        return exist
    }
    
    func copyFont() {
        for font in fonts {
            let file = font["key"] ?? ""
            let path = "\(NSHomeDirectory())/Documents/\(file)"
            let bundlePath = Bundle.main.path(forResource: file, ofType: nil) ?? ""
            let exist = FileManager.default.fileExists(atPath: bundlePath)
            if exist {
                try? FileManager.default.copyItem(atPath: bundlePath, toPath: path)
            }
        }
    }
    
    func fontArray(path:String, size:CGFloat) {
        let fontPath = CFStringCreateWithCString(nil, path.cString(using: .utf8), CFStringBuiltInEncodings.UTF8.rawValue)
        if let fontURL = CFURLCreateWithFileSystemPath(nil, fontPath, CFURLPathStyle.cfurlposixPathStyle, false) {
            let fontArray = CTFontManagerCreateFontDescriptorsFromURL(fontURL)
            CTFontManagerRegisterFontsForURL(fontURL, CTFontManagerScope.none, nil)
            var customAttay:[UIFont] = []
            for item in 0..<CFArrayGetCount(fontArray) {
                let discriptor = CFArrayGetValueAtIndex(fontArray, item) as! CTFontDescriptor
                let font:CTFont = CTFontCreateWithFontDescriptor(discriptor, size, nil)
                if let fontName = CTFontCopyName(font, kCTFontPostScriptNameKey) as String? {
                    let cusFont = UIFont(name: fontName, size: size)
                    customAttay.append(cusFont!)
                }
            }
        }
    }
}
