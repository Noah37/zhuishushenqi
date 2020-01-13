//
//  ZSReaderViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

enum ZSReaderType {
    case normal
    case vertical
    case horizonal
    case pageCurl
}

struct ZSReaderPref {
    
    init() {
        switch type {
        case .normal:
            readerVC = ZSNormalViewController()
        case .vertical:
            
            break
        case .horizonal:
            
            break
        case .pageCurl:
            
            break
        }
    }
    
    var type:ZSReaderType = .normal
    var readerVC:ZSReaderVCProtocol?
}

class ZSReaderController: BaseViewController, ZSReaderToolbarDelegate,ZSReaderCatalogViewControllerDelegate {
    
    var pref:ZSReaderPref = ZSReaderPref()
    var viewModel:ZSReaderBaseViewModel = ZSReaderBaseViewModel()
    var reader = ZSReader.share
    var toolBar:ZSReaderToolbar = ZSReaderToolbar(frame: UIScreen.main.bounds)
    var statusBarStyle:UIStatusBarStyle = .lightContent
    var statusBarHiden:Bool = true
    var touchArea:ZSReaderTouchArea = ZSReaderTouchArea(frame: UIScreen.main.bounds)
    
    convenience init(chapter:ZSBookChapter,_ model:ZSAikanParserModel?) {
        self.init()
        viewModel.originalChapter = chapter
        viewModel.model = model
        toolBar.progress(minValue: 0, maxValue: Float(model?.chaptersModel.count ?? 0))
        toolBar.delegate = self
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        changeReaderType()
        //        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let vc = pref.readerVC as? UIViewController {
            vc.view.bounds = view.bounds
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
    }
    
    override func popAction() {
        pref.readerVC?.destroy()
        if let vc = pref.readerVC as? UIViewController {
            vc.willMove(toParent: self)
            vc.view.removeFromSuperview()
            vc.removeFromParent()
        }
        super.popAction()
    }
    
    private func request() {
        // 请求当前章节
        viewModel.request { (_) in
            
        }
    }
    
    private func load() {
        // 首次进入加载
        if let oriChapter = viewModel.originalChapter,oriChapter.pages.count > 0 {
            initialHistory(chapter: oriChapter)
            pref.readerVC?.jumpPage(page: oriChapter.pages.first!)
        } else {
            if let chapter = viewModel.model?.chaptersModel.first {
                initialHistory(chapter: chapter)
                if chapter.pages.count > 0 {
                    pref.readerVC?.jumpPage(page: chapter.pages.first!)
                }
            }
            viewModel.request { [weak self] (chapter) in
                self?.initialHistory(chapter: chapter)
                self?.pref.readerVC?.jumpPage(page: chapter.pages.first!)
            }
        }
    }
    
    private func changeReaderType() {
        if let vc = pref.readerVC as? UIViewController {
            if let _ = vc.view.superview {
                return
            }
            addChild(vc)
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
            touchArea.removeFromSuperview()
            view.addSubview(touchArea)
        }
        view.bringSubviewToFront(touchArea)
        bind()
    }
    
    //MARK: -  page manager
    func bind() {
        pref.readerVC?.nextPageHandler = { [weak self] in
            self?.requestNextPage()
        }
        pref.readerVC?.lastPageHandler = { [weak self] in
            self?.requestLastPage()
        }
    }
    
