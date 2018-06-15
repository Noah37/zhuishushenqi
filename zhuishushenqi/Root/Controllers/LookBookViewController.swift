//
//  LookBookViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class LookBookViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate,QSSegmentDropViewDelegate {

    var models:[BookComment] = []
    var selectIndexs:[Int] = []
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 97
        tableView.qs_registerCellNib(QSHelpViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    func qs_equal<T:Equatable>(x:T,y:T)->Bool{
        return x == y
    }
    
    func initSubview(){
        self.title = "书荒求助区"
        let titles = [["全部","精品"],["默认排序","最新发布","最多评论"]]
        selectIndexs = [0,0]
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)
        let dropView = QSSegmentDropView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: ScreenWidth, height: 40), WithTitles: titles,parentView:self.view)
        dropView.menuDelegate = self
        view.addSubview(dropView)
    }
    
    func fetchHelp(_ selectIndexs:[Int]){
        // local list
        //all
//        http://api.zhuishushenqi.com/post/help?duration=all&sort=updated&start=0&limit=20
//        http://api.zhuishushenqi.com/post/help?duration=all&sort=created&start=0&limit=20
//        http://api.zhuishushenqi.com/post/help?duration=all&sort=comment-count&start=0&limit=20
        //great
//        http://api.zhuishushenqi.com/post/help?distillate=true&duration=all&sort=updated&start=0&limit=20
//        http://api.zhuishushenqi.com/post/help?distillate=true&duration=all&sort=created&start=0&limit=20
//        http://api.zhuishushenqi.com/post/help?distillate=true&duration=all&sort=comment-count&start=0&limit=20
        
        
        let urlString = getURLString(selectIndexs: selectIndexs)
        QSNetwork.request(urlString) { (response) in
            let helps = response.json?["helps"] as? [[String:Any]]
            if let commnets = [BookComment].deserialize(from: helps as? [Any]) as? [BookComment] {
                self.models = commnets
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getURLString(selectIndexs:[Int])->String{
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/help?\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=0&limit=20"
        return urlString
    }
    
    //MARK: - QSSegmentDropViewDelegate
    func didSelectAtIndexs(_ indexs: [Int]) {
        self.selectIndexs = indexs
        fetchHelp(selectIndexs)
    }
    
    //MARK: - UITableViewDataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QSHelpViewCell? = tableView.qs_dequeueReusableCell(QSHelpViewCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.configureCell(model: models[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.row]
        self.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: model._id), animated: true)
        
    }
}
