//
//  ZSNormalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSNormalViewController: BaseViewController, ZSReaderVCProtocol {
    
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
    
    fileprivate var changedPage = false
    
    fileprivate var pageViewController:PageViewController = PageViewController()

    //MARK: - ZSReaderVCProtocol
    static func pageViewController() -> ZSReaderVCProtocol? {
        return nil
    }
    
    func load() {
        guard let oriChapter = viewModel?.originalChapter else { return }
        if oriChapter.pages.count > 0 {
            pageViewController.newPage = oriChapter.pages.first
            initialHistory(chapter: oriChapter)
        } else {
            viewModel?.request(callback: { [weak self] (chapter) in
                self?.pageViewController.newPage = chapter?.pages.first
                if let c = chapter {
                    self?.initialHistory(chapter: c)
                }
            })
        }
    }
    
    func bind(viewModel: ZSReaderBaseViewModel) {
        self.viewModel = viewModel
    }
    
    func pageViewController(_ pageViewController: PageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: PageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: PageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
    }
    
    // Sent when a gesture-initiated transition ends. The 'finished' parameter indicates whether the animation finished, while the 'completed' parameter indicates whether the transition completed or bailed out (if the user let go early).
    func pageViewController(_ pageViewController: PageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
    }
    
    func setupGesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
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
        let chapter = currentChapter()
        guard let history = viewModel?.readHistory else { return }
        guard let page = history.page else { return }
        if let nextP = chapter.getNextPage(page: page) {
            self.pageViewController.newPage = nextP
            history.page = nextP
        } else { // 新章节
            if let nextC = nextChapter() {
                viewModel?.request(chapter: nextC, callback: { [weak self](chapter) in
                    self?.pageViewController.newPage = chapter?.pages.first
                    history.chapter = chapter
                    if chapter?.pages.count ?? 0 > 0 {
                        history.page = chapter!.pages.first
                    }
                })
            }
        }
    }
    
    func lastPage() {
        let chapter = currentChapter()
        guard let history = viewModel?.readHistory else { return }
        guard let page = history.page else { return }
        if let lastP = chapter.getLastPage(page: page) {
            self.pageViewController.newPage = lastP
            history.page = lastP
        } else {
            if let lastC = lastChapter() {
                viewModel?.request(chapter: lastC, callback: { [weak self] (chapter) in
                    self?.pageViewController.newPage = chapter?.pages.last
                    history.chapter = chapter
                    if chapter?.pages.count ?? 0 > 0 {
                        history.page = chapter!.pages.last
                    }
                })
            }
        }
    }
    
    func nextChapter() -> ZSBookChapter? {
        guard let book = viewModel?.model else { return nil }
        guard let chapters = book.chaptersModel as? [ZSBookChapter] else { return nil }
        let currentC = currentChapter()
        let chapterIndex = currentC.chapterIndex
        if chapterIndex + 1 < chapters.count {
            return chapters[chapterIndex + 1]
        }
        return nil
    }
    
    func lastChapter() ->ZSBookChapter? {
        guard let book = viewModel?.model else { return nil }
        guard let chapters = book.chaptersModel as? [ZSBookChapter] else { return nil }
        let currentC = currentChapter()
        let chapterIndex = currentC.chapterIndex
        if (chapterIndex - 1) < chapters.count && (chapterIndex - 1 >= 0) {
            return chapters[chapterIndex - 1]
        }
        return nil
    }
    
    func currentChapter() ->ZSBookChapter {
        guard let chapters = viewModel?.model?.chaptersModel as? [ZSBookChapter], chapters.count > 0 else {
            return ZSBookChapter()
        }
        if let history = viewModel.readHistory {
            if let chapter = history.chapter {
                return chapter
            }
        }
        let chapter = chapters.first!
        if chapter.pages.count == 0 {
            chapter.calPages()
        }
        let history = ZSReadHistory()
        history.chapter = chapter
        history.page = chapter.pages.first
        viewModel.readHistory = history
        return chapter
    }
    
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
    
    func destroy() {
        pageViewController.destroy()
    }
    
    deinit {
        
    }
}
