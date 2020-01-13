//
//  ZSNormalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSNormalViewController: BaseViewController, ZSReaderVCProtocol {
    
    var nextPageHandler: ZSReaderPageHandler?
    var lastPageHandler: ZSReaderPageHandler?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.pageViewController.view.superview != self.view {
            self.pageViewController.view.removeFromSuperview()
            self.addChild(self.pageViewController)
            self.view.addSubview(self.pageViewController.view)
            self.pageViewController.didMove(toParent: self)
            self.setupGesture()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    var viewModel:ZSReaderBaseViewModel!
    
    weak var toolBar:ZSReaderToolbar?
    
    fileprivate var changedPage = false
    
    fileprivate var pageViewController:PageViewController = PageViewController()

    //MARK: - ZSReaderVCProtocol
    func jumpPage(page: ZSBookPage) {
        // 需要注意：1.如果是同一章节，那么page.content为空则不替换
//        guard let newPage = pageViewController.newPage else {
//            pageViewController.newPage = page
//            return
//        }
//        if newPage.chapterUrl == page.chapterUrl && page.content.length == 0  {
//
//        } else {
//            pageViewController.newPage = page
//        }
        pageViewController.newPage = page

    }
    
    func load() {
//        guard let oriChapter = viewModel?.originalChapter else { return }
//        if oriChapter.pages.count > 0 {
//            pageViewController.newPage = oriChapter.pages.first
//            initialHistory(chapter: oriChapter)
//        } else {
//            viewModel?.request(callback: { [weak self] (chapter) in
//                self?.pageViewController.newPage = chapter.pages.first
//                self?.initialHistory(chapter: chapter)
//
//            })
//        }
    }
    
    func bind(viewModel: ZSReaderBaseViewModel) {
        self.viewModel = viewModel
    }
    
    func bind(toolBar: ZSReaderToolbar) {
        self.toolBar = toolBar
    }
    
    func changeBg(style: ZSReaderStyle) {
        pageViewController.bgView.image = style.backgroundImage
    }
    
    func fontChange() {
        guard let book = viewModel.model else { return }
        guard let currentPage = pageViewController.newPage else { return }
        let chapterIndex = currentPage.chapterIndex
        let pageIndex = currentPage.pageIndex
        var chapter:ZSBookChapter?
        if chapterIndex < book.chaptersModel.count {
            chapter = book.chaptersModel[chapterIndex]
            
        } else if book.chaptersModel.count > 0 {
            chapter = book.chaptersModel[0]
        }
        guard let cp = chapter else { return }
        cp.calPages()
        var page:ZSBookPage?
        if pageIndex < cp.pages.count {
            page = cp.pages[pageIndex]
        } else if cp.pages.count > 0 {
            page = cp.pages.first
        }
        guard let p = page else { return }
        guard let history = viewModel?.readHistory else { return }
        history.chapter = cp
        history.page = p
        pageViewController.newPage = p
    }
    
    func setupGesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        toolBar?.show(inView: self.view, true)
    }
            
    @objc func panAction(pan:UIPanGestureRecognizer){
        // x方向滑动超过20就翻页
        let translation:CGPoint = pan.translation(in: self.view)
        
        if pan.state == .changed && !changedPage {
            let offsetX = translation.x
            if offsetX < -20 {
                // 在本次手势结束前都不再响应
                changedPage = true
                nextPage()
            } else if (offsetX > 20) {
                // 在本次手势结束前都不再响应
                changedPage = true
                lastPage()
            }
        } else if pan.state == .ended {
            changedPage = false
        }
    }
    
    func nextPage() {
        nextPageHandler?()
    }
    
    func lastPage() {
        lastPageHandler?()
    }
    
    func destroy() {
        pageViewController.destroy()
    }
    
    deinit {
        
    }
}
