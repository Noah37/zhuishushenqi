//
//  ZSAikanHtmlParser.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

class ZSAikanHtmlParser {
    
    static func string(node:OCGumboNode, aikanString:String, text:Bool) ->String {
        let regs = aikanString.components(separatedBy: "@")
        if regs.count != 4 {
            return ""
        }
        let reg1 = regs[1]
        if reg1.length > 0 {
            let obj = self.elementArray(node: node, regexString: reg1)
            if obj.count > 0 {
                let reg2 = regs[2]
                let reg2Value = Int(reg2) ?? 0
                var regNode:OCGumboNode?
                if obj.count > reg2Value {
                    regNode = obj[reg2Value] as? OCGumboNode
                    let reg3 = regs[3]
                    if reg3 == "own:" {
                        let text = regNode?.query("");
                        let resultNode = text?.lastObject as? OCGumboNode
                        return resultNode?.text() ?? "";
                    } else if reg3.length >= 5 {
                        let sub3 = reg3.nsString.substring(to: 4)
                        if sub3 == "abs:" {
                            let reg3Last = reg3.nsString.substring(from: 4)
                            let attr = regNode?.attr(reg3Last) ?? "";
                            return attr
                        }
                    } else if reg3.length > 0 {
                        let sub3 = reg3.nsString.substring(to: 1)
                        if sub3 == ":" {
                            let text = regNode?.text() ?? ""
                            let reg3Last = reg3.nsString.substring(from: 1)
                            let matchString = self.matchString(string: text, regString: reg3Last)
                            return matchString;
                        } else {
                            let attr = regNode?.attr(sub3) ?? ""
                            return attr
                        }
                    }
                    if text {
                        let text = regNode?.text() ?? ""
                        return text
                    } else {
                        let html = regNode?.html() ?? ""
                        return html
                    }
                }
            }
        } else {
            let reg3 = regs[3]
            if reg3 == "own:" {
                let text = node.query("")
                let resultNode = text?.lastObject as? OCGumboNode
                return resultNode?.text() ?? ""
            } else if reg3.length >= 5 {
                let sub3 = reg3.nsString.substring(to: 4)
                if sub3 == "abs:" {
                    let reg3Last = reg3.nsString.substring(from: 4)
                    let attr = node.attr(reg3Last) ?? ""
                    return attr
                }
            } else if reg3.length > 0 {
                let sub3 = reg3.nsString.substring(to: 1)
                if sub3 == ":" {
                    let text = node.text() ?? ""
                    let reg3Last = reg3.nsString.substring(from: 1)
                    let matchString = self.matchString(string: text, regString: reg3Last)
                    return matchString;
                } else {
                    let attr = node.attr(sub3) ?? ""
                    return attr
                }
            }
            if text {
                let text = node.text() ?? ""
                return text
            } else {
                let html = node.html() ?? ""
                return html
            }
        }
        return ""
    }
    
    static func matchString(string:String, regString:String) ->String {
        if string.length > 0 {
            let reg = try! NSRegularExpression(pattern: regString, options: NSRegularExpression.Options.caseInsensitive)
            let results = reg.matches(in: string, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, string.length))
            var resultString = ""
            var range1String = ""
            if results.count > 0 {
                for index in 0..<results.count {
                    let result = results[index]
                    let range = result.range
                    let subString = string.nsString.substring(with: range)
                    resultString.append(subString)
                    if result.numberOfRanges >= 2 {
                        let range1 = result.range(at: 1)
                        range1String = string.nsString.substring(with: range1)
                    }
                }
            }
            if results.count > 0 {
                resultString.append(string.nsString.substring(from: 0))
            }
            return range1String
        }
        return ""
    }

    static func elementArray(node:OCGumboNode, regexString:String) ->OCQueryObject {
        let regs = regexString.components(separatedBy: " ")
        var next:OCQueryObject = []
        if regs.count > 0 {
            for index in 0..<regs.count {
                var reg = regs[index]
                reg = reg.replacingOccurrences(of: "=", with: " ")
                if index > 0 {
                    next = next.find(reg) ?? [];
                } else {
                    next = node.query(reg) ?? [];
                }
            }
        }
        return next
    }

}
