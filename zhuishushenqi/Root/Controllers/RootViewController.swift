//
//  RootViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/16.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import QSNetwork

let AllChapterUrl = "http://api.zhuishushenqi.com/ctoc/57df797cb061df9e19b8b030"

class RootViewController: UIViewController {
    let kHeaderViewHeight:CGFloat = 5
    fileprivate let kHeaderBigHeight:CGFloat = 44
    fileprivate let kCellHeight:CGFloat = 60

    // 采用dict保存书架中的书籍
    var bookshelf:[String:Any]?
    
    // 保存所有书籍的id
    var books:[String]?
    
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
    private var tipImageView:UIImageView!
    private var recView:QSLaunchRecView!
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = self.kCellHeight
        tableView.estimatedRowHeight = self.kCellHeight
        tableView.estimatedSectionHeaderHeight = self.kHeaderViewHeight
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.qs_registerCellClass(SwipableCell.self)
//        let refresh = PullToRefresh(height: 50, position: .top, tip: "正在刷新")
//        tableView.addPullToRefresh(refresh, action: {
//            self.requetShelfMsg()
//            self.requestBookShelf()
//            self.updateInfo()
//        })
        return tableView
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupReachability(IMAGE_BASEURL, useClosures: false)
        self.startNotifier()
        
        NotificationCenter.default.addObserver(self, selector: #selector(bookShelfUpdate(noti:)), name: Notification.Name(rawValue: BOOKSHELF_ADD), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(bookShelfUpdate(noti:)), name: Notification.Name(rawValue: BOOKSHELF_DELETE), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(showRecommend), name: Notification.Name(rawValue:SHOW_RECOMMEND), object: nil)
        self.setupSubviews()
        self.requetShelfMsg()
        self.requestBookShelf()
        self.updateInfo()
    }
    
    func removeBook(book:BookDetail){
        if let books = self.books {
            var index = 0
            for bookid in books {
                if book._id == bookid {
                    self.books?.remove(at: index)
                    self.bookshelf?.removeValue(forKey: bookid)
                    BookManager.shared.deleteBook(book: book)
                }
                index += 1
            }
        }
    }
    
    @objc func bookShelfUpdate(noti:Notification){
        let name = noti.name.rawValue
            if let book = noti.object as? BookDetail {
                if name == BOOKSHELF_ADD {
                    self.bookshelf?[book._id] = book
                    self.books?.append(book._id)
                    BookManager.shared.addBook(book: book)
                } else {
                    removeBook(book: book)
                }
            }
        //先刷新书架，然后再请求
        self.tableView.reloadData()
        self.updateInfo()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.view.backgroundColor = UIColor.cyan
        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
        UIApplication.shared.isStatusBarHidden = false
        // 刷新书架
        self.bookshelf = BookManager.shared.books
    }
    
    @objc private func showRecommend(){
        // animate
        let nib = UINib(nibName: "QSLaunchRecView", bundle: nil)
        recView = nib.instantiate(withOwner: nil, options: nil).first as? QSLaunchRecView
        recView.frame = self.view.bounds
        recView.alpha = 0.0
        recView.closeCallback = { (btn) in
            self.dismissRecView()
        }
        recView.boyTipCallback = { (btn) in
            self.fetchRecList(index: 0)
            self.perform(#selector(self.dismissRecView), with: nil, afterDelay: 1)
        }
        
        recView?.girlTipCallback = { (btn) in
            self.fetchRecList(index: 1)
            self.perform(#selector(self.dismissRecView), with: nil, afterDelay: 1)
        }
        KeyWindow?.addSubview(recView)
        UIView.animate(withDuration: 0.35, animations: { 
            self.recView.alpha = 1.0
        }) { (finished) in
            
        }
    }
    
    func fetchRecList(index:Int){
        let gender = ["male","female"]
        let recURL = "\(BASEURL)/book/recommend?gender=\(gender[index])"
        QSNetwork.request(recURL) { (response) in
            if let books = response.json?["books"] {
                if let models = [BookDetail].deserialize(from: books as? [Any]) as? [BookDetail] {
                    BookManager.shared.modifyBookshelf(books: models)
                    self.tableView.reloadData()
                }
                self.updateInfo()
            }
        }
    }
    
    func showUserTipView(){
        tipImageView = UIImageView(frame: self.view.bounds)
        tipImageView.image = UIImage(named: "add_book_hint")
        tipImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTipView(sender:)))
        tipImageView.addGestureRecognizer(tap)
        KeyWindow?.addSubview(tipImageView)
    }
    
