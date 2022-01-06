//
//  MarkupParser.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/11.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit
import CoreText
import HandyJSON

enum ZSParseType: String, Codable {
    case none = ""
    case image = "image"
    case link = "link"
    case book = "book"
    case booklist = "booklist"
    case post = "post"
}

struct ZSImageParse:HandyJSON {
    var type:ZSParseType = .image
    var url:String = ""
    var size:String = "" {
        didSet {
            let sizeArray = size.components(separatedBy: "-")
            if sizeArray.count == 2 {
                imageSize = CGSize(width: Double(sizeArray.first!) ?? 0, height: Double(sizeArray.last!) ?? 0)
            }
        }
    }
    var imageSize:CGSize = .zero
}

class MarkupParser: NSObject {
    // MARK: - Properties
    var color: UIColor = .gray
    var fontName: String = "Arial"
    var fontSize: CGFloat = 13
    var font: UIFont = UIFont.systemFont(ofSize: 13)
    var lineSpace: CGFloat = 0
    var paragraphSpace: CGFloat = 0
    
    
    var attrString: NSMutableAttributedString!
    var images: [[String: Any]] = []
    
    var coreData:ZSTextData?
    
    // MARK: - Initializers
    override init() {
        super.init()
    }
    
    let kBookNamePattern = "(《.*?》)"
    let kTextLinkPattern = "(\\[\\[.*?\\]\\])"
    let kBookJumpPattern = "(\\{\\{.*?\\}\\})"
//    //《❤温馨小贴士》
//    static NSString *const kImageViewPattern = @"(《.*?》)";
//
//    //static NSString *const kImageViewPattern = @"(?<name>《.*?》)";
//
//    //[[post:5b50550d6f788aef59667822 【传送门】告别燥热？这样玩转书单还有惊喜大礼！]]
//    static NSString *const kTextLinkPattern = @"(\\[\\[.*?\\]\\])";
//
//    //{{type:image,url:http%3A%2F%2Fstatics.zhuishushenqi.com%2Fpost%2F151678369762541,size:420-422}}
//    static NSString *const kBookPattern = @"(\\{\\{.*?\\}\\})";
    
//    "content": "\n{{type:book,id:5ec6a64273f1fa0f00ca4122,title:我的徒弟都是大反派,author:谋生任转蓬,cover:/agent/http%3A%2F%2Fimg.13***%2Fapi%2Fv1%2Fbookcenter%2Fcover%2F1%2F3458246%2F3458246_c43a9d1461c04a6ea6eb8425ecc6e980.jpg%2F,allowFree:true,latelyFollower:23815,wordCount:4417679,allowMonthly:true,contentType:txt,superscript:,isSerial:false,retentionRatio:79.81,majorCateV2:,minorCateV2:东方玄幻,onShelve:true}}\n\n睁眼醒来发现自己身处异世，武功全无，身边还都是一个个想要逼死师父的大反派，怎一个惨字了得？！看猪脚是如何通过系统的帮助吊打众人，重返巅峰，纵横天下！此书格局很大，一环扣一环，整体架构严谨，但文笔还需继续加强，不过作为新人来讲已经很不错了，强行安利一波！男主的人设是个糟老头子，一开始也就没什么颜值了，刚穿越过去的时候想要低调但实力不允许啊！",
    
    // 根据配置获取富文本格式
    func attributes() ->[NSAttributedString.Key:Any] {
        let fontRef = CTFontCreateWithName("ArialMT" as CFString, fontSize, nil)
        let settingCount = 3
        let settings:[CTParagraphStyleSetting] =
            [
                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.lineSpacingAdjustment, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.maximumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
                CTParagraphStyleSetting(spec: CTParagraphStyleSpecifier.minimumLineSpacing, valueSize: MemoryLayout<CGFloat>.size, value: &lineSpace),
        ]
        let paragraph = CTParagraphStyleCreate(settings, settingCount)
        
        let textColor = color
        
        let attr:[NSAttributedString.Key:Any] = [
            NSAttributedString.Key.foregroundColor:textColor.cgColor,
            NSAttributedString.Key.font:fontRef,
            NSAttributedString.Key.paragraphStyle:paragraph
        ]
        return attr
    }
    
