//
//  ZSHorizonalMoveViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/9.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

enum ZSHorizonalMovePage {
    case none
    case next
    case last
}

class ZSHorizonalMoveViewController: BaseViewController {
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    var pageViewController:PageViewController = PageViewController()
    
    var record:QSRecord = QSRecord()
    
    var contentOffsetX:CGFloat = -1.0;
    
    var pageType:ZSHorizonalMovePage = .none
    
    var pageController:UIPageViewController?
    
    var curlPageStyle:QSTextCurlPageStyle = .forwards

    
    fileprivate lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight)
        layout.minimumLineSpacing = 0.0
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.qs_registerCellClass(ZSHorizonalMoveCell.self)
        collection.dataSource = self
        collection.delegate = self
        collection.isPagingEnabled = true
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        initial()
        setupRecord()
        
//        view.addSubview(collectionView)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
//        collectionView.frame = view.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initial(){
        viewModel.fetchAllResource { resources in
            self.viewModel.fetchAllChapters({ (chapters) in
                if let chapter = self.viewModel.book?.record?.chapterModel,let record = self.viewModel.book?.record {
                    self.viewModel.cachedChapter[chapter.link] = chapter
//                    self.collectionView.reloadData()
//                    let indexPath = IndexPath(item: record.page, section: record.chapter)
//                    self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                } else {
                    self.viewModel.fetchInitialChapter({ (page) in
                        if let record = self.viewModel.book?.record {
//                            self.collectionView.reloadData()
//                            let indexPath = IndexPath(item: record.page, section: record.chapter)
//                            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
                        }
                    })
                }
            })
        }
    }
    
    private func setupPageController(){
        pageController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        pageController?.dataSource = self
        pageController?.delegate = self
        pageController?.isDoubleSided = true
        view.addSubview(pageController!.view)
        addChildViewController(pageController!)
//        pageController?.setViewControllers([initialPageViewController()], direction: .forward, animated: true, completion: nil)
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
}

extension ZSHorizonalMoveViewController:UIPageViewControllerDataSource,UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]){
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool){
        
        if !completed {

        } else {
            // 更新阅读记录
            if curlPageStyle == .forwards {
                
                
            } else if curlPageStyle == .backwards {
                
            }
        }
        
        
        //如果翻页完成，则completed=true，否则为false
        //        isAnimatedFinished = completed//请求数据时根据此字段更新当前页
    }
}

extension ZSHorizonalMoveViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.book?.chaptersInfo?.count ?? 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let key = viewModel.book?.chaptersInfo?[section].link {
            if let model = viewModel.cachedChapter[key] {
                return model.pages.count
            }
        }
        return 1
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.qs_dequeueReusableCell(ZSHorizonalMoveCell.self, for: indexPath)
        // 一次滑动切换cell可能导致几个cell同时请求,所以这个方法中不要改变record的值
        
        viewModel.fetchNextPage(indexPath: indexPath, callback: { (page) in
            cell.pageViewController.page = page
        }) { (page) in
            cell.pageViewController.page = page
            self.collectionView.reloadSections([indexPath.section], animationStyle: .automatic)
        }
//        if pageType == .next {
//            record = viewModel.book?.record ?? record
//            pageType = .none
//            viewModel.fetchNextPage(indexPath: indexPath) { (page) in
//                cell.pageViewController.page = page
//            }
//        }
//        else if pageType == .last {
//            pageType = .none
//            viewModel.fetchLastPage(indexPath: indexPath) { (page) in
//                cell.pageViewController.page = page
//            }
//        }
//        else if pageType == .none {
//            // 一次滑动切换cell可能导致几个cell同时请求,这个时候第一次的请求可以改变record,后面的请求则不能改变record
//            if indexPath.section > record.chapter || indexPath.item > record.page {
//                viewModel.fetchNextPage(indexPath: indexPath) { (page) in
//                    cell.pageViewController.page = page
//                }
//                return cell
//            } else if (indexPath.section < record.chapter || indexPath.item < record.page) {
//                viewModel.fetchLastPage(indexPath: indexPath) { (page) in
//                    cell.pageViewController.page = page
//                }
//                return cell
//            }
//            pageViewController = cell.pageViewController
//            if let record = self.viewModel.book?.record {
//                if let chapterModel = record.chapterModel {
//                    if record.page < chapterModel.pages.count {
//                        pageViewController.page = chapterModel.pages[record.page]
//                    }
//                }
//            }
//        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
        
    }
}

extension ZSHorizonalMoveViewController:UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetX = scrollView.contentOffset.x
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        let velocity = scrollView.panGestureRecognizer.velocity(in: scrollView)
        if velocity.x > 0 {
            // 上一页
            pageType = .last
        } else {
            pageType = .next
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = collectionView.indexPathForItem(at: CGPoint(x: scrollView.contentOffset.x + 1, y: scrollView.contentOffset.y + 1) ) ?? IndexPath(item: 0, section: 0)
        let cell:ZSHorizonalMoveCell = collectionView.cellForItem(at: indexPath) as! ZSHorizonalMoveCell
        pageViewController = cell.pageViewController
        let page = pageViewController.page
        let pageIndex = page?.curPage
        let chapterIndex = page?.curChapter
        record.page = pageIndex ?? indexPath.item
        record.chapter = chapterIndex ?? indexPath.section
        if let key = viewModel.book?.chaptersInfo?[indexPath.section].link {
            if let model = viewModel.cachedChapter[key] {
                record.chapterModel = model
            }
        }
        viewModel.book?.record = record
    }

}

extension ZSHorizonalMoveViewController:ZSReaderControllerProtocol {
    typealias Item = Book
    
}
