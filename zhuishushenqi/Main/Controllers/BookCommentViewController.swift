//
//  BookCommentViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class BookCommentViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var id:String = ""
    let iden = "BookCommentCell"
    let userfulCell = "UserfulCell"
    let commentCell = "BookCommentViewCell"
    fileprivate var magicComments:[BookCommentDetail]? = [BookCommentDetail]()
    fileprivate var normalComments:[BookCommentDetail]? = [BookCommentDetail]()
    fileprivate var readerModel:BookComment?

    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 64, width: ScreenWidth, height: ScreenHeight - 64), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = CGFloat.leastNonzeroMagnitude
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.register(UINib (nibName: self.iden, bundle: nil), forCellReuseIdentifier: self.iden)
        tableView.register(UINib (nibName: self.userfulCell, bundle: nil), forCellReuseIdentifier: self.userfulCell)
        tableView.register(UINib (nibName: self.commentCell, bundle: nil), forCellReuseIdentifier: self.commentCell)

        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "书评"
        requestDetail(idString: self.id)
    }
    
    fileprivate func requestDetail(idString:String){
//        http://api.zhuishushenqi.com/post/review/530a26522852d5280e04c19c
        let urlString = "\(baseUrl)/post/review/\(self.id)"
        QSNetwork.request(urlString, method: HTTPMethodType.get, parameters: nil, headers: nil) { (response) in
            print(response.json ?? "No Data")
            if let reader = response.json?.object(forKey: "review") {
                self.readerModel = BookComment.model(with: reader as! [AnyHashable : Any])
            }
            DispatchQueue.main.async {
                self.tableView.removeFromSuperview()
                self.view.addSubview(self.tableView)
                self.tableView.reloadData()
            }
        }
//        http://api.zhuishushenqi.com/post/530a26522852d5280e04c19c/comment/best
        let best = "\(baseUrl)/post/\(self.id)/comment/best"
        QSNetwork.request(best) { (response) in
            do{
                if let books = response.json?.object(forKey: "comments")  {
                    self.magicComments =  try XYCBaseModel.model(withModleClass: BookCommentDetail.self, withJsArray:books as! [AnyObject]) as? [BookCommentDetail]
                }
                DispatchQueue.main.async {
                    self.tableView.removeFromSuperview()
                    self.view.addSubview(self.tableView)
                    self.tableView.reloadData()
                }
            }catch{
                
            }
        }
//        http://api.zhuishushenqi.com/post/review/530a26522852d5280e04c19c/comment?start=0&limit=50
        let comment = "\(baseUrl)/post/review/\(self.id)/comment"
        let commentParam = ["start":"0","limit":"50"]
        QSNetwork.request(comment, method: HTTPMethodType.get, parameters: commentParam, headers: nil) { (response) in
            do{
                if let books = response.json?.object(forKey: "comments")  {
                    self.normalComments =  try XYCBaseModel.model(withModleClass: BookCommentDetail.self, withJsArray:books as! [AnyObject]) as? [BookCommentDetail]
                }
                DispatchQueue.main.async {
                    self.tableView.removeFromSuperview()
                    self.view.addSubview(self.tableView)
                    self.tableView.reloadData()
                }
            }catch{
                
            }
        }
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
            let height = BookCommentCell.height(model: readerModel)
            return height
        }else if indexPath.section == 1 {
            return 91
        }else {
            var height:CGFloat = 0
            if (magicComments?.count ?? 0) > 0 {
                if indexPath.section == 2 {
                    height = BookCommentViewCell.cellHeight(model: magicComments?[indexPath.row])
                }else{
                    height = BookCommentViewCell.cellHeight(model: normalComments?[indexPath.row])
                }
            }else {
                height = BookCommentViewCell.cellHeight(model: normalComments?[indexPath.row])

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
            let cell:BookCommentCell? = tableView.dequeueReusableCell(withIdentifier: iden,for:indexPath) as? BookCommentCell
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
            cell?.contentView.layer.masksToBounds = true
            cell?.model = readerModel
            return cell!
        }else if indexPath.section == 1{
            let cell:UserfulCell? = tableView.dequeueReusableCell(withIdentifier: "UserfulCell", for: indexPath) as? UserfulCell
            cell?.backgroundColor = UIColor.white
            cell?.selectionStyle = .none
            cell?.contentView.layer.masksToBounds = true
            cell?.model = readerModel
            return cell!
        }else {
            let cell:BookCommentViewCell? = tableView.dequeueReusableCell(withIdentifier: "BookCommentViewCell", for: indexPath) as? BookCommentViewCell
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
