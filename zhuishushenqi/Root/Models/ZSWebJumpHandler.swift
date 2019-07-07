//
//  ZSWebJumpHandler.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/6/30.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSWebEventHandlerProtocol {
    static func canHandleWebItem(item:ZSWebItem) ->Bool
    func handleWebItem(item:ZSWebItem, context:ZSWebContext, block:(_ result:String)->Void)
}

class ZSWebJumpHandler: ZSWebEventHandlerProtocol {
    
    var content:ZSWebContext?
    func handleWebItem(item: ZSWebItem, context: ZSWebContext, block: (String) -> Void) {
        self.content = context
        if item.funcName == "jump" {
            jumpToViewWith(item: item)
        } else if item.funcName == "pop" {
            
        } else if item.funcName == "openTaobaoDetail" {
            
        } else if item.funcName == "baseRecharge" {
            
        } else if item.funcName == "openBookstore" {
            
        } else if item.funcName == "openBookshelf" {
            
        } else if item.funcName == "openBindPhone" {
            
        } else if item.funcName == "openBookReview" {
            
        } else if item.funcName == "openSupport" {
            
        } else if item.funcName == "openPayForSignin" {
            
        } else if item.funcName == "jumpToReader" {
            
        } else if item.funcName == "openVideoAd" {
            
        } else if item.funcName == "openWinMoney" {
            
        }
    }
    
    
    static func canHandleWebItem(item:ZSWebItem) ->Bool {
        let items = ["jump","pop","openTaobaoDetail","baseRecharge","openBookstore","openBookshelf","openBindPhone","openBookReview","openSupport","openPayForSignin","jumpToReader","openVideoAd", "openWinMoney"]
        return items.contains(item.funcName ?? "")
    }
    
