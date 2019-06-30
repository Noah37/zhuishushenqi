//
//  Speaker.swift
//  iflyDemo
//
//  Created by caony on 2018/9/19.
//  Copyright © 2018年 QSH. All rights reserved.
//

import Foundation
import HandyJSON

//https://ttsh5.openspeech.cn/tts-h5/speaker/list

class Speaker: HandyJSON {
    
    var accent = "普通话"
    var age = 25
    var appid = "5445f87d"
    var commonExpirationDate = ""
    var desc = ""
    var downloads = 20806
    var engineType = "local"
    var engineVersion = 1
    var ent = ""
    var experienceExpirationDate = ""
    var field = "恐怖灵异"
    var isActive = 1
    var isDefault = 0
    var isNew = 0
    var isRecommend = 0
    var isVip = 0
    var largeIcon = "https://bj.openstorage.cn/v1/iflytek/tts/common/icon/xiaoxi_big.png"
    var level = 3
    var listenPath = "aHR0cHM6Ly9iai5vcGVuc3RvcmFnZS5jbi92MS9pZmx5dGVrL3R0cy9jb21tb24vbGlzdGVuL3hpYW94aS5tcDM="
    var name = "xiaoxi"
    var nickname = "方木"
    var price = 0
    var resId = 618
    var resPath = "aHR0cDovL2lmbHl0ZWsuYmpkbi5vcGVuc3RvcmFnZS5jbi90dHMvODdkL3Jlc291cmNlL3hpYW94aS56aXA="
    var resSize = 4295
    var sex = "male"
    var smallIcon = "https://bj.openstorage.cn/v1/iflytek/tts/common/icon/xiaoxi_small.png"
    var sortId = 2
    var speakerId = 51210
    var updateTime = "2018-09-19 19:21:05"
    var version = "1"
    var downloadUrl = "http://iflytek.bjdn.openstorage.cn/tts/87d/resource/xiaoxi.zip"
    var prelisten = "https://bj.openstorage.cn/v1/iflytek/tts/common/listen/xiaoxi.mp3"

    required init() {}
}
