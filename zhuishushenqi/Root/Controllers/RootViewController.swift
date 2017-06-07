//
//  RootViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import Alamofire
import QSNetwork
import QSPullToRefresh

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"


class RootViewController: UIViewController {
    let kHeaderViewHeight:CGFloat = 5
    fileprivate let kHeaderBigHeight:CGFloat = 44
    fileprivate let kCellHeight:CGFloat = 60

    var bookShelfArr:[BookDetail]?
    var updateInfoArr:[UpdateInfo]?
    var segMenu:SegMenu!
    var bookShelfLB:UILabel!
    var communityView:CommunityView!
    var headerView:UIView!

    var reachability:Reachability?
    var semaphore:DispatchSemaphore!
    
    var totalCacheChapter:Int = 0
    var curCacheChapter:Int = 0
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.kCellHeight
        tableView.estimatedRowHeight = self.kCellHeight
        tableView.estimatedSectionHeaderHeight = self.kHeaderViewHeight
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.qs_registerCellClass(SwipableCell.self)
        let refresh = PullToRefresh(height: 50, position: .top, tip: "正在刷新")

        tableView.addPullToRefresh(refresh, action: {
            self.requetShelfMsg()
            self.requestBookShelf()
            self.updateInfo()
        })
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupReachability(IMAGE_BASEURL, useClosures: false)
        self.startNotifier()
        NotificationCenter.default.addObserver(self, selector: #selector(bookShelfUpdate), name: Notification.Name(rawValue: "BookShelfRefresh"), object: nil)
        self.setupSubviews()
        self.requetShelfMsg()
        self.requestBookShelf()
        self.updateInfo()
        
        //        let queue = DispatchQueue.global()
        //        let semaphore = DispatchSemaphore(value: 1)
        //        var arr:[Int] = []
        //        for index in 0..<100 {
        //            queue.async {
        //                _ = semaphore.wait(timeout:DispatchTime.distantFuture)
        //                QSLog(index)
        //                arr.append(index)
        //                semaphore.signal()
        //            }
        //        }
    }
    
    func bookShelfUpdate(){
        //先重新加载数据，然后再请求
        self.requestBookShelf()
        DispatchQueue.main.async {
            self.tableView.reloadData()
            self.updateInfo()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.cyan
        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        UIApplication.shared.isStatusBarHidden = false
    }
    
    @objc func leftAction(_ btn:UIButton){
        SideVC.showLeftViewController()
    }
    
    @objc func rightAction(_ btn:UIButton){
        SideVC.showRightViewController()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .lightContent
    }
}

extension RootViewController:UITableViewDataSource,UITableViewDelegate{
    //MARK: - UITableViewDataSource and UITableViewDelegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let bookShelf = bookShelfArr {
            return bookShelf.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:SwipableCell? = tableView.qs_dequeueReusableCell(SwipableCell.self)
        cell?.delegate = self
        if let models = bookShelfArr {
            cell?.configureCell(model: models[indexPath.row])
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.kCellHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if bookShelfLB.text == nil || bookShelfLB.text == ""{
            return kHeaderViewHeight
        }
        return kHeaderBigHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.present(QSTextRouter.createModule(bookDetail:self.bookShelfArr![indexPath.row],callback: { (book:BookDetail) in
            self.updateShelfArr(book: book)
        }), animated: true, completion: nil)
    }
    
    func updateShelfArr(book:BookDetail){
        if var arr = self.bookShelfArr {
            var index = 0
            for item in arr {
                if item._id == book._id {
                    arr[index] = book
                    self.bookShelfArr = arr
                    break
                }
                index += 1
            }
        }
    }
//        //来源
//        //        http://api.zhuishushenqi.com/btoc?view=summary&book=51d11e782de6405c45000068
//        let cell:SwipableCell? = self.tableView.cellForRow(at: indexPath) as? SwipableCell
//        let allChapterUrl = "\(BASEURL)/toc"
//        requestAllChapters(withUrl: allChapterUrl,param:["view":"summary","book":cell?.model?._id ?? ""],index: indexPath.row)
//    }
}

extension RootViewController:ComnunityDelegate{
    //MARK: - CommunityDelegate
    func didSelectCellAtIndex(_ index:Int){
        let dynamicVC = DynamicViewController()
        SideVC.navigationController?.pushViewController(dynamicVC, animated: true)
    }
}

extension RootViewController:SwipableCellDelegate{
    
