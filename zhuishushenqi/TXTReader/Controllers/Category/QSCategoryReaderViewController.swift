//
//  QSCategoryViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
//import Alamofire
import QSNetwork


protocol QSCategoryDelegate {
    func categoryDidSelectAtIndex(index:Int)
}

class QSCategoryReaderViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,CategoryCellDelegate ,QSCategoryViewProtocol{
    var presenter: QSCategoryPresenterProtocol?
    var bookDetail:BookDetail?
    var categoryDelegate:QSCategoryDelegate?
    var titles:[String] = []
    var selectedIndex = 0
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x:0,y:64,width:self.view.bounds.width,height:self.view.bounds.height - 64), style: .grouped)
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
        presenter?.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPATH = IndexPath(row: selectedIndex, section: 0)
        if titles.count > indexPATH.row {
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
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Category",for: indexPath as IndexPath) as! CategoryTableViewCell
        cell.cellDelegate = self
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row]
        }
        if (bookDetail?.book?.chapters?.count ?? 0) > indexPath.row{
            let chapter = bookDetail?.book?.chapters?[indexPath.row]
            if let model = chapter {
                cell.bind(model: model,index:selectedIndex)
            }
        }
        return cell
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
        return .lightContent
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
        if !BookManager.bookExistAtShelf( self.bookDetail) {
            return
        }
        let chapter = bookDetail?.chapters?[index]
        var link:NSString = "\(chapter?["link"] ?? "")" as NSString
        link = link.urlEncode() as NSString
        let url = "\(CHAPTERURL)/\(link)?k=19ec78553ec3a169&t=1476188085"
        QSNetwork.request(url) { (response) in
            if let json = response.json as? Dictionary<String, Any> {
                QSLog("JSON:\(json)")
                if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                    let chapterModel = self.bookDetail?.book?.chapters?[index]
                    chapterModel?.content = chapter["body"] as? String ?? ""
                    if let model = chapterModel {
                        self.bookDetail?.book?.chapters?[index] = model
                    }
                    BookManager.updateShelf(with: self.bookDetail, type: .update, refresh: false)
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
        selectedIndex = self.bookDetail?.chapter ?? 0
    }
}

extension UINavigationController {
    //http://stackoverflow.com/questions/19022210/preferredstatusbarstyle-isnt-called
    //The UINavigationController does not forward on preferredStatusBarStyle calls to its child view controllers. Instead it manages its own state - as it should, it is drawing at the top of the screen where the status bar lives and so should be responsible for it. Therefor implementing preferredStatusBarStyle in your VCs within a nav controller will do nothing - they will never be called.
    open override var childViewControllerForStatusBarStyle: UIViewController?{
        return self.topViewController
    }
    
    open override var childViewControllerForStatusBarHidden: UIViewController?{
        return self.topViewController
    }
    
}
