//
//  ZSWebStoreViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/6.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit

class ZSWebStoreViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ZSWebStoreViewController :ZSWebViewControllerDelegate {
    
}

//#import "BaseViewController.h"
//
//#import "ShareSDKUtilsDelegate-Protocol.h"
//#import "UIActionSheetDelegate-Protocol.h"
//#import "ZSWebViewControllerDelegate-Protocol.h"
//
//@class NSArray, NSString, ShareMessageItem, YJActivityFloatLayerView, ZSWebViewController;
//
//@interface WebStoreViewController : BaseViewController <ShareSDKUtilsDelegate, ZSWebViewControllerDelegate, UIActionSheetDelegate>
//{
//    unsigned long long currentShareType;
//    _Bool shouldAutoSelect;
//    ShareMessageItem *shareItem;
//    NSArray *segmentArray;
//    _Bool briberyShareHasCallBack;
//    _Bool _showSearchBtn;
//    _Bool _isModal;
//    _Bool _needRefreshHongbao;
//    _Bool _hadAddPromoter;
//    int _typeTag;
//    NSString *_viewTitle;
//    NSString *_urlStr;
//    NSString *_booklistId;
//    NSString *_info;
//    ZSWebViewController *_zsWebView;
//      *_activityFloatLayerView;
//}
//
//@property(retain, nonatomic) YJActivityFloatLayerView *activityFloatLayerView; // @synthesize activityFloatLayerView=_activityFloatLayerView;
//@property(nonatomic) _Bool hadAddPromoter; // @synthesize hadAddPromoter=_hadAddPromoter;
//@property(nonatomic) _Bool needRefreshHongbao; // @synthesize needRefreshHongbao=_needRefreshHongbao;
//@property(retain, nonatomic) ZSWebViewController *zsWebView; // @synthesize zsWebView=_zsWebView;
//@property(copy, nonatomic) NSString *info; // @synthesize info=_info;
//@property(nonatomic) _Bool isModal; // @synthesize isModal=_isModal;
//@property(retain, nonatomic) NSString *booklistId; // @synthesize booklistId=_booklistId;
//@property(nonatomic) _Bool showSearchBtn; // @synthesize showSearchBtn=_showSearchBtn;
//@property(nonatomic) int typeTag; // @synthesize typeTag=_typeTag;
//@property(retain, nonatomic) NSString *urlStr; // @synthesize urlStr=_urlStr;
//@property(retain, nonatomic) NSString *viewTitle; // @synthesize viewTitle=_viewTitle;
//- (void).cxx_destruct;
//- (void)geTuiPushOpenURl;
//- (void)webViewDidSetNavBarStyle:(id)arg1;
//- (void)webViewDidTitleShown:(id)arg1;
//- (void)webViewHandleBackEventWithCallBack:(id)arg1;
//- (void)webViewHandlePopEventWithCallBack:(id)arg1;
//- (id)handleShareResult:(unsigned long long)arg1 paramas:(id)arg2;
//- (id)getHongbaoHomeView:(id)arg1;
//- (void)webViewShareStatus:(unsigned long long)arg1 callBack:(id)arg2 parama:(id)arg3;
//- (void)webViewNeedClose:(id)arg1 animated:(_Bool)arg2;
//- (_Bool)needForceSetToFemale;
//- (void)onClickSegment:(id)arg1;
//- (void)collectBookList;
//- (void)onClickFirstRightItem;
//- (void)onClickLeftItem;
//- (void)shareSDKUtilsWillShowBindPhoneView;
//- (void)loginSucceed;
//- (void)actionSheet:(id)arg1 didDismissWithButtonIndex:(long long)arg2;
//- (void)goBackWithAnimated:(_Bool)arg1;
//- (void)resetExclusiveStoreUrlStrWithForceSet:(_Bool)arg1 female:(_Bool)arg2;
//- (void)resetMonthlyUrlStrWithForceSet:(_Bool)arg1 female:(_Bool)arg2;
//- (void)resetViewTitle;
//- (void)appendUrlParam;
//- (void)resetUrlStr;
//- (id)parseQueryStr:(id)arg1;
//- (void)handleShareBack;
//- (void)setPositionIdForLog:(id)arg1;
//- (void)viewWillDisappear:(_Bool)arg1;
//- (void)viewDidLoad;
//- (void)viewDidAppear:(_Bool)arg1;
//- (void)viewWillAppear:(_Bool)arg1;
//- (void)handleUrlWithMainVC:(id)arg1;
//- (void)dealloc;
