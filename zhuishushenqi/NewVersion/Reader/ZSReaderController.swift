//
//  ZSReaderViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

struct ZSReaderPref {
    
    static let leftFrame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height)
    static let centerFrame = CGRect(x: UIScreen.main.bounds.width/3, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height)

    static let rightFrame = CGRect(x: UIScreen.main.bounds.width*2.0/3, y: 0, width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.height)

    
    init() {
        switch type {
        case .normal:
            readerVC = ZSNormalViewController()
        case .vertical:
            break
        case .horizonal:
            readerVC = ZSHorizonalViewController()
            break
        case .pageCurl:
            readerVC = ZSPageViewController()
            break
        }
    }
    
    var type:ZSReaderPageStyle {
        get {
            return ZSReader.share.pageStyle
        }
    }
    var readerVC:ZSReaderVCProtocol?
    var bookType:ZSReaderBookStyle = .online
    mutating func change() {
        switch type {
        case .normal:
            readerVC = ZSNormalViewController()
        case .vertical:
            break
        case .horizonal:
            readerVC = ZSHorizonalViewController()
            break
        case .pageCurl:
            readerVC = ZSPageViewController()
            break
        }
    }
}

class ZSReaderController: BaseViewController, ZSReaderToolbarDelegate,ZSReaderCatalogViewControllerDelegate,ZSReaderTouchAreaDelegate, UIGestureRecognizerDelegate {
    
    var pref:ZSReaderPref = ZSReaderPref()
    var viewModel:ZSReaderBaseViewModel = ZSReaderBaseViewModel()
    var reader = ZSReader.share
    var toolBar:ZSReaderToolbar = ZSReaderToolbar(frame: UIScreen.main.bounds)
    var statusBarStyle:UIStatusBarStyle = .lightContent
    var statusBarHiden:Bool = true
    var touchArea:ZSReaderTouchArea = ZSReaderTouchArea(frame: UIScreen.main.bounds)
    
    convenience init(chapter:ZSBookChapter?,_ model:ZSAikanParserModel, bookType:ZSReaderBookStyle = .online) {
        self.init()
        viewModel.originalChapter = chapter
        viewModel.model = model
        toolBar.progress(minValue: 0, maxValue: Float(model.chaptersModel.count))
        toolBar.delegate = self
        touchArea.delegate = self
        pref.bookType = bookType
        load()
    }
    
    convenience init(chapter:ZSBookChapter?,_ model:ZSAikanParserModel) {
        self.init()
        viewModel.originalChapter = chapter
        viewModel.model = model
        toolBar.progress(minValue: 0, maxValue: Float(model.chaptersModel.count))
        toolBar.delegate = self
        touchArea.delegate = self
        load()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGesture:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        view.addGestureRecognizer(tapGesture)
        changeReaderType()
        updateHistory()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
        if let vc = pref.readerVC as? UIViewController {
            vc.view.bounds = view.bounds
        }
        if let horVC = pref.readerVC as? ZSHorizonalViewController {
            horVC.dataSource = self
            horVC.delegate = self
        }
        if let horVC = pref.readerVC as? ZSPageViewController {
            horVC.dataSource = self
            horVC.delegate = self
        }
        pref.readerVC?.bind(toolBar: toolBar)
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
        ZSBookMemoryCache.share.removeAllCache()
        super.popAction()
    }
    
    private func request() {
        // 请求当前章节
        viewModel.request { (_) in
            
        }
    }
    