    func attribute() ->[NSAttributedString.Key:Any] {
        let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
        let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle:style] as [NSAttributedString.Key : Any]
        return attrs
    }
    
    func bookAttribute() ->[NSAttributedString.Key:Any] {
        let defaultFont: UIFont = .systemFont(ofSize: 13)
        let font = UIFont(name: fontName, size: 13) ?? defaultFont
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        let attrs = [NSAttributedString.Key.foregroundColor: UIColor.orange, NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle:style] as [NSAttributedString.Key : Any]
        return attrs
    }
    
    func linkAttribute() ->[NSAttributedString.Key:Any] {
        let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
        let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
        let linkColor = UIColor.orange
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        let attrs = [NSAttributedString.Key.foregroundColor: linkColor, NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle:style] as [NSAttributedString.Key : Any]
        return attrs
    }
    
    // MARK: - zssq parse
    func parseContent(_ content: String, settings:CTSettings) {
        attrString = NSMutableAttributedString(string: "")
        let pattern = "\(kBookNamePattern)|\(kBookJumpPattern)|\(kTextLinkPattern)"
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [.caseInsensitive,.dotMatchesLineSeparators])
            let chunks = regex.matches(in: content, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: content.count))
            var images:[ZSImageData] = []
            var links:[ZSLinkData] = []
            var books:[ZSBookData] = []
            var lastRange:NSRange = NSMakeRange(0, 0)
            for chunk in chunks {
                guard let markupRange = content.range(from: chunk.range) else {
                    lastRange = chunk.range
                    continue
                }
                let chunkSubStr = content[markupRange]
                let chunkStr = String(chunkSubStr)
                if let preTextRange = content.range(from: NSMakeRange(lastRange.location + lastRange.length, chunk.range.location - lastRange.location - lastRange.length)) {
                    let preText = String(content[preTextRange])
                    let text = NSMutableAttributedString(string: preText, attributes: attributes())
                    attrString.append(text)
                }
                // image or book
                if chunkStr.contains("{{") {
                    let bookAndImageDict = getDict(bookAndImage: chunkStr)
                    let type = bookAndImageDict["type"] as? String ?? ""
                    if type == ZSParseType.book.rawValue {
                        let book = parseBook(dict: bookAndImageDict)
                        let text = NSMutableAttributedString(string: "《\(book.title)》", attributes: bookAttribute())
                        books.append(book)
                        attrString.append(text)
                    } else if type == ZSParseType.image.rawValue {
                        let imageModel = parse(imageDict: bookAndImageDict)
                        if imageModel.type == .image {
                            var imageData = ZSImageData()
                            imageData.position = attrString.length
                            imageData.parse = imageModel
                            images.append(imageData)
                            var width: CGFloat = imageData.parse?.imageSize.width ?? 0
                            var height: CGFloat = imageData.parse?.imageSize.height ?? 0
                            if width > settings.pageRect.width {
                                height = height/width * settings.pageRect.width
                                width = settings.pageRect.width
                            }
                            let attr = configImage(width: width, height: height)
                            attrString.append(attr)
                        }
                    }
                } else if chunkStr.contains("[[") { // link(post/booklist)
                    if let linkData = linkDara(str: chunkStr) {
                        links.append(linkData)
                        let text = NSMutableAttributedString(string: linkData.title, attributes: linkAttribute())
                        attrString.append(text)
                    }
                }
//                else if chunkStr.contains("《") {
//                    let text = NSMutableAttributedString(string: chunkStr, attributes: linkAttribute())
//                    let book = parse(book: chunkStr)
//                    books.append(book)
//                    attrString.append(text)
//                }
                lastRange = chunk.range
            }
            if lastRange.location + lastRange.length < content.count {
                if let remainContentRange = content.range(from: NSMakeRange(lastRange.location + lastRange.length, content.count - lastRange.location - lastRange.length)) {
                    let remainContent = String(content[remainContentRange])
                    let text = NSMutableAttributedString(string: remainContent, attributes: attributes())
                    attrString.append(text)
                }
            }
            let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
            let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize(width: settings.pageRect.width, height: CGFloat.greatestFiniteMagnitude), nil)

            var coreData = ZSTextData()
            coreData.books = books
            coreData.images = images
            coreData.links = links
            coreData.height = textSize.height
            self.coreData = coreData
        } catch _ {
            
        }
    }
    
    func getDict(bookAndImage:String) ->[String:Any] {
        var chunkStr = bookAndImage.replacingOccurrences(of: "{{", with: "")
        chunkStr = chunkStr.replacingOccurrences(of: "}}", with: "")
        var bookAndImageDic:[String:Any] = [:]
        let keyValueString = chunkStr.components(separatedBy: ",")
        for item in keyValueString {
            let keyValues = item.components(separatedBy: ":")
            if keyValues.count != 2 {
                continue
            }
            let key = keyValues.first!
            let value = keyValues.last!
            bookAndImageDic[key] = value
        }
        return bookAndImageDic
    }
    
    func parseBook(dict:[String:Any]) ->ZSBookData {
        let bookModel = ZSBookData()
        if let bookModel = ZSBookData.deserialize(from: dict, designatedPath: nil) {
            return bookModel
        }
        return bookModel
    }
    
    func parse(imageDict:[String:Any]) ->ZSImageParse {
        let imageParse = ZSImageParse()
        if let imageParse = ZSImageParse.deserialize(from: imageDict, designatedPath: nil) {
            return imageParse
        }
        return imageParse
    }
    
    func linkDara(str:String) ->ZSLinkData? {
        var linkStr = str.replacingOccurrences(of: "[[", with: "")
        linkStr = linkStr.replacingOccurrences(of: "]]", with: "")
        let links = linkStr.components(separatedBy: ":")
        if links.count == 2 {
            // 这里有三种情况，post/link/booklist
            // 先取key 判断类型
            let key = links.first!
            guard let type = ZSParseType.init(rawValue: key) else {
                return nil
            }
            switch type{
            case .post, .booklist, .link, .book:
                let postValue = links.last!
                // 第一个空格进行分割
                guard let range = postValue.range(of: " ") else {
                    return nil
                }
                let startPos = String.Index.init(utf16Offset: 0, in: postValue)
                let link = String(postValue[startPos..<range.lowerBound])
                let endPos = String.Index.init(utf16Offset: link.count, in: postValue)
                let title = String(postValue[endPos...])
                var linkData = ZSLinkData()
                linkData.key = links.first!
                linkData.linkTo = link
                linkData.url = link
                linkData.title = title
                linkData.type = type
                return linkData
            default:
                break
            }
        }
        return nil
    }
    
    func bookData() ->ZSBookData? {
        
        return nil
    }
    
    // MARK: - Internal
    func parseMarkup(_ markup: String) {
        //1
        attrString = NSMutableAttributedString(string: "")
        //2
        do {
            let regex = try NSRegularExpression(pattern: "(.*?)(<[^>]+>|\\Z)", options: [.caseInsensitive,.dotMatchesLineSeparators])
            //3
            let chunks = regex.matches(in: markup, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: markup.count))
            let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
            //1
            for chunk in chunks {
                //2
                guard let markupRange = markup.range(from: chunk.range) else { continue }
                //3
                let parts = markup[markupRange].components(separatedBy: "<")
                //4
                let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
                //5
                let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font] as [NSAttributedString.Key : Any]
                let text = NSMutableAttributedString(string: parts[0], attributes: attrs)
                attrString.append(text)
                
                // 1
                if parts.count <= 1 {
                    continue
                }
                let tag = parts[1]
                //2
                if tag.hasPrefix("font") {
                    let colorRegex = try NSRegularExpression(pattern: "(?<=color=\")\\w+", options: NSRegularExpression.Options(rawValue: 0))
                    colorRegex.enumerateMatches(in: tag, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, tag.count)) { (match, _, _) in
                        //3
                        if let match = match,
                            let range = tag.range(from: match.range) {
                            let colorSel = NSSelectorFromString(tag[range]+"Color")
                            color = UIColor.perform(colorSel).takeRetainedValue() as? UIColor ?? .black
                        }
                    }
                    //5
                    let faceRegex = try NSRegularExpression(pattern: "(?<=face=\")[^\"]+", options: NSRegularExpression.Options(rawValue: 0))
                    faceRegex.enumerateMatches(in: tag, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, tag.count)) { (match, _, _) in
                        
                        if let match = match,
                            let range = tag.range(from: match.range) {
                            fontName = String(tag[range])
                        }
                    }
                }
                    //1
                else if tag.hasPrefix("img") {
                    
                    var filename:String = ""
                    let imageRegex = try NSRegularExpression(pattern: "(?<=src=\")[^\"]+", options: NSRegularExpression.Options(rawValue: 0))
                    imageRegex.enumerateMatches(in: tag, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, tag.count)) { (match, _, _) in
                            if let match = match, let range = tag.range(from: match.range) {
                                filename = String(tag[range])
                            }
                    }
                    //2
                    let settings = CTSettings()
                    var width: CGFloat = settings.columnRect.width
                    var height: CGFloat = 0
                    
                    if let image = UIImage(named: filename) {
                        height = width * (image.size.height / image.size.width)
                        // 3
                        if height > settings.columnRect.height - font.lineHeight {
                            height = settings.columnRect.height - font.lineHeight
                            width = height * (image.size.width / image.size.height)
                        }
                    }
                    //1
                    images += [["width": NSNumber(value: Float(width)),
                                "height": NSNumber(value: Float(height)),
                                "filename": filename,
                                "location": NSNumber(value: attrString.length)]]
                    let attr = configImage(width: width, height: height)
                    attrString.append(attr)
                }
                
            }
        } catch _ {
        }
        
    }
    
    func configImage(width:CGFloat, height:CGFloat) ->NSAttributedString {
        struct RunStruct {
            let ascent: CGFloat
            let descent: CGFloat
            let width: CGFloat
        }
        
        let extentBuffer = UnsafeMutablePointer<RunStruct>.allocate(capacity: 1)
        extentBuffer.initialize(to: RunStruct(ascent: height, descent: 0, width: width))
        //3
        var callbacks = CTRunDelegateCallbacks(version: kCTRunDelegateVersion1, dealloc: { (pointer) in
        }, getAscent: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: RunStruct.self)
            return d.pointee.ascent
        }, getDescent: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: RunStruct.self)
            return d.pointee.descent
        }, getWidth: { (pointer) -> CGFloat in
            let d = pointer.assumingMemoryBound(to: RunStruct.self)
            return d.pointee.width
        })
        //4
        let delegate = CTRunDelegateCreate(&callbacks, extentBuffer)
        //5
        let attrDictionaryDelegate = [(kCTRunDelegateAttributeName as NSAttributedString.Key): (delegate as Any)]
        var objectReplacementChar:unichar = 0xFFFC
        let content = NSString(characters: &objectReplacementChar, length: 1)
        let attrStr = NSMutableAttributedString(string: String(content), attributes: attrDictionaryDelegate)
        attrStr.addAttributes(attribute(), range: NSMakeRange(0, attrStr.length))
        return attrStr
    }
}

extension String {
    func range(from range: NSRange) -> Range<String.Index>? {
        guard let from16 = utf16.index(utf16.startIndex,
                                       offsetBy: range.location,
                                       limitedBy: utf16.endIndex),
            let to16 = utf16.index(from16, offsetBy: range.length, limitedBy: utf16.endIndex),
            let from = String.Index(from16, within: self),
            let to = String.Index(to16, within: self) else {
                return nil
        }
        
        return from ..< to
    }
}
