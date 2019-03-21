//
//  ZSSegmentBaseViewModel.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/18.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

protocol ZSSegmentBaseViewProtocol {
    var books:[Book] { get set }
}

class ZSSegmentBaseViewModel {
    var books:[Book]  = []
}
