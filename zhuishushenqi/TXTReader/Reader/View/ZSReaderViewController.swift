//
//  ZSReaderViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift

protocol ZSReaderControllerProtocol {
    associatedtype Item
    var viewModel:ZSReaderViewModel { get set }
    var pageViewController:PageViewController { get set }
    
}

extension ZSReaderControllerProtocol where Self:UIViewController {
    
}

let changeAnimationStyle = "changeAnimationStyle"

class ZSReaderViewController: BaseViewController  {
    
    var animationStyle:ZSReaderAnimationStyle = QSReaderSetting.shared.pageStyle
    
    var noneAnimationViewController = ZSNoneAnimationViewController()
    
    var horMoveViewController = ZSHorizonalMoveViewController()
    
    var curlPageViewController = QSTextReaderController()
    
    var horMoveController = TXTReaderViewController()
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    let dispose = DisposeBag()
    
    var isToolBarHiden = true
    
    var callback:QSTextCallBack?
    
    var book:BookDetail? {
        didSet{
            viewModel.book = book
        }
    }
    
    var voiceBook:VoiceBook = VoiceBook()
    
    lazy var toolBar:ToolBar = {
        let toolBar:ToolBar = ToolBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        toolBar.isHidden = true
        toolBar.toolBarDelegate = self
        return toolBar;
    }()
    
