//
//  ZSReaderProtocol.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import Foundation


// 点击
protocol ZSReaderTap {
    func showNextPage(page:QSPage)
    func showLastPage(page:QSPage)
}
