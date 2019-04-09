//
//  ZSVoiceAlbum.swift
//  zhuishushenqi
//
//  Created by caony on 2019/3/26.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation
import HandyJSON

struct ZSVoiceAnnouncer:HandyJSON {
    var id:String = ""
    var kind:String = ""
    var nickname:String = ""
    var avatar_url:String = ""
    var is_verified:Bool = true
    var anchor_grade:Int = 0
    
    init() {
        
    }
}

struct ZSVoiceLastUptrack:HandyJSON {
    var track_id:Int = 0
    var track_title:String = ""
    var duration:Int = 0
    var created_at:Int = 0
    var updated_at:Int = 0
    
    init() {
        
    }
}

struct ZSVoiceAlbum: HandyJSON {
    
    var id:String = ""
    var kind:String = ""
    var category_id:Int = 3
    var album_title:String = ""
    var album_tags:String = ""
    var album_intro:String = ""
    var cover_url_small:String = ""
    var cover_url_middle:String = ""
    var cover_url_large:String = ""
    var announcer:ZSVoiceAnnouncer = ZSVoiceAnnouncer()
    var play_count:Int = 0
    var share_count:Int = 0
    var favorite_count:Int = 0
    var subscribe_count:Int = 0
    var include_track_count:Int = 0
    var last_uptrack:ZSVoiceLastUptrack = ZSVoiceLastUptrack()
    var is_finished:Int = 0
    var can_download:Bool = false
    var tracks_natural_ordered:Bool = false
    var updated_at:Int = 0
    var created_at:Int = 0
    
    init() {
        
    }
}


struct ZSVoiceAlbums:HandyJSON {
    var albums:ZSVoiceAlbum = ZSVoiceAlbum()
    var category_id:Int = 0
    var total_page:Int = 0
    var total_count:Int = 0
    var current_page:Int = 0
    var tag_name:String = ""
    
    init() {
        
    }
}