    func swipeCell(clickAt: Int,model:BookDetail,cell:SwipableCell,selected:Bool) {
        if clickAt == 0 {
            if selected == false {
                // 取消下载
                
                return
            }
            let indexPath = tableView.indexPath(for: cell)
            // 选择一种缓存方式后，缓存按钮变为选中状态，小说图标变为在缓存中
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let firstAcion = UIAlertAction(title: "全本缓存", style: .default, handler: { (action) in
                self.cacheChapter(book: model, startChapter: 0,indexPath: indexPath)
            })
            let secondAction = UIAlertAction(title: "从当前章节缓存", style: .default, handler: { (action) in
                self.cacheChapter(book: model, startChapter: model.chapter,indexPath: indexPath)
            })
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: { (action) in
                
            })
            alert.addAction(firstAcion)
            alert.addAction(secondAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
        else if clickAt == 3 {
            //时间过长，先刷新table，再持久化
            if let models = self.bookShelfArr {
                self.bookShelfArr = bookShelfRefresh(model: model, arr: models)
                self.tableView.reloadData()
            }
            updateBookShelf(bookDetail: model, type: .delete,refresh:false)
        }
    }
    
    func cacheChapter(book:BookDetail,startChapter:Int,indexPath:IndexPath?){
        let cell:SwipableCell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as! SwipableCell
        cell.state = .prepare
        // 使用信号量控制，避免创建过多线程浪费性能
        semaphore = DispatchSemaphore(value: 0)
        if let chapters = book.book?.chapters {
            self.totalCacheChapter = chapters.count
            DispatchQueue.global().async {
                var count = 0
                for index in startChapter..<chapters.count {
                    if chapters[index].content == "" {
                        count += 1
                        self.fetchChapter(index: index,bookDetail: book,indexPath: indexPath)
                        if count >= 5{
                            let timeout:Double? = 30.00
                            let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                                ?? DispatchTime.distantFuture
                            _ = self.semaphore.wait(timeout: timeouts)
                            count -= 1
                        }
                    }else {
                        self.totalCacheChapter -= 1
                        let cell:SwipableCell = self.tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as! SwipableCell
                        if self.totalCacheChapter == self.curCacheChapter {
                            cell.state = .finish
                        }
                    }
                }
            }
        }
    }
    
    func fetchChapter(index:Int,bookDetail:BookDetail,indexPath: IndexPath?){
        let chapters = bookDetail.chapters
        let cell:SwipableCell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as! SwipableCell
        cell.state = .download
        if index >= (chapters?.count ?? 0) {
            cell.state = .none
            return
        }
        var link:NSString = "\(chapters?[index].object(forKey: "link") ?? "")" as NSString
        link = link.urlEncode() as NSString
        let url = "\(CHAPTERURL)/\(link)?k=22870c026d978c75&t=1489933049"
        QSNetwork.request(url) { (response) in
            DispatchQueue.global().async {
                if let json = response.json as? Dictionary<String, Any> {
                    QSLog("JSON:\(json)")
                    if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                        self.cacheSuccessHandler(chapterIndex: index, chapter: chapter, bookDetail: bookDetail,indexPath: indexPath)
                    } else {
                        self.cacheFailureHandler(chapterIndex: index)
                    }
                }else{
                    self.cacheFailureHandler(chapterIndex:index)
                }
            }
        }
    }
}

extension RootViewController:SegMenuDelegate{
    func didSelectAtIndex(_ index: Int) {
        QSLog("选择了第\(index)个")
        communityView.isHidden = (index == 0 ? true:false)
    }
    
    func cacheSuccessHandler(chapterIndex:Int,chapter: Dictionary<String, Any>,bookDetail:BookDetail,indexPath:IndexPath?){
        QSLog("下载完成第\(chapterIndex)章节")
        self.curCacheChapter += 1
        let cell:SwipableCell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as! SwipableCell
        cell.state = .download
        if curCacheChapter == totalCacheChapter - 1 {
            // 缓存完成
            cell.state = .finish
        }
        self.updateChapter(chapterIndex: chapterIndex, chapter: chapter, bookDetail: bookDetail, indexPath: indexPath)
        self.semaphore.signal()
    }
    
    func cacheFailureHandler(chapterIndex:Int){
        QSLog("下载失败第\(chapterIndex)章节")
        self.semaphore.signal()
    }
    
    // 更新当前model，更新本地保存model
    func updateChapter(chapterIndex:Int,chapter: Dictionary<String, Any>,bookDetail:BookDetail,indexPath:IndexPath?){
        if let chapters = bookDetail.book?.chapters {
            if chapterIndex < chapters.count {
                let qsChapter = chapters[chapterIndex]
                qsChapter.content = chapter["body"] as? String ?? ""
                bookDetail.book?.chapters?[chapterIndex] = qsChapter
                self.bookShelfArr?[indexPath?.row ?? 0] = bookDetail
                updateBookShelf(bookDetail: bookDetail, type: .update, refresh: false)
            }
        }
    }
}

