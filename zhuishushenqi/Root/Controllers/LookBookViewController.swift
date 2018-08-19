//
//  LookBookViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class ZSDiscussViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,QSSegmentDropViewDelegate {
    var models:[BookComment] = []
    var selectIndexs:[Int] = []
    
    var block:String = "girl"
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
        //all ,默认排序
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=updated&start=0&limit=20
        
        // all,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=created&start=0&limit=20
        
        // all,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&duration=all&sort=comment-count&start=0&limit=20
        
        // 精品,默认
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=updated&start=0&limit=20
        
        // 精品,最新发布
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=created&start=0&limit=20
        
        // 精品,最多评论
        //        http://api.zhuishushenqi.com/post/by-block?block=ramble&distillate=true&duration=all&sort=comment-count&start=0&limit=20
        
        let urlString = getURLString(selectIndexs: selectIndexs)
        QSNetwork.request(urlString) { (response) in
            let helps = response.json?["posts"] as? [[String:Any]]
            if let commnets = [BookComment].deserialize(from: helps) as? [BookComment] {
                self.models = commnets
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getURLString(selectIndexs:[Int])->String{
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/by-block?block=\(block)&\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=0&limit=20"
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
        self.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: model), animated: true)
    }
}

class ZSBookReviewViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,QSSegmentDropViewDelegate {
    var models:[BookComment] = []
    var selectIndexs:[Int] = []
    var configure:[[[String:String]]] = []
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 99
        tableView.qs_registerCellNib(ZSReviewsCell.self)
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
        self.title = "书评区"
        configure = [[
            ["title":"全部","key":"duration","value":"all"],
            ["title":"精品","key":"duration,distillate","value":"all,true"]]
            ,[["title":"全部类型","key":"type","value":"all"],
              ["title":"玄幻奇幻","key":"type","value":"xhqh"],
              ["title":"武侠仙侠","key":"type","value":"wxxx"],
              ["title":"都市异能","key":"type","value":"dsyn"],
              ["title":"历史军事","key":"type","value":"lsjs"],
              ["title":"游戏竞技","key":"type","value":"yxjj"],
              ["title":"科幻灵异","key":"type","value":"khly"],
              ["title":"穿越架空","key":"type","value":"cyjk"],
              ["title":"豪门总裁","key":"type","value":"hmzc"],
              ["title":"现代言情","key":"type","value":"xdyq"],
              ["title":"古代言情","key":"type","value":"gdyq"],
              ["title":"幻想言情","key":"type","value":"hxyq"],
              ["title":"耽美同人","key":"type","value":"dmtr"]],
             [
                ["title":"默认排序","key":"sort","value":"updated"],
                ["title":"最新发布","key":"sort","value":"created"],
                ["title":"最有用的","key":"sort","value":"helpful"],
                ["title":"最多评论","key":"sort","value":"comment-count"]
            ]]
        selectIndexs = [0,0,0]
        let titles = getTitles(models: configure)
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)
        let dropView = QSSegmentDropView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: ScreenWidth, height: 40), WithTitles: titles,parentView:self.view)
        dropView.menuDelegate = self
        view.addSubview(dropView)
    }
    
    func getTitles(models:[[[String:String]]]) -> [[String]]{
        var titles:[[String]] = []
        for item in models {
            var items:[String] = []
            for dict in item {
                items.append(dict["title"]!)
            }
            titles.append(items)
        }
        return titles
    }
    
    func fetchHelp(_ selectIndexs:[Int]){
        // 1.全部-全部类型-
            //1.1默认排序 http://api.zhuishushenqi.com/post/review?duration=all&sort=updated&type=all&start=0&limit=20
            //1.2最新发布 http://api.zhuishushenqi.com/post/review?duration=all&sort=created&type=all&start=0&limit=20
            //1.3最有用的 http://api.zhuishushenqi.com/post/review?duration=all&sort=helpful&type=all&start=0&limit=20
            //1.4最多评论 http://api.zhuishushenqi.com/post/review?duration=all&sort=comment-count&type=all&start=0&limit=20
        //2.精品-奇幻玄幻-最多评论
//        http://api.zhuishushenqi.com/post/review?distillate=true&duration=all&sort=comment-count&type=xhqh&start=0&limit=20
        
        
        let urlString = getURLString(selectIndexs: selectIndexs)
        QSNetwork.request(urlString) { (response) in
            let helps = response.json?["reviews"] as? [[String:Any]]
            if let commnets = [BookComment].deserialize(from: helps) as? [BookComment] {
                self.models = commnets
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getURLString(selectIndexs:[Int])->String{
        var section = 0
        var query = "start=0&limit=20"
        for selectIndex in selectIndexs {
            let item = getItem(section: section, index: selectIndex)
            let key = item["key"] ?? ""
            let keys = key.components(separatedBy: ",")
            let value = item["value"] ?? ""
            let values = value.components(separatedBy: ",")
            if keys.count > 1 {
                var param = ""
                for pIndex in 0..<keys.count {
                    if param != "" {
                        param.append("&")
                    }
                    param.append("\(keys[pIndex])=\(values[pIndex])")
                }
                if query != "" {
                    query.append("&")
                }
                query.append(param)
            } else {
                if query != "" {
                    query.append("&")
                }
                query.append("\(key)=\(value)")
            }
            section += 1
        }
        let urlString = "\(BASEURL)/post/review?\(query)"
        return urlString
    }
    
    fileprivate func getItem(section:Int,index:Int)->[String:String]{
        var currentSection = 0
        var value:[String:String] = [:]
        for conf in configure {
            if currentSection == section {
                var currentIndex = 0
                for item in conf {
                    if currentIndex == index {
                        value = item
                        break;
                    }
                    currentIndex += 1
                }
            }
            currentSection += 1
        }
        return value
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
        let cell:ZSReviewsCell? = tableView.qs_dequeueReusableCell(ZSReviewsCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.tag(items: configure[1])
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
        self.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: model), animated: true)
    }
}

class ZSFemaleViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,QSSegmentDropViewDelegate {
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
        self.title = "女生区"
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
        //all ,默认排序
//        http://api.zhuishushenqi.com/post/by-block?block=girl&duration=all&sort=updated&start=0&limit=20
        
        // all,最新发布
//        http://api.zhuishushenqi.com/post/by-block?block=girl&duration=all&sort=created&start=0&limit=20
        
        // all,最多评论
//        http://api.zhuishushenqi.com/post/by-block?block=girl&duration=all&sort=comment-count&start=0&limit=20
        
        // 精品,默认
//        http://api.zhuishushenqi.com/post/by-block?block=girl&distillate=true&duration=all&sort=updated&start=0&limit=20
        
        // 精品,最新发布
//        http://api.zhuishushenqi.com/post/by-block?block=girl&distillate=true&duration=all&sort=created&start=0&limit=20
        
        // 精品,最多评论
//        http://api.zhuishushenqi.com/post/by-block?block=girl&distillate=true&duration=all&sort=comment-count&start=0&limit=20
        
        let urlString = getURLString(selectIndexs: selectIndexs)
        QSNetwork.request(urlString) { (response) in
            let helps = response.json?["posts"] as? [[String:Any]]
            if let commnets = [BookComment].deserialize(from: helps) as? [BookComment] {
                self.models = commnets
                self.tableView.reloadData()
            }
        }
        
    }
    
    func getURLString(selectIndexs:[Int])->String{
        let durations = ["duration=all","duration=all&distillate=true"]
        let sort = ["sort=updated","sort=created","sort=comment-count"]
        let urlString = "\(BASEURL)/post/by-block?block=girl&\(durations[selectIndexs[0]])&\(sort[selectIndexs[1]])&start=0&limit=20"
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
        self.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: model), animated: true)        
    }
}

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
            if let commnets = [BookComment].deserialize(from: helps) as? [BookComment] {
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
        self.navigationController?.pushViewController(QSBookCommentRouter.createModule(model: model), animated: true)
    }
}
