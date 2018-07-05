//
//  Array+ZSExtension.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/4.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation

extension Array {
    func find <T: Equatable> (array: [T], item : T) ->Int? {
        var index = 0
        while(index < array.count) {
            if(item == array[index]) {
                return index
            }
            index = index + 1
        }
        return nil
    }
}


