//
//  ZSNoneAnimationViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/7/3.
//  Copyright © 2018年 QS. All rights reserved.
// 无动画阅读控制器,管理手势,左滑手势显示下一页,右滑手势显示上一页,或者点击左侧右侧屏幕显示下一页,点击左侧屏幕显示上一页

import UIKit

class ZSNoneAnimationViewController: UIViewController {
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    var pageViewController:PageViewController = PageViewController()
    
    var record:QSRecord = QSRecord()
    
    var cachedChapter:[String:QSChapter] = [:]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRecord()
        setupSubviews()
        setupGesture()
    }
    
    func setupRecord(){
        // 第一次进入没有record,初始化一个record
        if let book = viewModel.book {
            record.bookId = book._id
            if book.record == nil {
                book.record = record
            }
        }
    }
    
    func setupSubviews(){
        view.addSubview(pageViewController.view)
    }
    
    func setupGesture(){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(panAction))
        view.addGestureRecognizer(pan)
    }
    
    @objc func panAction(pan:UIPanGestureRecognizer){
        // x方向滑动超过20就翻页
        
        let translation:CGPoint = pan.translation(in: self.view)
        
        if pan.state == .changed {
            let offsetX = translation.x
            if offsetX > 20 {
                
            }
        }
    }
    
    // 获取下一个页面
    func getNextPage(){
        //2.获取当前阅读的章节与页码,这里由于是网络小说,有几种情况
        //(1).当前章节信息为空,那么这一章只有一页,翻页直接进入了下一页,章节加一
        //(2).当前章节信息不为空,说明已经请求成功了,那么计算当前页码是否为该章节的最后一页
        //这是2(2)
        if let chapterModel = record.chapterModel {
            let page = record.page
            if page < chapterModel.pages.count - 1 {
                let pageIndex = record.page + 1
                let pageModel = chapterModel.pages[pageIndex]
                pageViewController.page = pageModel
            } else { // 新的章节
                getNewChapter()
            }
        } else {
            getNewChapter()
        }
    }
    
    func getLastPage(){
        if let _ = record.chapterModel {
            let page = record.page
            if page > 0 {
                
            }
        }
        
    }
    
    func getNewChapter(){
        let chapter = record.chapter + 1
        if chapter < (viewModel.book?.chaptersInfo?.count ?? 0) {
            if let chapterInfo = viewModel.book?.chaptersInfo?[chapter] {
                let link = chapterInfo.link
                // 内存缓存
                if let model =  cachedChapter[link] {
                    pageViewController.page = model.pages.first
                } else {
                    viewModel.fetchChapter(key: link, { (body) in
                        if let bodyInfo = body {
                            if let network = self.cacheChapter(body: bodyInfo, index: chapter) {
                                self.pageViewController.page = network.pages.first
                            }
                        }
                    })
                }
            }
        }
    }
    
    // 将新获取的章节信息存入chapterDict中
    @discardableResult
    func cacheChapter(body:ZSChapterBody,index:Int)->QSChapter?{
        let chapterModel = viewModel.book?.chaptersInfo?[index]
        let qsChapter = QSChapter()
        if let link = chapterModel?.link {
            qsChapter.link = link
            // 如果使用追书正版书源，取的字段应该是cpContent，需要根据当前选择的源进行判断
            if let _ = chapterModel?.order  {
                qsChapter.content = body.cpContent

            } else {
                qsChapter.content = body.body
            }
            if let title = chapterModel?.title {
                qsChapter.title = title
            }
            qsChapter.curChapter = index
            qsChapter.getPages() // 直接计算page
            cachedChapter[link] = qsChapter
            return qsChapter
        }
        return nil
    }
    
}

extension ZSNoneAnimationViewController:ZSReaderTap{
    func showLastPage(page:QSPage) {
        pageViewController.page = page
    }
    
    func showNextPage(page:QSPage) {
        pageViewController.page = page
    }
}
