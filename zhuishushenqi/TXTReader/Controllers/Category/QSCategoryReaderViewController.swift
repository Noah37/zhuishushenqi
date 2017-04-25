//
//  QSCategoryViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import Alamofire


protocol QSCategoryDelegate {
    func categoryDidSelectAtIndex(index:Int)
}

class QSCategoryReaderViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,CategoryCellDelegate ,QSCategoryViewProtocol{
    var presenter: QSCategoryPresenterProtocol?

    var categoryDelegate:QSCategoryDelegate?
    var titles = [NSDictionary]()
    var selectedIndex:Int = 0
    var id:String = ""
    var resource:ResourceModel?
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x:0,y:64,width:self.view.bounds.width,height:self.view.bounds.height - 64), style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.black
        view.addSubview(self.tableView)
        tableView.separatorStyle = .singleLineEtched
        tableView.separatorColor = UIColor.gray
        navigationController?.navigationBar.barTintColor = UIColor.black
        tableView.register(UINib(nibName: "CategoryTableViewCell", bundle: nil), forCellReuseIdentifier: "Category")
        
        let leftItem = UIBarButtonItem(image: UIImage(named: "bg_back_white"), style: .plain, target: self, action: #selector(dismiss(sender:)))
        navigationItem.leftBarButtonItem = leftItem
        let statusView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 30))
        statusView.backgroundColor = UIColor.gray
        //添加阴影也能达到相同的目的
        //            let layer = statusView.layer
        //            let path = UIBezierPath(rect: layer.bounds)
        //            layer.shadowPath = path.cgPath
        //            layer.shadowColor = UIColor.black.cgColor
        //            layer.shadowOffset = CGSize.zero
        //            layer.shadowOpacity = 1.0
        //            layer.shadowRadius = 10
        //        self.view.addSubview(statusView)
        //        setmask(statusBarBackgroundView: statusView)
        //        self.tableView.backgroundView = UIImageView(image: UIImage(named: "space"))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let indexPATH = IndexPath(row: selectedIndex, section: 0)
        if titles.count > indexPATH.row {
            self.tableView.scrollToRow(at: indexPATH , at: .middle, animated: false)
        }
        //        setNeedsStatusBarAppearanceUpdate()
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
        cell.count.text = "\(indexPath.row)."
        cell.cellDelegate = self
        if titles.count > indexPath.row {
            cell.tittle.text = titles[indexPath.row].object(forKey: "title") as? String
        }
        
        let localKey:String = "\(indexPath.row)\(self.resource?.link ?? "")"
        if let _  = QSChapter.localModelWithKey(key: localKey)  {
            cell.downloadBtn.isHidden = true
        }else{
            cell.downloadBtn.isHidden = false
        }
        cell.tittle.textColor =  (selectedIndex == indexPath.row ? UIColor.green:UIColor.black)
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
        //        tableView(self.tableView, didSelectRowAt: indexPath!)
    }
    
    //网络请求某一章节的信息
    func requestChapter(atIndex index:Int){
        if index >= titles.count {
            return;
        }
        let localKey:String = "\(index)\(self.resource?.link ?? "")"
        if let _ = QSChapter.localModelWithKey(key: localKey) {
            return
        }
        
        let url = "\(CHAPTERURL)/\(titles[index].object(forKey: "link") ?? "")?k=19ec78553ec3a169&t=1476188085"
        Alamofire.request(url).responseJSON { (response) in
            if let json = response.result.value as? Dictionary<String, Any> {
                QSLog("JSON:\(json)")
                if let chapter = json["chapter"] as?  Dictionary<String, Any> {
                    //                    let chapterInfo = ChapterInfo(JSON: chapter)
                    //                    QSLog(chapterInfo?.body)
                    //                    chapterInfo?.currentIndex = index
                    //                    chapterInfo?.resource = self.resource
                    let chapterInfo = QSChapter(JSON: chapter)
                    chapterInfo?.link = self.titles[index]["link"] as? String ?? ""
                    chapterInfo?.title = self.titles[index]["title"] as? String ?? ""
                    chapterInfo?.content = chapter["body"] as? String ?? ""
                    chapterInfo?.curChapter = index
                    QSChapter.updateLocalModel(localModel: chapterInfo!, link: self.resource?.link ?? "")
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
