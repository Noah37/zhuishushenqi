//
//  DynamicViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/22.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit
import QSNetwork
import QSPullToRefresh

class DynamicViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var timeline:[QSHotModel]?
    fileprivate var segment:UISegmentedControl = {
       let seg = UISegmentedControl(frame: CGRect(x: 15,y: 69,width: ScreenWidth - 30,height: 30))
        seg.insertSegment(withTitle: "动态", at: 0, animated: false)
        seg.insertSegment(withTitle: "热门", at: 1, animated: false)
        seg.insertSegment(withTitle: "我的", at: 2, animated: false)
        seg.tintColor = UIColor.red
        seg.backgroundColor = UIColor.clear
        seg.selectedSegmentIndex = 1
        return seg
    }()
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 104, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .singleLine
        tableView.estimatedRowHeight = 112
        tableView.rowHeight = 112
        tableView.sectionHeaderHeight = 0.0001
        tableView.sectionFooterHeight = 0.0001
        tableView.backgroundColor = UIColor.clear
        let refresh  = PullToRefresh(height: 21, position: .top, tip: "")
        tableView.addPullToRefresh(refresh, action: {
            self.requestData()
        })
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "动态"
        tableView.qs_registerCellNib(DynamicCell.self)
        view.addSubview(segment)
        view.addSubview(tableView)
        requestData()  
    }
    
    func requestData(){
        let urlString = "\(BASEURL)/user/twitter/hottweets"
        QSNetwork.request(urlString) { (response) in
            if let hottweets = response.json?["tweets"] as? [Any] {
                do{
                    self.timeline = try XYCBaseModel.model(withModleClass: QSHotModel.self, withJsArray: hottweets) as? [QSHotModel]
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }catch{
                   
                }
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeline?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:DynamicCell = tableView.qs_dequeueReusableCell(DynamicCell.self)
        if let model = self.timeline?[indexPath.row] {
            cell.setContent(model: model)
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.0001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //post为null
//        http://api.zhuishushenqi.com/user/twitter/58d14859d0693ae736034619/comments
        //post不为null，id从post中取
//        http://api.zhuishushenqi.com/post/58d1d313bd7cc9961f93192d/comment?start=0&limit=50
        let model = self.timeline?[indexPath.row]
        let bookCommentVC = BookCommentViewController()
        bookCommentVC.id = model?.tweet.post?["_id"] as? String ?? ""
        bookCommentVC.commentType = .hotPost
        if model?.tweet.post == nil || model?.tweet.post?.isEmpty == true {
            bookCommentVC.commentType = .hotUser
            bookCommentVC.id = model?.tweet._id ?? ""
        }
        self.navigationController?.pushViewController(bookCommentVC, animated: true)
        
    }
    
    override var preferredStatusBarStyle : UIStatusBarStyle {
        return .default
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}