    func jumpToViewWith(item:ZSWebItem) {
        let jumpType = item.paramDic?["jumpType"] as? String ?? ""
        let pageType = item.paramDic?["pageType"] as? String ?? ""
        let title = item.paramDic?["title"] as? String ?? ""
        var link = item.paramDic?["link"] as? String ?? ""
        let id = item.paramDic?["id"] as? String ?? ""
        let sourceType = item.paramDic?["sourceType"] as? String ?? ""
        let topBar = item.paramDic?["topBar"]
        let navigationBar = item.paramDic?["navigationBar"]
        if let nav = navigationBar {
            
        }
        if link.asNSString().range(of: "platform=").location == NSNotFound {
            let range = link.asNSString().range(of: "?")
            let timeInterval = Date().timeIntervalSince1970
            var queryStr = ""
            if range.location == NSNotFound {
                queryStr = "?platform=ios&timestamp=\(timeInterval)"
            } else {
                queryStr = "&platform=ios&timestamp=\(timeInterval)"
            }
            link = link.appending(queryStr)
        }
        if jumpType == "webview" {
            gotoWebWith(title: title, url: link, navItems: [], navStyle: topBar, pageType: pageType, idValue: id)
        } else if jumpType == "native" {
            var v78 = ""
            var v94 = ""
            var v95 = ""
            if pageType == "bookDetail" {
                gotoBookDetailVCWith(params: item.paramDic, idValue: id, sourceType: sourceType)
                return
            } else if pageType == "listenBook" {
                v78 = "goToVoiceCategoryVC"
            } else if pageType == "login" {
                loginWithWebItem(item: item)
            } else if pageType == "monthlyPay" {
                v78 = "goToMonthPayVC"
            } else if pageType == "baseRecharge" {
                v78 = "goToRechargeVC"
            } else if pageType == "personalCenter" {
                v78 = "goToProfileVC"
            } else if pageType == "tasks" || pageType == "personalinfo" {
                let paramDic = item.paramDic
                let mobile = paramDic?["mobile"]
                //                updateLocalInfo
                //                ZSTasksManager.shared.doTaskWithActionName(name:"fl-bind-phone", completionBlock:nil)
                //                dismissVC 1 0
                
            } else if pageType == "post" {
                gotoTopicDetailVCWith(id: id)
                return
            }
            else if pageType == "bookShortage" {
                v78 = "goToShortageVC"
            } else if pageType == "account" {
                v78 = "goToAccountVC"
            } else if pageType != "search" {
                if pageType == "category" {
                    let paramDic = item.paramDic
                    let href = paramDic?["href"] as? String ?? ""
                    goToCategoryVCWith(url: href)
                    return
                } else if pageType == "createBookList" {
                    v94 = "goToEditBookListVC"
                    //                                go_label_50(v94 v100)
                } else if pageType == "bookShortageQuestion" {
                    v95 = "goToShortageQuestionDetailVCWithIdValue:"
                    //                                go_label_56(v95 v100)
                } else if pageType == "bookShortageAnswer" {
                    v95 = "goToShortageAnswerDetailVCWithIdValue:"
                    //                                go_label_56(v95 v100)
                } else if pageType != "createBookShortageQuestion" {
                    if pageType != "createBookShortageAnswer" {
                        //                                go_label_61
                    } else {
                        v95 = "goToEditShortageAnswerVCWithIdValue:"
                        //                                go_label_56(v95 v100)
                    }
                } else {
                    v94 = "goToEditShortageQuestionVC"
                }
                //                        goto_label_50(perform v94)
            } else {
                v78 = "goToSearchVC"
                gotoSearchVC()
                return
            }
            //        self v78(perform)
        }
        else if jumpType == "safari" {
            if let url = URL(string: link) {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
//        label_61:
        if pageType == "bookReview" {
            //            v95 = "goToReviewVCWithIdValue:"
            //            self v95:id
        } else if pageType == "createBookReview" {
            //            v94 = "goToEditReviewVC"
            //            self v94
        } else if pageType == "communityPersonalHomepage" {
            //            v95 = "goToUserHomePageWithIdValue:"
            //            self v95:id
        } else {
            if pageType == "createPost" {
                goToEditPostVC()
            }
        }
    }
    
    func gotoWebWith(title:String, url:String, navItems:[Any],navStyle:Any, pageType:String, idValue:String) {
        if pageType != "explore" {
            let webVC = ZSWebViewController()
            webVC.webTitle = title
            webVC.url = url
            webVC.hidesBottomBarWhenPushed = true
            currentNav()?.pushViewController(webVC, animated: true)
        }
    }
    
    func currentNav() ->UINavigationController? {
        var nav:UINavigationController?
        if let vc = self.content?.fromVC?.navigationController {
            nav = vc
        } else if let vc = self.content?.delegate as? UIViewController {
            nav = vc.navigationController
        }
        return nav
    }
    
    func gotoBookDetailVCWith(params:[String:Any]?, idValue:String, sourceType:String) {
        let detailVC = QSBookDetailRouter.createModule(id: idValue)
        detailVC.hidesBottomBarWhenPushed = true
        var nav:UINavigationController?
        if let vc = self.content?.fromVC?.navigationController {
            nav = vc
        } else if let vc = self.content?.delegate as? UIViewController {
            nav = vc.navigationController
        }
        nav?.pushViewController(detailVC, animated: true)
    }
    
    func gotoTopicDetailVCWith(id:String) {
        
    }
    
    func goToCategoryVCWith(url:String) {
        let categorySwitch = true
        if categorySwitch {
            // 走原生的分类
            let catelogVC = ZSCatelogViewController()
            catelogVC.hidesBottomBarWhenPushed = true
            currentNav()?.pushViewController(catelogVC, animated: true)
        } else {
            let webVC = ZSWebViewController()
            // setShowSearchBtn:0
            webVC.url = url
            currentNav()?.pushViewController(webVC, animated: true)
        }
    }
    
    func goToEditPostVC() {
        
    }
    
    func loginWithWebItem(item:ZSWebItem) {
        
    }
    
    func gotoSearchVC() {
        let searchVC = ZSSearchViewController()
        searchVC.hidesBottomBarWhenPushed = true
        currentNav()?.pushViewController(searchVC, animated: true)
    }
}
