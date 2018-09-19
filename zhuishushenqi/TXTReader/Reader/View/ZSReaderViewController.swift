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
    
    lazy var toolBar:ToolBar = {
        let toolBar:ToolBar = ToolBar(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        toolBar.isHidden = true
        toolBar.toolBarDelegate = self
        return toolBar;
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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 全局设置
        
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
        noneAnimationViewController.view.removeFromSuperview()
    }
    
    func removeHorMoveAnimationView(){
        horMoveViewController.view.removeFromSuperview()
    }
    
    func curBook() ->BookDetail? {
        return curViewModel().book
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
    func backButtonDidClicked() {
        let book = curBook()
        // 退出时，通常保存阅读记录就行，其它的不需要保存
        let exist = BookManager.shared.bookExist(book:book)
        if !exist {
            self.alert(with: "追书提示", message: "是否将本书加入我的收藏", okTitle: "好的", cancelTitle: "不了", okAction: { (action) in
                if let tmpBook = book {
                    BookManager.shared.modifyBookshelf(book: tmpBook)
                }
                self.dismiss(animated: true, completion: nil)
            }, cancelAction: { (action) in
                self.dismiss(animated: true, completion: nil)
            })
        }else{
            if let tmpBook = book {
                BookManager.shared.modifyRecord(tmpBook, tmpBook.record?.chapter, tmpBook.record?.page)
            }
            self.dismiss(animated: true, completion: nil)
        }
        if let back = callback {
            if let tmpBook = book {
                back(tmpBook)
            }
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

extension ZSReaderViewController:ZSReaderControllerProtocol {
    typealias Item = Book
    
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