    func requestLastPage() {
        guard let history = viewModel.readHistory else { return }
        guard let page = history.page else { return }
        let chapter = zs_currentChapter()
        if let lastP = chapter.getLastPage(page: page) {
            // 更新历史记录
            history.page = lastP
            pref.readerVC?.jumpPage(page: lastP)
            return
        }
        // 等于零则说明没有请求到章节内容
        if chapter.pages.count == 0 {
            chapter.calPages()
            // 更新历史记录
            let page = chapter.pages.last!
            history.page = page
            pref.readerVC?.jumpPage(page: page)
            viewModel.request(chapter: chapter) { [weak self] (cp) in
                if cp.pages.count > 0 {
                    let page = cp.pages.last!
                    // 更新历史记录
                    self?.update(history: history, chapter: cp, page: page)
                    // 更新子页面的page
                    self?.pref.readerVC?.jumpPage(page: page)
                }
            }
        } else if let lastChapter = zs_lastChapter() { //否则就是新章节
            if lastChapter.contentNil() {
                // 计算
                lastChapter.calPages()
                let page = lastChapter.pages.last!
                // 更新历史记录
                history.page = page
                history.chapter = lastChapter
                pref.readerVC?.jumpPage(page: page)
                self.viewModel.request(chapter: lastChapter) { [weak self] (cp) in
                    if cp.pages.count > 0 {
                        let page = cp.pages.last!
                        // 更新历史记录
                        self?.update(history: history, chapter: cp, page: page)
                        // 更新子页面的page
                        self?.pref.readerVC?.jumpPage(page: page)
                    }
                }
            } else {
                let page = lastChapter.pages.last!
                history.page = page
                history.chapter = lastChapter
                pref.readerVC?.jumpPage(page: page)
            }
        }
    }
    
    func requestNextPage() {
        guard let history = viewModel.readHistory else { return }
        guard let page = history.page else { return }
        let chapter = zs_currentChapter()
        if let nextP = chapter.getNextPage(page: page) {
            // 更新历史记录
            history.page = nextP
            self.pref.readerVC?.jumpPage(page: nextP)
            return
        }
        // 等于零则说明没有请求到章节内容
        if chapter.pages.count == 0 {
            chapter.calPages()
            // 更新历史记录
            let page = chapter.pages.first!
            history.page = page
            pref.readerVC?.jumpPage(page: page)
            viewModel.request(chapter: chapter) { [weak self] (cp) in
                if cp.pages.count > 0 {
                    let page = cp.pages.first!
                    // 更新历史记录
                    self?.update(history: history, chapter: cp, page: page)
                    // 更新子页面的page
                    self?.pref.readerVC?.jumpPage(page: page)
                }
            }
        } else if let nextChapter = zs_nextChapter() { //否则就是新章节
            if nextChapter.contentNil()  {
                // 计算
                nextChapter.calPages()
                // 更新历史记录
                let page = nextChapter.pages.first!
                history.page = page
                history.chapter = nextChapter
                pref.readerVC?.jumpPage(page: page)
                viewModel.request(chapter: nextChapter) { [weak self] (cp) in
                    if cp.pages.count > 0 {
                        // 更新历史记录
                        self?.update(history: history, chapter: cp, page: page)
                        // 更新子页面的page
                        self?.pref.readerVC?.jumpPage(page: cp.pages.first!)
                    }
                }
            } else {
                // 更新历史记录
                let page = nextChapter.pages.first!
                history.page = page
                history.chapter = nextChapter
                pref.readerVC?.jumpPage(page: page)
            }
        }
    }
    
    //MARK: - history manager
    func initialHistory(chapter:ZSBookChapter) {
        if let history = viewModel.readHistory {
            history.chapter = chapter
            history.page = chapter.pages.first
            viewModel.readHistory = history
        } else {
            let history = ZSReadHistory()
            history.chapter = chapter
            history.page = chapter.pages.first
            viewModel.readHistory = history
        }
    }
    
    func update(history:ZSReadHistory, chapter:ZSBookChapter, page:ZSBookPage) {
        history.chapter = chapter
        history.page = page
    }
    
    
    private func zs_currentChapter() ->ZSBookChapter {
        guard let chapters = viewModel.model?.chaptersModel, chapters.count > 0 else {
            return ZSBookChapter()
        }
        guard let history = viewModel.readHistory else {
            let chapter = chapters.first!
            if chapter.pages.count == 0 {
                chapter.calPages()
            }
            let history = ZSReadHistory()
            history.chapter = chapter
            history.page = chapter.pages.first
            viewModel.readHistory = history
            return chapters.first!
        }
        return history.chapter
    }
    
