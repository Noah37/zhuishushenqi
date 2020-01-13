//
//  ZSReaderProtocol.swift
//  zhuishushenqi
//
//  Created by caony on 2019/9/19.
//  Copyright © 2019 QS. All rights reserved.
//

import Foundation

typealias ZSReaderPageHandler = ()->Void


protocol ZSReaderVCProtocol {
    
    func bind(viewModel:ZSReaderBaseViewModel)
    
    func bind(toolBar:ZSReaderToolbar)
    
    func load()
    
    func destroy()
    
    func changeBg(style:ZSReaderStyle)
    
    func fontChange()
    
    // 遵循协议的子页面向reader索取page
    var nextPageHandler:ZSReaderPageHandler? { get set }
    var lastPageHandler:ZSReaderPageHandler? { get set }
    
    // reader调用子页面更新page
    func jumpPage(page:ZSBookPage)
}
