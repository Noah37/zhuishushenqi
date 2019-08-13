//
//	Book.swift
//
//	Create by 农运 on 7/8/2019
//	Copyright © 2019. All rights reserved.
//	模型生成器（小波汉化）JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation
import HandyJSON

struct ZSPostReviewBook :HandyJSON{

	var id : String = ""
	var allowFree : Bool = false
	var apptype : [Int] = []
	var author : String = ""
	var cover : String = ""
	var latelyFollower : AnyObject?
	var retentionRatio : AnyObject?
	var safelevel : Int = 0
	var title : String = ""

}