    private func zs_lastChapter() ->ZSBookChapter? {
        guard let book = viewModel.model else { return nil }
        let chapters = book.chaptersModel
        let currentC = zs_currentChapter()
        let chapterIndex = currentC.chapterIndex
        if (chapterIndex - 1) < chapters.count && (chapterIndex - 1 >= 0) {
            return chapters[chapterIndex - 1]
        }
        return nil
    }
    
    private func zs_nextChapter() -> ZSBookChapter? {
        guard let book = viewModel.model else { return nil }
        let chapters = book.chaptersModel
        let currentC = zs_currentChapter()
        let chapterIndex = currentC.chapterIndex
        if chapterIndex + 1 < chapters.count {
            return chapters[chapterIndex + 1]
        }
        return nil
    }
    
    //MARK: - ZSReaderToolbarDelegate
    func toolBar(toolBar: ZSReaderToolbar, clickBack: UIButton) {
        popAction()
    }
    
    func toolBarWillShow(toolBar: ZSReaderToolbar) {
        statusBarHiden = false
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func toolBarWillHiden(toolBar: ZSReaderToolbar) {
        statusBarHiden = true
        UIView.animate(withDuration: 0.35, animations: {
            self.setNeedsStatusBarAppearanceUpdate()
        }, completion: nil)
    }
    
    func toolBarDidShow(toolBar: ZSReaderToolbar) {
        
    }
    
    func toolBarDidHiden(toolBar: ZSReaderToolbar) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickLast:UIButton) {
        //        pref.readerVC?.lastChapter()
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickNext:UIButton) {
        //        pref.readerVC?.nextChapter()
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickCatalog:UIButton) {
        toolBar.hiden(false)
        let catalogVC = ZSReaderCatalogViewController()
        catalogVC.model = viewModel.model
        //        catalogVC.chapter = pref.readerVC?.currentChapter()
        catalogVC.delegate = self
        navigationController?.pushViewController(catalogVC, animated: true)
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickDark:UIButton) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickSetting:UIButton) {
        
    }
    
    func toolBar(toolBar:ZSReaderToolbar, progress:Float) {
        guard let chapterModels = viewModel.model?.chaptersModel else { return }
        let chapterIndex = Int(progress)
        if chapterIndex >= 0 && chapterIndex < chapterModels.count {
            let chapter = chapterModels[chapterIndex]
            //            pref.readerVC?.chapter(chapter: chapter)
        }
    }
    
    func toolBar(toolBar:ZSReaderToolbar, lightProgress:Float) {
        touchArea.alpah = CGFloat(lightProgress)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, readerStyle: ZSReaderStyle) {
        pref.readerVC?.changeBg(style: readerStyle)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, fontAdd: UIButton) {
        if ZSReader.share.theme.fontSize.enableBigger {
            ZSReader.share.theme.fontSize.bigger()
            pref.readerVC?.fontChange()
        }
        let enableFontAdd = ZSReader.share.theme.fontSize.enableBigger
        let enableFontPlus = ZSReader.share.theme.fontSize.enableSmaller
        toolBar.enablFontAdd(enableFontAdd)
        toolBar.enableFontPlus(enableFontPlus)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, fontPlus: UIButton) {
        if ZSReader.share.theme.fontSize.enableSmaller {
            ZSReader.share.theme.fontSize.smaller()
            pref.readerVC?.fontChange()
        }
        let enableFontAdd = ZSReader.share.theme.fontSize.enableBigger
        let enableFontPlus = ZSReader.share.theme.fontSize.enableSmaller
        toolBar.enablFontAdd(enableFontAdd)
        toolBar.enableFontPlus(enableFontPlus)
    }
    
    //MARK: - ZSReaderCatalogViewControllerDelegate
    func catalog(catalog: ZSReaderCatalogViewController, clickChapter: ZSBookChapter) {
        //        pref.readerVC?.chapter(chapter: clickChapter)
        //        pref.readerVC?.jumpPage(page: clickChapter.)
    }
    
    //MARK: - system
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    override var prefersStatusBarHidden: Bool {
        return statusBarHiden
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    deinit {
        
    }
}