    private func load() {
        // 首次进入加载
        if let oriChapter = viewModel.originalChapter {
            oriChapter.calPages()
            initialHistory(chapter: oriChapter)
            update(history: viewModel.readHistory!, chapter: oriChapter, page: oriChapter.pages.first!)
            pref.readerVC?.jumpPage(page: oriChapter.pages.first!, false, .forward)
            if oriChapter.contentNil() {
                viewModel.request(chapter: oriChapter) { [unowned self] (cp,type) in
                    // 比较当前章节与阅读记录中如果不同，说明请求完之前已经翻页了，不再跳转
                    cp.calPages()
                    if cp.chapterUrl == oriChapter.chapterUrl {
                        self.update(history: self.viewModel.readHistory!, chapter: cp, page: cp.pages.first!)
                        self.pref.readerVC?.jumpPage(page: cp.pages.first!,false, .forward)
                    }
                }
            }
        } else if let history = viewModel.readHistory {
            pref.readerVC?.jumpPage(page: history.page, false, .forward)
        }
        else {
            guard let chapter = viewModel.model?.chaptersModel.first else { return }
            if chapter.contentNil() {
                chapter.calPages()
            }
            initialHistory(chapter: chapter)
            update(history: viewModel.readHistory!, chapter: chapter, page: chapter.pages.first!)
            pref.readerVC?.jumpPage(page: chapter.pages.first!, false, .forward)
            viewModel.request(chapter: chapter) { [unowned self] (cp,type) in
                // 比较当前章节与阅读记录中如果不同，说明请求完之前已经翻页了，不再跳转
                cp.calPages()
                if cp.chapterUrl == chapter.chapterUrl {
                    self.update(history: self.viewModel.readHistory!, chapter: cp, page: cp.pages.first!)
                    self.pref.readerVC?.jumpPage(page: cp.pages.first!, false, .forward)
                }
            }
        }
    }
    
    private func changeReaderType(_ change:Bool=false) {
        if change {
            pref.change()
            if let history = viewModel.readHistory {
                pref.readerVC?.jumpPage(page: history.page, false, .forward)
            }
            if let horVC = pref.readerVC as? ZSHorizonalViewController {
                horVC.dataSource = self
                horVC.delegate = self
            }
            if let horVC = pref.readerVC as? ZSPageViewController {
                horVC.dataSource = self
                horVC.delegate = self
            }
        }
        if let vc = pref.readerVC as? UIViewController {
            if let _ = vc.view.superview {
                return
            }
            addChild(vc)
            view.addSubview(vc.view)
            vc.didMove(toParent: self)
            touchArea.removeFromSuperview()
            view.addSubview(touchArea)
            view.bringSubviewToFront(touchArea)
            vc.view.bounds = view.bounds
        }
        bind()
    }
    