    @objc func dismissTipView(sender:Any){
        tipImageView.removeFromSuperview()
    }
    
    @objc func dismissRecView(){
        UIView.animate(withDuration: 0.35, animations: {
            self.recView.alpha = 0.0
        }) { (finished) in
            self.recView.removeFromSuperview()
            self.showUserTipView()
        }
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
        if let keys = books?.count {
            
            return keys
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        let cell:SwipableCell? = tableView.qs_dequeueReusableCell(SwipableCell.self)
        cell?.delegate = self
        if let id =  books?[indexPath.row] {
            if let value = bookshelf?.valueForKey(key: id) as? BookDetail {
                cell?.configureCell(model: value)
            }
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
        if let id = self.books?[indexPath.row] {
            if let value = bookshelf?.valueForKey(key: id) as? BookDetail {
                let viewController = QSTextRouter.createModule(bookDetail:value,callback: { (book:BookDetail) in
                    let beginDate = Date()
                    self.bookshelf = BookManager.shared.modifyBookshelf(book:book)
                    tableView.reloadRow(at: indexPath, with: .automatic)
                    let endDate = Date()
                    let time = endDate.timeIntervalSince(beginDate as Date)
                    QSLog("用时\(time)")
                })
                self.present(viewController, animated: true, completion: nil)
            }
            // 进入阅读，当前书籍移到最前面
            self.books?.remove(at: indexPath.row)
            self.books?.insert(id, at: 0)
            let deadline = DispatchTime.now() + 1
            DispatchQueue.main.asyncAfter(deadline:deadline , execute: {
                self.tableView.reloadData()
            })
        }
    }    
}

extension RootViewController:ComnunityDelegate{
    //MARK: - CommunityDelegate
    func didSelectCellAtIndex(_ index:Int){
        
        if index == 3{
            let lookVC = LookBookViewController()
            SideVC.navigationController?.pushViewController(lookVC, animated: true)

        }else
        if index == 5 {
            let historyVC = ReadHistoryViewController()
            SideVC.navigationController?.pushViewController(historyVC, animated: true)
        } else if (index == 1) {
            let rootVC = ZSRootViewController()
            SideVC.navigationController?.pushViewController(rootVC, animated: true)
        }
//        else if (index == 2) {
//            let rootVC = ZSForumViewController()
//            SideVC.navigationController?.pushViewController(rootVC, animated: true)
//        }
        else{
            let dynamicVC = DynamicViewController()
            SideVC.navigationController?.pushViewController(dynamicVC, animated: true)
        }
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
            self.removeBook(book: model)
            self.tableView.reloadData()
        }
    }
    
    func cacheChapter(book:BookDetail,startChapter:Int,indexPath:IndexPath?){
        let cell:SwipableCell = tableView.cellForRow(at: indexPath ?? IndexPath(row: 0, section: 0)) as! SwipableCell
        cell.state = .prepare
        // 使用信号量控制，避免创建过多线程浪费性能
        semaphore = DispatchSemaphore(value: 5)
        if let chapters = book.book?.chapters {
            self.totalCacheChapter = chapters.count
            let group = DispatchGroup()
            let global = DispatchQueue.global(qos: .userInitiated)
            for index in startChapter..<chapters.count {
                global.async(group: group){
                    if chapters[index].content == "" {
                        self.fetchChapter(index: index,bookDetail: book,indexPath: indexPath)
                        let timeout:Double? = 30.00
                        let timeouts = timeout.flatMap { DispatchTime.now() + $0 }
                            ?? DispatchTime.distantFuture
                        _ = self.semaphore.wait(timeout: timeouts)
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
        if index == 1{
            communityView.models = self.bookShelfArr ?? []
        }
        communityView.isHidden = (index == 0 ? true:false)
    }
    
    func cacheSuccessHandler(chapterIndex:Int,chapter: Dictionary<String, Any>,bookDetail:BookDetail,indexPath:IndexPath?){
    
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
                bookDetail.book.chapters[chapterIndex] = qsChapter
                BookManager.shared.modifyBookshelf(book: bookDetail)
            }
        }
    }
}

