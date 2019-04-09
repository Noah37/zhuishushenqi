//
//  XMSDKInfo.h
//  libXMOpenPlatform
//
//  Created by colton.cai on 15/4/30.
//  Copyright (c) 2015年 ximalaya. All rights reserved.
//

#ifndef libXMOpenPlatform_XMSDKInfo_h
#define libXMOpenPlatform_XMSDKInfo_h


/**
 *  喜马拉雅请求类型
 */
typedef NS_ENUM(NSInteger, XMReqType){
    //点播接口
    /** 喜马拉雅内容分类 */
    XMReqType_CategoriesList = 0,
    /** 获取专辑或声音的标签 */
    XMReqType_TagsList,
    //根据分类和标签获取某个分类某个标签下的热门专辑列表/最新专辑列表/最多播放专辑列表
    XMReqType_AlbumsList,
    /** 根据专辑ID获取专辑下的声音列表，即专辑浏览 */
    XMReqType_AlbumsBrowse,
    /** 批量获取专辑列表 */
    XMReqType_AlbumsBatch,
    /** 根据专辑ID列表获取批量专辑更新提醒信息列表 */
    XMReqType_AlbumsUpdateBatch,
    /** 根据分类和标签获取某个分类下某个标签的热门声音列表 */
    XMReqType_TracksHot,
    /** 批量获取声音 */
    XMReqType_TracksBatch,
    /** 根据上一次所听声音的id，获取从那条声音开始往前一页声音。 */
    XMReqType_TrackGetLastPlay,
    
    /** 获取某个分类下的元数据列表 */
    XMReqType_MetadataList,
    /** 获取某个分类的元数据属性键值组合下包含的热门专辑列表/最新专辑列表/最多播放专辑列表 */
    XMReqType_MetadataAlbums,
    
    
    //直播接口
    /** 获取直播省份列表 */
    XMReqType_LiveProvince,
    /** 获取直播电台列表 */
    XMReqType_LiveRadio,
    /** 获取直播节目列表 */
    XMReqType_LiveSchedule,
    /** 获取当前直播的节目 */
    XMReqType_LiveProgram,
    XMReqType_LiveCity,
    XMReqType_LiveRadioOfCity,
    XMReqType_LiveRadioByID,
    
    /** 获取直播电台分类 */
    XMReqType_LiveRadioCategories,
    /** 根据分类获取直播电台数据 */
    XMReqType_LiveGetRadiosByCategory,
    
    //搜索接口
    /** 搜索获取专辑列表 */
    XMReqType_SearchAlbums,
    /** 搜索获取声音列表 */
    XMReqType_SearchTracks,
    /** 获取最新热搜词 */
    XMReqType_SearchHotWords,
    /** 获取某个关键词的联想词 */
    XMReqType_SearchSuggestWords,
    /** 搜索获取电台列表 */
    XMReqType_SearchRadios,
    /** 获取指定数量直播，声音，专辑的内容 */
    XMReqType_SearchAll,
    /** 搜索获取主播列表 */
    XMReqType_SearchAnnouncers,
    
    
    //推荐接口
    /** 获取某个专辑的相关推荐。 */
    XMReqType_AlbumsRelative,
    //获取某个声音列表的相关专辑
    XMReqType_TracksRelativeAlbum,
    /** 获取下载听模块的推荐下载专辑 */
    XMReqType_AlbumsRecommendDownload,
    //猜你喜欢
    XMReqType_AlbumsGuessLike,
    //获取运营人员在发现页配置的分类维度专辑推荐模块的列表
    XMReqType_DiscoveryRecommendAlbums,
    //获取运营人员为某个分类配置的标签维度专辑推荐模块列表
    XMReqType_CategoryRecommendAlbums,
    //获取儿童版猜你喜欢专辑列表
    XMReqType_StoryMachineGuessLikeAlbums,
    
    //榜单接口
    /** 根据榜单类型获取榜单首页的榜单列表 */
    XMReqType_RankList,
    /** 根据rank_key获取某个榜单下的专辑列表 */
    XMReqType_RankAlbum,
    /** 根据rank_key获取某个榜单下的声音列表 */
    XMReqType_RankTrack,
    /** 获取直播电台排行榜 */
    XMReqType_RankRadio,
    
    
    //听单接口
    /** 获取精品听单列表 */
    XMReqType_ColumnList,
    /** 获取某个听单详情，每个听单包含听单简介信息和专辑或声音的列表 */
    XMReqType_ColumnDetail,
    
    
    //焦点图接口
    /** 获取榜单的焦点图列表 */
    XMReqType_RankBanner,
    /** 获取发现页推荐的焦点图列表 */
    XMReqType_DiscoveryBanner,
    /** 获取分类推荐的焦点图列表 */
    XMReqType_CategoryBanner,
    
    
    //冷启动接口
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootGenRes,
    /** 获取冷启动二级分类 */
    XMReqType_ColdbootSubGenRes,
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootTag,
    /** 获取冷启动二级分类 */
    XMReqType_ColdbootSubmitTag,
    /** 获取冷启动一级分类 */
    XMReqType_ColdbootDetail,
    
    
    //主播接口
    //获取喜马拉雅主播分类
    XMReqType_AnnouncerCategory,
    //获取某个分类下的主播列表
    XMReqType_AnnouncerList,
    //批量获取主播列表
    XMReqType_AnnouncersBatch,
    //获取某个主播下的专辑列表
    XMReqType_AlbumsByAnnouncer,
    
    //获取某个主播下的声音列表
    XMReqType_TracksByAnnouncer,
    
    //定制化接口
    /** 获取为合作方定制化接口 */
    XMReqType_CustomizedCategory,
    /** 获取为合作方定制化的声音列表 */
    XMReqType_CustomizedTrack,
    
    /** 获取合作方自定制的专辑类听单 */
    XMReqType_CustomizedAlbumColumns,
    /** 获取合作方自定制的专辑类听单 */
    XMReqType_CustomizedTrackColumns,
    /** 获取自定义专辑听单内容详情 */
    XMReqType_CustomizedAlbumColumnDetail,
    /** 获取自定义声音听单内容详情 */
    XMReqType_CustomizedTrackColumnDetail,
    /** 搜索自定义声音听单下的声音列表 */
    XMReqType_CustomizedSearchTracks,
    /** 获取自定义声音详情 */
    XMReqType_CustomizedTrackDetail,
    /** 搜索所有专辑或声音听单 */
    XMReqType_CustomizedSearchAlbumsOrTrackColumns,
    
    //配置接口
    XMReqType_appConfig,
    
    //付费接口
    /** 获取所有付费专辑 */
    XMReqType_AllPaidAlbums,
    /** 获取付费精品分类下的标签列表 */
    XMReqType_Tags,
    /** 获取热门付费专辑列表 */
    XMReqType_PaidAlbumsByTag,
    /** 分页获取付费专辑下的声音列表 */
    XMReqType_BrowsePaidAlbumTracks,
    /** 批量根据付费专辑ID获取付费专辑详情 */
    XMReqType_BatchGetPaidAlbums,
    /** 根据声音ID获取付费声音详情 */
    XMReqType_BatchGetPaidTracks,
    /** 获取所有付费内容排行榜基础信息 */
    XMReqType_PaidContentRanks,
    /** 根据rank_key分页获取某个付费专辑排行榜下的付费专辑列表 */
    XMReqType_RankAlbums,
    /** 获取用户购买过的所有付费专辑 */
    XMReqType_GetBoughtAlbums,
    /** 根据用户ID和一批付费专辑ID获取用户对这批付费专辑的购买状态  */
    XMReqType_AlbumBoughtStatus,
    /** 根据用户ID和一批付费声音ID获取用户对这批付费声音的购买状态  */
    XMReqType_TrackBoughtStatus,
    /** 根据关键词搜索付费专辑 */
    XMReqType_SearchPaidAlbums,
    /** 根据关键词搜索付费声音 */
    XMReqType_SearchPaidTracks,
    /** 实时获取专辑的价格信息 */
    XMReqType_GetPriceInfo,
    /** 根据订单号获取支付url */
    XMReqType_GetPayUrl,
    
    // 用户隐私数据API接口
    /** 获取当前登陆的喜马拉雅用户的基本信息 */
    XMReqType_UserInfo,
    /** 获取当前登陆的喜马拉雅用户的画像数据*/
    XMReqType_Persona,
    
    //用户播放历史接口
    /** 根据用户ID获取用户播放云历史记录 */
    XMReqType_PlayHistoryGetByUid,
    /** 用户上传播放云历史记录 */
    XMReqType_PlayHistoryUpload,
    /** 用户批量上传播放云历史记录 */
    XMReqType_PlayHistoryBatchUpload,
    /** 用户批量删除播放云历史记录 */
    XMReqType_PlayHistoryBatchDelete,
    
    //用户订阅接口
    /** 获取喜马拉雅用户的动态更新的订阅专辑列表 */
    XMReqType_SubscribeGetAlbumsByUid,
    /** 用户新增或取消已订阅专辑 */
    XMReqType_SubscribeAddOrDelete,
    /** 用户批量新增已订阅专辑 */
    XMReqType_SubscribeBatchAdd,
    
};

#endif
