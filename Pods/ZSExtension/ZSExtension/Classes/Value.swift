//
//  Value.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

public struct Value<Base> {
    let base: Base
}

public protocol ValueCompatible {
    var value: Value<Self> { get }
}

extension ValueCompatible {
    public var value: Value<Self> {
        return Value(base: self)
    }
}