    private func updateHistory() {
        viewModel.bookReload { [weak self] in
            if let history = self?.viewModel.readHistory {
                self?.pref.readerVC?.jumpPage(page: history.page, false, .forward)
            }
        }
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        let point = tap.location(in: view)
        let windowPoint = view.convert(point, to: view.window!)
        if ZSReaderPref.leftFrame.contains(windowPoint) {
            showLastPage()
        } else if ZSReaderPref.rightFrame.contains(windowPoint) {
            showNextPage()
        } else {
            toolBar.show(inView: view.window!, true)
        }
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
    
    func request(chapter:ZSBookChapter, callback:ZSReaderTypeCallback<ZSBookChapter, ZSChapterType>?) {
        viewModel.request(chapter: chapter) { (cp, type) in
            if cp.pages.count > 0 {
                callback?(cp, type)
            }
        }
    }
    
    func requestLastPage() {
        guard let history = viewModel.readHistory else { return }
        guard let page = history.page else { return }
        let chapter = zs_currentChapter()
        if let lastP = chapter.getLastPage(page: page) {
            show(chapter: chapter, lastP)
            return
        }
        if let lastChapter = zs_lastChapter() { //新章节
            show(chapter: lastChapter, nil, false)
        }
    }
    
    func requestNextPage() {
        guard let history = viewModel.readHistory else { return }
        guard let page = history.page else { return }
        let chapter = zs_currentChapter()
        if let nextP = chapter.getNextPage(page: page) {
            show(chapter: chapter, nextP)
            return
        }
        if let nextChapter = zs_nextChapter() { //新章节
            show(chapter: nextChapter, nil)
        }
    }
    
    //MARK: - history manager
    func initialHistory(chapter:ZSBookChapter) {
        chapter.calPages()
        if let _ = viewModel.readHistory {
            
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
    
    //MARK: - chapter manage
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
        // 可能存在修改字体大小等因素，因此重新计算
        history.chapter.calPages()
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
    
    func fontChange() {
        guard let history = viewModel.readHistory else { return }
        guard let chapter = history.chapter else { return }
        chapter.calPages()
        show(chapter: chapter, nil)
    }
    
    func showLastPage() {
        guard let history = viewModel.readHistory else { return }
        let chapter = zs_currentChapter()
        if let lastPage = chapter.getLastPage(page: history.page) {
            if let _ = pref.readerVC as? ZSPageViewController {
                pref.readerVC?.jumpPage(page: lastPage, false, .reverse)
            } else if let _ = pref.readerVC as? ZSHorizonalViewController {
                pref.readerVC?.jumpPage(page: lastPage, true, .reverse)
            }
            update(history: history, chapter: chapter, page: lastPage)
        } else if let lastChapter = zs_lastChapter() { // 新章节
            show(chapter: lastChapter, nil, false, true, .reverse)
        }
    }
 
    func showNextPage() {
        guard let history = viewModel.readHistory else { return }
        let chapter = zs_currentChapter()
        if let nextPage = chapter.getNextPage(page: history.page) {
            update(history: history, chapter: chapter, page: nextPage)
            if let _ = pref.readerVC as? ZSPageViewController {
                pref.readerVC?.jumpPage(page: nextPage, false, .forward)
            } else if let _ = pref.readerVC as? ZSHorizonalViewController {
                pref.readerVC?.jumpPage(page: nextPage, true, .forward)
            }
        } else if let nextChapter = zs_nextChapter() { // 新章节
            show(chapter: nextChapter, nil, true, true, .forward)
        }
    }
    
    func show(chapter:ZSBookChapter,_ direction:UIPageViewController.NavigationDirection = .forward,_ first:Bool = true) {
        guard let history = viewModel.readHistory else { return }
        if chapter.pages.count > 0 {
            let page = first ? chapter.pages.first!:chapter.pages.last!
            update(history: history, chapter: chapter, page: page)
            pref.readerVC?.jumpPage(page: page, false, direction)
        }
    }
    
    func show(chapter:ZSBookChapter,_ page:ZSBookPage? = nil,_ next:Bool = true,_ animated:Bool = false,_ direction:UIPageViewController.NavigationDirection = .forward) {
        guard let history = viewModel.readHistory else { return }
        if let p = page {
            pref.readerVC?.jumpPage(page: p, animated, direction)
            update(history: history, chapter: chapter, page: p)
        } else if !chapter.contentNil(){
            let page = next ? chapter.pages.first!:chapter.pages.last!
            pref.readerVC?.jumpPage(page: page, animated, direction)
            update(history: history, chapter: chapter, page: page)
        } else {
            // 计算
            chapter.calPages()
            // 更新历史记录
            let page = chapter.pages.first!
            pref.readerVC?.jumpPage(page: page, animated, direction)
            update(history: history, chapter: chapter, page: page)
            request(chapter: chapter) { [weak self] (cp,type) in
                let first = next ? true:(type == .online ? true:false)
                self?.show(chapter: cp, direction, first)
            }
        }
    }
    
    //MARK: - ZSReaderTouchAreaDelegate
    func touchAreaTapCenter(touchAres: ZSReaderTouchArea) {
        if toolBar.isToolBarShow {
            toolBar.hiden(true)
        } else {
            toolBar.show(inView: view, true)
        }
    }
    
    //MARK: - ZSReaderToolbarDelegate
    func toolBar(toolBar: ZSReaderToolbar, clickBack: UIButton) {
        popAction()
        viewModel.saveHistory()
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
        if let chapter = zs_lastChapter() {
            show(chapter: chapter, nil)
        }
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickNext:UIButton) {
        if let chapter = zs_nextChapter() {
            show(chapter: chapter, nil)
        }
    }
    
    func toolBar(toolBar:ZSReaderToolbar, clickCatalog:UIButton) {
        toolBar.hiden(false)
        let catalogVC = ZSReaderCatalogViewController()
        catalogVC.model = viewModel.model
        catalogVC.chapter = zs_currentChapter()
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
            show(chapter: chapter, nil)
        }
    }
    
    func toolBar(toolBar:ZSReaderToolbar, lightProgress:Float) {
        touchArea.alpah = CGFloat(lightProgress)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, readerStyle: ZSReaderStyle) {
        ZSReader.share.theme.readerStyle = readerStyle
        pref.readerVC?.changeBg(style: readerStyle)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, fontAdd: UIButton) {
        if ZSReader.share.theme.fontSize.enableBigger {
            ZSReader.share.theme.fontSize.bigger()
            fontChange()
        }
        let enableFontAdd = ZSReader.share.theme.fontSize.enableBigger
        let enableFontPlus = ZSReader.share.theme.fontSize.enableSmaller
        toolBar.enablFontAdd(enableFontAdd)
        toolBar.enableFontPlus(enableFontPlus)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, fontPlus: UIButton) {
        if ZSReader.share.theme.fontSize.enableSmaller {
            ZSReader.share.theme.fontSize.smaller()
            fontChange()
        }
        let enableFontAdd = ZSReader.share.theme.fontSize.enableBigger
        let enableFontPlus = ZSReader.share.theme.fontSize.enableSmaller
        toolBar.enablFontAdd(enableFontAdd)
        toolBar.enableFontPlus(enableFontPlus)
    }
    
    func toolBar(toolBar: ZSReaderToolbar, animationStyle: UIButton) {

    }
    
    func toolBar(toolBar:ZSReaderToolbar, select style:ZSReaderPageStyle) {
        changeReaderType(true)
    }
    
    func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
    
    //MARK: - ZSReaderCatalogViewControllerDelegate
    func catalog(catalog: ZSReaderCatalogViewController, clickChapter: ZSBookChapter) {
        show(chapter: clickChapter, nil)
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
    
    func showPage(chapter:ZSBookChapter, _ page:ZSBookPage? = nil,_ first:Bool = true, handler:ZSReaderBaseCallback<ZSBookPage>?) {
        if let p = page {
            handler?(p)
        } else if !chapter.contentNil(){
            // 修改字体大小后需重新计算
            chapter.calPages()
            let page = first ? chapter.pages.first!:chapter.pages.last!
            handler?(page)
        } else {
            // 计算
            chapter.calPages()
            // 更新历史记录
            let page = chapter.pages.first!
            handler?(page)
            request(chapter: chapter) { (cp,type) in
                cp.calPages()
                let p = first ? cp.pages.first!:cp.pages.last!
                handler?(p)
            }
        }
    }
}

extension ZSReaderController:UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let pageVC = PageViewController()
        guard let history = viewModel.readHistory else { return nil }
        guard let page = history.page else { return nil }
        let chapter = zs_currentChapter()
        if let lastP = chapter.getLastPage(page: page) {
            showPage(chapter: chapter, lastP, false) { (p) in
                pageVC.newPage = p
            }
        } else if let lastChapter = zs_lastChapter() { //新章节
            showPage(chapter: lastChapter, nil, false) { (p) in
                pageVC.newPage = p
            }
        } else {
            return nil
        }
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let pageVC = PageViewController()
        guard let history = viewModel.readHistory else { return nil }
        guard let page = history.page else { return nil }
        let chapter = zs_currentChapter()
        if let lastP = chapter.getNextPage(page: page) {
            showPage(chapter: chapter, lastP, true) { (p) in
                pageVC.newPage = p 
            }
        } else if let lastChapter = zs_nextChapter() { //新章节
            showPage(chapter: lastChapter, nil, true) { (p) in
                pageVC.newPage = p
            }
        } else {
            return nil
        }
        return pageVC
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        if completed {
            // 动画完成需要更新阅读记录
            if let pageVC = pageViewController.viewControllers?.first as? PageViewController {
                if let page = pageVC.newPage {
                    QSLog("\(page.chapterName),page: \(page.pageIndex)")
                    guard let history = viewModel.readHistory else { return }
                    guard let book = viewModel.model else { return }
                    // 获取当前章节
                    let chapterIndex = page.chapterIndex
                    if chapterIndex >= 0 && chapterIndex < book.chaptersModel.count {
                        let chapter = book.chaptersModel[chapterIndex]
                        // chapter存在会立即返回,r如果不存在，则只有一页，直接进入下一章
                        update(history: history, chapter: chapter, page: page)
                        request(chapter: chapter) { [weak self] (cp,type) in
                            self?.update(history: history, chapter: cp, page: page)
                        }
                    }
                }
            }
        }
    }
    
}
