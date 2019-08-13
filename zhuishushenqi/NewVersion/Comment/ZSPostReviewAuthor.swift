//
//	Author.swift
//
//	Create by 农运 on 7/8/2019
//	Copyright © 2019. All rights reserved.
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON


struct ZSPostReviewAuthor:HandyJSON{

	var id : String = ""
	var activityAvatar : String = ""
	var avatar : String = ""
	var created : String = ""
	var gender : String = ""
	var lv : Int = 0
	var nickname : String = ""
	var rank : AnyObject?
	var type : UserType = .none
    
    init() {}

}
