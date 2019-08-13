//
//  MarkupParser.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/11.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit
import CoreText

enum ZSParseType: String, Codable {
    case none = ""
    case image = "image"
    case link = "link"
    case book = "book"
    case booklist = "booklist"
    case post = "post"
}

struct ZSImageParse:Codable {
    var type:ZSParseType = .image
    var url:String = ""
    var size:CGSize = CGSize.zero
}

class MarkupParser: NSObject {
    // MARK: - Properties
    var color: UIColor = .gray
    var fontName: String = "Arial"
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
    
    func attribute() ->[NSAttributedString.Key:Any] {
        let defaultFont: UIFont = .systemFont(ofSize: UIScreen.main.bounds.size.height / 40)
        let font = UIFont(name: fontName, size: UIScreen.main.bounds.size.height / 40) ?? defaultFont
        let style = NSMutableParagraphStyle()
        style.alignment = NSTextAlignment.left
        let attrs = [NSAttributedString.Key.foregroundColor: color, NSAttributedString.Key.font: font,NSAttributedString.Key.paragraphStyle:style] as [NSAttributedString.Key : Any]
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
    func parseContent(_ content: String) {
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
                    let text = NSMutableAttributedString(string: preText, attributes: attribute())
                    attrString.append(text)
                }
                // image
                if chunkStr.contains("{{") {
                    let imageModel = parse(imageStr: chunkStr)
                    if imageModel.type == .image {
                        var imageData = ZSImageData()
                        imageData.position = attrString.length
                        imageData.parse = imageModel
                        images.append(imageData)
                        let settings = CTSettings()
                        var width: CGFloat = imageData.parse?.size.width ?? 0
                        var height: CGFloat = imageData.parse?.size.height ?? 0
                        if width > settings.pageRect.width {
                            height = height/width * settings.pageRect.width
                            width = settings.pageRect.width
                        }
                        let attr = configImage(width: width, height: height)
                        attrString.append(attr)
                    }
                } else if chunkStr.contains("[[") { // link(post/booklist)
                    if let linkData = linkDara(str: chunkStr) {
                        links.append(linkData)
                        let text = NSMutableAttributedString(string: linkData.title, attributes: linkAttribute())
                        attrString.append(text)
                    }
                } else if chunkStr.contains("《") {
                    let text = NSMutableAttributedString(string: chunkStr, attributes: linkAttribute())
                    let book = parse(book: chunkStr)
                    books.append(book)
                    attrString.append(text)
                }
                lastRange = chunk.range
            }
            if lastRange.location + lastRange.length < content.count {
                if let remainContentRange = content.range(from: NSMakeRange(lastRange.location + lastRange.length, content.count - lastRange.location - lastRange.length)) {
                    let remainContent = String(content[remainContentRange])
                    let text = NSMutableAttributedString(string: remainContent, attributes: attribute())
                    attrString.append(text)
                }
            }
            let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
            let settings = CTSettings()
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
    
    func parse(book:String) ->ZSBookData {
        var bookModel = ZSBookData()
        bookModel.content = book
        bookModel.type = .book
        return bookModel
    }
    
    func parse(imageStr: String) ->ZSImageParse {
        var chunkStr = imageStr.replacingOccurrences(of: "{{", with: "")
        chunkStr = chunkStr.replacingOccurrences(of: "}}", with: "")
        var imageDic:[String:Any] = [:]
        let keyValueString = chunkStr.components(separatedBy: ",")
        for item in keyValueString {
            let keyValues = item.components(separatedBy: ":")
            if keyValues.count != 2 {
                continue
            }
            if keyValues.first! != "size" {
                imageDic[keyValues.first!] = keyValues.last!.removingPercentEncoding ?? ""
                continue
            }
            let sizes = keyValues.last!.components(separatedBy: "-")
            if sizes.count != 2 {
                continue
            }
            let size = CGSize(width: Double(sizes.first!) ?? 0, height: Double(sizes.last!) ?? 0)
            imageDic[keyValues.first!] = size
        }
        var imageParse = ZSImageParse()
        imageParse.type = ZSParseType.init(rawValue: imageDic["type"] as? String ?? "") ?? .none
        imageParse.size = imageDic["size"] as? CGSize ?? CGSize.zero
        imageParse.url = imageDic["url"] as? String ?? ""
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
