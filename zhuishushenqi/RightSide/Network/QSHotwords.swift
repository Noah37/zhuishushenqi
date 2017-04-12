//
//  QSHotwords.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation

struct API {
    static let base = BASEURL
}

protocol QSHotWord {
    var staURL:String { get }
    var contain:String { get }
}

enum QSHotwords {
    enum QSSearchWords:QSHotWord {
        case fetch(id:String)
        public var staURL :String {
            switch self {
            case .fetch:
                return "\(API.base)/book/hot-word"
            }
        }
        public var contain: String {
            switch self {
            case .fetch(let id):
                return "/book/hot-word/\(id)"
            }
        }
    }
}