    lazy var speechView:ZSSpeechView = {
        let speechView = ZSSpeechView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        return speechView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        toolBar.title = viewModel.book?.title ?? ""
        
        if animationStyle == .none {
            setupNoneAnimationController()
        } else if animationStyle == .horMove {
            setupHorMoveAnimationController()
        } else if animationStyle == .curlPage {
            setupCurlPageViewController()
        }
        
        NotificationCenter.default.rx.notification(Notification.Name(rawValue: changeAnimationStyle)).subscribe { (noti) in
//            let style = noti.element?.userInfo
        }.disposed(by: dispose)
        
        NotificationCenter.zs_addObserver(oberver: self, name: PageViewDidTap) {
            self.toolBar.isHidden = false
            self.toolBar.showWithAnimations(animation: true, inView: self.view)
        }
        
        NotificationCenter.qs_addObserver(observer: self, selector: #selector(changePageStyle), name: ZSReaderAnimationStyleChangeNotification, object: nil)
        
        speechView.startHandler = { selected in
            if selected! {
                if self.voiceBook.isSpeaking() {
                    self.voiceBook.stop()
                }
                if self.speechView.speakers.count > self.speechView.speakerPicker.selectedItem {
//                    let appid = "5ba0b197"
//                    let xfyj = "5445f87d"
//                    //        let xfyj2 = "591a4d99"
//                    let initString = "appid=\(xfyj)"
//                    IFlySpeechUtility.createUtility(initString)
                    
                    let speaker = self.speechView.speakers[Int(self.speechView.speakerPicker.selectedItem)]
                    
                    let speakerPath = "\(filePath)\(speaker.name).jet"
                    self.voiceBook.config.speakerPath = speakerPath
                    self.voiceBook.config.voiceID = "\(speaker.speakerId)"
                    
                    self.voiceBook.engineLocal()
                    if let vc = self.curViewController() {
                        if let readerVC = vc as? QSTextReaderController {
                            self.voiceBook.start(sentence: readerVC.currentReaderVC.page?.content ?? "")
                        }
                    }
                    
                } else {
                    let appid = "5ba0b197"
//                    let xfyj = "5445f87d"
                    //        let xfyj2 = "591a4d99"
                    let initString = "appid=\(appid)"
                    IFlySpeechUtility.createUtility(initString)
                    self.voiceBook.engineCloud()
                    if let vc = self.curViewController() {
                        if let readerVC = vc as? QSTextReaderController {
                            self.voiceBook.start(sentence: readerVC.currentReaderVC.page?.content ?? "")
                        }
                    }
                }
            } else {
                self.voiceBook.pause()
            }
        }
        
        speechView.stopHandler = { _ in
            self.speechView.removeFromSuperview()
        }
        
        voiceBook.completeHandler = { error in
            QSLog(error)
            if error?.errorCode == 0 {
                // 读完了,自动翻下一页
                if let vc = self.curViewController() as? QSTextReaderController {
                    
                    vc.viewModel.fetchNextPage { (page) in
                        vc.currentReaderVC.page = page
                        // 这里需要更新阅读记录,否则退出自动阅读后,阅读进度还在开始阅读前
                        vc.viewModel.updateNextRecord { (page) in
                            
                        }
                        self.voiceBook.start(sentence: vc.currentReaderVC.page?.content ?? "")
                    }
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 全局设置
        
    }
    
    @objc
    func changePageStyle() {
        if animationStyle == .none {
            viewModel = noneAnimationViewController.viewModel
        } else if animationStyle == .horMove {
            viewModel = horMoveController.viewModel
        } else if animationStyle == .curlPage {
            viewModel = curlPageViewController.viewModel
        }
        animationStyle = QSReaderSetting.shared.pageStyle
        if animationStyle == .none {
            removeHorMoveAnimationView()
            removeCurlPageViewController()
            setupNoneAnimationController()
        } else if animationStyle == .horMove {
            removeNoneAnimationView()
            removeCurlPageViewController()
            setupHorMoveAnimationController()
        } else if animationStyle == .curlPage {
            removeNoneAnimationView()
            removeHorMoveAnimationView()
            setupCurlPageViewController()
        }
    }

    func setupNoneAnimationController(){
        noneAnimationViewController.viewModel = viewModel
        view.addSubview(noneAnimationViewController.view)
        addChild(noneAnimationViewController)
    }
    
    func setupHorMoveAnimationController(){
        horMoveController.viewModel = viewModel
        view.addSubview(horMoveController.view)
        addChild(horMoveController)
    }
    
    func setupCurlPageViewController(){
        curlPageViewController.viewModel = viewModel
        view.addSubview(curlPageViewController.view)
        addChild(curlPageViewController)
    }
    
    func removeNoneAnimationView(){
        if let _ = noneAnimationViewController.view.superview {
            noneAnimationViewController.view.removeFromSuperview()
        }
    }
    
    func removeHorMoveAnimationView(){
        if let _ = horMoveViewController.view.superview {
            horMoveViewController.view.removeFromSuperview()
        }
    }
    
    func removeCurlPageViewController() {
        if let _ = curlPageViewController.view.superview {
            curlPageViewController.view.removeFromSuperview()
        }
    }
    
    func curBook() ->BookDetail? {
        return curViewModel().book
    }
    
    func curViewController() -> ZSReaderBaseViewController? {
        if QSReaderSetting.shared.pageStyle == .curlPage {
            return curlPageViewController
        }
        return nil
    }
    
    func curViewModel() ->ZSReaderViewModel {
        var viewModel:ZSReaderViewModel!
        if QSReaderSetting.shared.pageStyle == .none {
            viewModel = noneAnimationViewController.viewModel
        } else if QSReaderSetting.shared.pageStyle == .horMove{
            viewModel = horMoveController.viewModel
        } else if QSReaderSetting.shared.pageStyle == .curlPage {
            viewModel = curlPageViewController.viewModel
        }
        return viewModel
    }
    
    //MARK: - statusBar
    override var prefersStatusBarHidden: Bool {
        return isToolBarHiden
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
}

extension ZSReaderViewController:ToolBarDelegate ,QSCategoryDelegate{
    
    func listen() {
        toolBar.hideWithAnimations(animation: false)
        speechView.show()
    }
    
    func backButtonDidClicked() {
        if let book = curBook() {
            
            // 退出时，通常保存阅读记录就行，其它的不需要保存
            let exist = ZSBookManager.shared.existBook(book: book)
            if !exist {
                self.alert(with: "追书提示", message: "是否将本书加入我的收藏", okTitle: "好的", cancelTitle: "不了", okAction: { (action) in
                    ZSBookManager.shared.addBook(book: book)
                    self.dismiss(animated: true, completion: nil)
                }, cancelAction: { (action) in
                    self.dismiss(animated: true, completion: nil)
                })
            }else{
                ZSBookManager.shared.updateBook(book: book)
                self.dismiss(animated: true, completion: nil)
            }
            if let back = callback {
                back(book)
            }
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func catagoryClicked() {
        self.toolBar.hideWithAnimations(animation: true)
        let book = curBook() ?? BookDetail()
        let vc:QSCategoryReaderViewController = QSCategoryRouter.createModule(book: book) as! QSCategoryReaderViewController
        vc.categoryDelegate = self
        vc.viewModel = curViewModel()
//        vc.bookDetail = book
        vc.chapterDict = curViewModel().cachedChapter
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func changeSourceClicked() {
        toolBar.hideWithAnimations(animation: false)
        if QSReaderSetting.shared.pageStyle == .curlPage {
            curlPageViewController.changeSourceClicked()
        } else if QSReaderSetting.shared.pageStyle == .horMove {
            horMoveController.changeSourceClicked()
        } else if QSReaderSetting.shared.pageStyle == .none {
            noneAnimationViewController.changeSourceClicked()
        }
    }
    
    func toolBarDidShow() {
        self.isToolBarHiden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func toolBarDidHidden() {
        self.isToolBarHiden = true
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        })
    }
    
    func readBg(type:Reader) {
        AppStyle.shared.reader = type
        let image = AppStyle.shared.reader.backgroundImage
        if QSReaderSetting.shared.pageStyle == .none {
            self.noneAnimationViewController.pageViewController.bgView.image = image
        } else if QSReaderSetting.shared.pageStyle == .horMove {
            self.horMoveController.readBg(type: type)
        } else if QSReaderSetting.shared.pageStyle == .curlPage {
            self.curlPageViewController.readBg(type: type)
        }
    }
    
    func fontChange(action:ToolBarFontChangeAction) {
        if QSReaderSetting.shared.pageStyle == .curlPage {
            self.curlPageViewController.fontChange(action: action)
        } else if QSReaderSetting.shared.pageStyle == .horMove {
            self.horMoveController.fontChange(action: action)
        }
    }
    
    func brightnessChange(value:CGFloat) {
        
    }
    
    func cacheAll() {
        
    }
    
    func toolbar(toolbar:ToolBar, clickMoreSetting:UIView) {
        let moreVC = QSMoreSettingController()
        toolbar.hideWithAnimations(animation: true)
        let nav = UINavigationController(rootViewController: moreVC)
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - QSCategoryDelegate
    func categoryDidSelectAtIndex(index:Int) {
        if QSReaderSetting.shared.pageStyle == .curlPage {
            curlPageViewController.categoryDidSelectAtIndex(index: index)
        } else if QSReaderSetting.shared.pageStyle == .horMove {
            horMoveController.categoryDidSelectAtIndex(index: index)
        }
    }
}

extension ZSReaderViewController:QSTextViewProtocol{
    var presenter: QSTextPresenterProtocol? {
        get {
            return nil
        }
        set {
            
        }
    }
    
    func showBook(book: QSBook) {
        
    }
    
    func showResources(resources: [ResourceModel]) {
        
    }
    
    func showAllChapter(chapters: [NSDictionary]) {
        
    }
    
    func showChapter(chapter: Dictionary<String, Any>, index: Int) {
        
    }
    
    func showEmpty() {
        
    }
    
    func downloadFinish(book: QSBook) {
        
    }
    
    func showProgress(dict: [String : Any]) {
        
    }
    
    
}
