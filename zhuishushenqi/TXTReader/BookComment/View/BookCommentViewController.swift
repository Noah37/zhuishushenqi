//
//  BookCommentViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

enum QSBookCommentType {
    case normal
    case hotUser
    case hotPost
}

class BookCommentViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate ,Refreshable{
    
    var id:String = ""
    var commentType:QSBookCommentType = .normal
    private var start:Int = 0
    private var limit:Int = 1000
    private var param:[String:Any]?
    fileprivate var magicComments:[BookCommentDetail]? = [BookCommentDetail]()
    fileprivate var normalComments:[BookCommentDetail]? = [BookCommentDetail]()
    fileprivate var readerModel:BookComment?
    fileprivate var hotModel:QSHotModel?
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.qs_registerCellNib(BookCommentCell.self)
        tableView.qs_registerCellNib(UserfulCell.self)
        tableView.qs_registerCellNib(BookCommentViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initRefreshFooter(tableView) {
            self.start += self.limit
            self.requestMore()
        }
        
        title = "书评"
        let rightBtn = UIButton(type: .custom)
        rightBtn.addTarget(self, action: #selector(jump(btn:)), for: .touchUpInside)
        //        rightBtn.setImage(UIImage(named:"actionbar_close"), for: .normal)
        rightBtn.setTitle("去底部", for: .normal)
        rightBtn.setTitleColor(UIColor.red, for: .normal)
        rightBtn.frame = CGRect(x: self.view.bounds.width - 75, y: 7, width: 60, height: 30)
        let rightBar = UIBarButtonItem(customView: rightBtn)
        self.navigationItem.rightBarButtonItem = rightBar
        
        requestDetail(idString: self.id)
        requestBest()
        requestMore()
    }
    
    @objc func jump(btn:UIButton){
        var section = 2
        var row = 0
        if (self.magicComments?.count ?? 0)  > 0  {
            section = 3
        }
        if (self.normalComments?.count ?? 0) > 0 {
            row = (self.normalComments?.count ?? 1) - 1
        }
        let indexPath = IndexPath(row: row, section: section)
        self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    fileprivate func requestDetail(idString:String){
        
        let urlString = self.getDetailURL(type: commentType)
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            QSLog(response.json)
            if let reader = response.json?.object(forKey: "review") {
                self.readerModel = BookComment.model(with: reader as! [AnyHashable : Any])
            }
            DispatchQueue.main.async {
                self.tableView.removeFromSuperview()
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func requestBest(){
        //http://api.zhuishushenqi.com/post/530a26522852d5280e04c19c/comment/best
        let best = "\(BASEURL)/post/\(self.id)/comment/best"
        QSNetwork.request(best) { (response) in
            if let books = response.json?.object(forKey: "comments")  {
                if let models = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                    self.magicComments = models
                }
            }
            DispatchQueue.main.async {
                self.tableView.removeFromSuperview()
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
    }
    
    func requestMore(){
        let comment = getCommentURL(type: self.commentType)
        QSNetwork.request(comment, method: HTTPMethodType.get, parameters: self.param, headers: nil) { (response) in
            if let books = response.json?.object(forKey: "comments")  {
                if let normalComment = self.normalComments {
                    if let models = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                        self.normalComments = models + normalComment
                    }
                }else{
                    if let models = [BookCommentDetail].deserialize(from: books as? [Any]) as? [BookCommentDetail] {
                        self.normalComments = models
                    }
                }
            }
            DispatchQueue.main.async {
                self.tableView.removeFromSuperview()
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
//                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
            }
        }
    }
    
    func getCommentURL(type:QSBookCommentType)->String{
        var urlString = ""
        switch type {
        case .normal:
            //        http://api.zhuishushenqi.com/post/review/530a26522852d5280e04c19c/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/review/\(self.id)/comment"
            param = ["start":"\(start)","limit":"\(self.limit)"]
            break
        case .hotUser:
            //            http://api.zhuishushenqi.com/user/twitter/58d14859d0693ae736034619/comments
            urlString = "\(BASEURL)/user/twitter/\(self.id)/comments"
            param = nil
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/\(self.id)/comment"
            param = ["start":"\(start)","limit":"\(self.limit)"]
            break
        }
        return urlString
    }
    
    func getDetailURL(type:QSBookCommentType)->String{
        var urlString = ""
        switch type {
        case .normal:
            urlString = "\(BASEURL)/post/review/\(self.id)"
            break
        case .hotUser:
            
            urlString = "\(BASEURL)/user/twitter/\(self.id)"
            break
        case .hotPost:
            //            http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
            urlString = "\(BASEURL)/post/\(self.id)"
            break
        }
        return urlString
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        var sections = 4
        if (self.magicComments?.count ?? 0) == 0 {
            sections = 3
        }
        if (self.normalComments?.count ?? 0) == 0 {
            sections = 2
        }
        return sections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 2 {
            return (self.magicComments?.count ?? 0)
        }else if section == 3{
            return (self.normalComments?.count ?? 0)
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cellAt(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let height = BookCommentCell.totalCellHeight
            return height
        }else if indexPath.section == 1 {
            return 91
        }else {
            let height:CGFloat = 0
            if (magicComments?.count ?? 0) > 0 {
                if indexPath.section == 2 {
                    //                    height = BookCommentViewCell.cellHeight(model: magicComments?[indexPath.row])
                }else{
                    //                    height = BookCommentViewCell.cellHeight(model: normalComments?[indexPath.row])
                }
            }else {
                //                height = BookCommentViewCell.cellHeight(model: normalComments?[indexPath.row])
                
            }
            return height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section > 0 {
            return tableView.sectionHeaderHeight
        }
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section > 0 {
            let headerTitles = ["这个书评是否对你有用","仰望神评论","\(self.readerModel?.commentCount ?? 0)条评论"]
            let headerView = UIView()
            let headerLabel = UILabel()
            headerLabel.frame = CGRect(x: 15, y: 30, width: self.view.bounds.width - 30, height: 30)
            headerLabel.text = headerTitles[section - 1]
            headerLabel.textColor = UIColor.darkGray
            headerLabel.font = UIFont.systemFont(ofSize: 13)
            headerView.addSubview(headerLabel)
            return headerView
        }
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cellAt(indexPath:IndexPath) -> UITableViewCell {
        
        if indexPath.section ==  0{
            let cell:BookCommentCell? = tableView.qs_dequeueReusableCell(BookCommentCell.self)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
            cell?.contentView.layer.masksToBounds = true
            cell?.model = readerModel
            return cell!
        }else if indexPath.section == 1{
            let cell:UserfulCell? = tableView.qs_dequeueReusableCell(UserfulCell.self)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
            cell?.contentView.layer.masksToBounds = true
            cell?.model = readerModel
            return cell!
        }else {
            let cell:BookCommentViewCell? = tableView.qs_dequeueReusableCell(BookCommentViewCell.self)
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
            cell?.contentView.layer.masksToBounds = true
            let types = [CommentType.magical,CommentType.normal]
            cell?.type = .normal
            if (self.magicComments?.count ?? 0) > 0 {
                if indexPath.section == 2 {
                    cell?.type = types[indexPath.section - 2]
                    cell?.model = self.magicComments?[indexPath.row]
                }else{
                    cell?.model = self.normalComments?[indexPath.row]
                }
            }else{
                cell?.model = self.normalComments?[indexPath.row]
            }
            return cell!
        }
    }
}


