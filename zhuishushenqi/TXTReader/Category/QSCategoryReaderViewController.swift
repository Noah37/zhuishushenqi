//
//  QSCategoryViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
//import Alamofire


protocol QSCategoryDelegate {
    func categoryDidSelectAtIndex(index:Int)
}

class QSCategoryReaderViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,CategoryCellDelegate ,QSCategoryViewProtocol{
    var presenter: QSCategoryPresenterProtocol?
    var bookDetail:BookDetail?
    var viewModel = ZSReaderViewModel()
    var categoryDelegate:QSCategoryDelegate?
    var titles:[String] = []
    var selectedIndex = 0
    // key为章节的link，value为QSChapter模型
    var chapterDict:[String:QSChapter] = [:]
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x:0,y:0,width:0,height:0), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLineEtched
        tableView.separatorColor = UIColor.gray
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        view.addSubview(self.tableView)
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .plain, target: self, action: #selector(dismiss(sender:)))
        navigationItem.leftBarButtonItem = leftItem
        self.title = viewModel.book?.title
        
        if #available(iOS 11.0, *) {
            self.tableView.contentInsetAdjustmentBehavior = .never
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight)
        let indexPATH = IndexPath(row: viewModel.book?.record?.chapter ?? 0, section: 0)
        if (viewModel.book?.chaptersInfo?.count ?? 0) > 0 && (viewModel.book?.chaptersInfo?.count ?? 0) > indexPATH.row {
            self.tableView.scrollToRow(at: indexPATH , at: .middle, animated: false)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func setmask(statusBarBackgroundView:UIView){
        let gradientLayer = CAGradientLayer()
        let colors = [UIColor(white: 0.0, alpha: 0.0).cgColor,UIColor(white: 0.0, alpha: 0.9).cgColor]
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x:0.5,y:0.7)
        gradientLayer.frame = statusBarBackgroundView.bounds
        statusBarBackgroundView.layer.mask = gradientLayer
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.exsitLocal() {
            return viewModel.book?.book.localChapters.count ?? 0
        } else {
            if let chaptersInfo = self.viewModel.book?.chaptersInfo {
                return chaptersInfo.count
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category",for: indexPath as IndexPath) as! CategoryTableViewCell
        cell.cellDelegate = self
        if viewModel.exsitLocal() {
            if let model =  viewModel.book?.book.localChapters[indexPath.row] {
                cell.tittle.text = model.title
                cell.count.text = "\(indexPath.row)"
                cell.bind(model: model)
                if viewModel.book?.record?.chapter == indexPath.row {
                    cell.tittle.textColor = UIColor.red
                } else {
                    cell.tittle.textColor = UIColor.black
                }
            }
        } else {
            if let chaptersInfo = self.viewModel.book?.chaptersInfo {
                let link = chaptersInfo[indexPath.row].link
                let model = chapterDict[link]
                cell.bind(model: model)
                cell.tittle.text = chaptersInfo[indexPath.row].title
                cell.count.text = "\(indexPath.row)"
                if (viewModel.book?.record?.chapter == indexPath.row) {
                    cell.tittle.textColor = UIColor.red
                } else {
                    cell.tittle.textColor = UIColor.black
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        categoryDelegate?.categoryDidSelectAtIndex(index: indexPath.row)
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func dismiss(sender:AnyObject){
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .`default`
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation{
        return .slide
    }
    
    func downloadBtnClicked(sender:Any) -> Void{
        let btn = sender as! UIButton
        btn.isEnabled = false
        let cell = btn.superview?.superview as! UITableViewCell
        let indexPath = tableView.indexPath(for: cell)
        requestChapter(atIndex: indexPath?.row ?? 0)
    }
    
    //网络请求某一章节的信息
    func requestChapter(atIndex index:Int){
        if index >= titles.count {
            return;
        }
        if !BookManager.shared.bookExist(book:self.bookDetail) {
            return
        }
        let chapter = bookDetail?.chapters?[index]
        var link:NSString = "\(chapter?["link"] ?? "")" as NSString
        link = link.urlEncode() as NSString
        let url = "\(CHAPTERURL)/\(link)?k=19ec78553ec3a169&t=1476188085"
        zs_get(url) { (response) in
            if let json = response as? Dictionary<String, Any> {
                QSLog("JSON:\(json)")
                if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                    let chapterModel = self.bookDetail?.book.chapters[index]
                    chapterModel?.content = chapter["body"] as? String ?? ""
                    if let model = chapterModel {
                        self.bookDetail?.book.chapters[index] = model
                    }
                    if let book = self.bookDetail {
                        BookManager.shared.modifyBookshelf(book: book)
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func show(titles: [String]) {
        self.titles = titles
        self.tableView.reloadData()
    }
    
    func showDetail(book: BookDetail) {
        self.bookDetail = book
        selectedIndex = self.bookDetail?.record?.chapter ?? 0
        self.tableView.reloadData()
    }
}

extension UINavigationController {
    //http://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called
    //The UINavigationController does not forward on preferredStatusBarStyle calls to its child view controllers. Instead it manages its own state - as it should, it is drawing at the top of the screen where the status bar lives and so should be responsible for it. Therefor implementing preferredStatusBarStyle in your VCs within a nav controller will do nothing - they will never be called.
    open override var childForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
    
    open override var childForStatusBarHidden: UIViewController?{
        return self.topViewController
    }
    
}
