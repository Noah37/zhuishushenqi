//
//  LookBookViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/18.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork
import MJRefresh
import RxSwift

protocol ZSDiscussCellProtocol {
    func configureCell(with model:Any?)
}

typealias ZSDiscussHandler = ()->Void

class ZSDiscussTestViewController: ZSDiscussBaseViewController {
    
    private var _viewModel:ZSDiscussBaseViewModel = ZSDiscussBaseViewModel()
    
    override var viewModel: ZSDiscussViewModelProtocol? {
        return _viewModel
    }
    
    override var titles: [[String]] {
        return [["全部","精品"],["默认排序","最新发布","最多评论"]]
    }
    
    override var headerRefreshHandler: ZSDiscussHandler? {
        return {
            self.viewModel?.fetchDiscuss({ (_) in
                self.tableView.reloadData()
            })
        }
    }
    
    override var footerRefreshHandler: ZSDiscussHandler? {
        return {
            self.viewModel?.fetchMoreDiscuss({ (_) in
                self.tableView.reloadData()
            })
        }
    }
    
    override func registerCellNibs() -> Array<AnyClass> {
        return [QSHelpViewCell.self]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel?.models[indexPath.row] {
            let commentVC = ZSBookCommentViewController(style: .grouped)
            commentVC.viewModel.model = model as? BookComment
            self.navigationController?.pushViewController(commentVC, animated: true)
        }
    }
}

class ZSDiscussBaseViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,Refreshable {
    
    var selectIndexs:[Int] = []
    
    var block:String = "girl" {
        didSet{
//            self.viewModel?.block = block
        }
    }
    
    var viewModel:ZSDiscussViewModelProtocol? {
        return nil
    }
    
    var headerRefresh:MJRefreshHeader?
    var footerRefresh:MJRefreshFooter?
    // new
    var selectionView:ZSMultiSelectionView!
    fileprivate let disposeBag = DisposeBag()
    
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 97
        return tableView
    }()
    
    /// 标题,子类实现
    public var titles:[[String]]  {
        return [[]]
    }
    
    /// 头部刷新事件,子类实现
    var headerRefreshHandler:ZSDiscussHandler? {
        return nil
    }
    /// 尾部刷新事件,子类实现
    var footerRefreshHandler:ZSDiscussHandler? {
        return nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        register()
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.layoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectionView.hideSelection()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.layoutSubviews()
        }, completion: nil)
    }
    
    private func layoutSubviews() {
        self.tableView.frame =  CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight - 40)
        self.selectionView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40)
    }
    
    private func register(){
        let classes = registerCellClasses()
        for cls in classes {
            if cls is UITableViewCell.Type {
                self.tableView.qs_registerCellClass(cls as! UITableViewCell.Type)
            }
        }
        
        let nibs = registerCellNibs()
        for cls in nibs {
            if cls is UITableViewCell.Type {
                self.tableView.qs_registerCellNib(cls as! UITableViewCell.Type)
            }
        }
    }
    
    func qs_equal<T:Equatable>(x:T,y:T)->Bool{
        return x == y
    }
    
    func initSubview(){
        selectionView = ZSMultiSelectionView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40))
        selectionView.delegate = self
        view.addSubview(selectionView)
        
        
        for _ in titles {
            selectIndexs.append(0)
        }
        viewModel?.updateSelectSectionIndexs(indexs: selectIndexs)
        view.addSubview(self.tableView)
        
        let header = initRefreshHeader(tableView) {
            self.headerRefreshHandler?()
        }
        let footer = initRefreshFooter(tableView) {
            self.footerRefreshHandler?()
        }
        headerRefresh = header
        footerRefresh = footer
        
        headerRefresh?.beginRefreshing()
        viewModel?.autoSetRefreshHeaderStatus(header: header, footer: footer).disposed(by: disposeBag)
    }
    
    func fetchHelp(_ selectIndexs:[Int]){
//        viewModel?.fetchDiscuss(selectIndexs: selectIndexs) { (comments) in
//            self.tableView.reloadData()
//            if self.viewModel?.models.count ?? 0 > 0 {
//                let indexPath = IndexPath(row: 0, section: 0)
//                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: false)
//            }
//        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.models.count ?? 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QSHelpViewCell? = tableView.qs_dequeueReusableCell(QSHelpViewCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.configureCell(with: viewModel?.models[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 97
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    /// 注册cell的方法,子类实现
    func registerCellClasses() ->Array<AnyClass> {
        return []
    }
    
    func registerCellNibs() ->Array<AnyClass> {
        return []
    }
}

extension ZSDiscussBaseViewController:ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) -> Int {
        return titles.count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath: IndexPath) -> String {
        return titles[indexPath.section][indexPath.row]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section: Int) -> String {
        return titles[section][0]
    }
    
    @objc func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath: IndexPath) {
        selectIndexs[indexPath.section] = indexPath.row
        viewModel?.updateSelectSectionIndexs(indexs: selectIndexs)
        viewModel?.fetchDiscuss({ (_) in
            self.tableView.reloadData()
        })
    }
}

class ZSDiscussViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,Refreshable {

    var selectIndexs:[Int] = []
    
    var viewModel:ZSDiscussViewModel = ZSDiscussViewModel()
    
    var block:String = "girl" {
        didSet{
            self.viewModel.block = block
        }
    }
    
    var headerRefresh:MJRefreshHeader?
    var footerRefresh:MJRefreshFooter?
    // new
    var selectionView:ZSMultiSelectionView!
    fileprivate let disposeBag = DisposeBag()

    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 97
        tableView.qs_registerCellNib(QSHelpViewCell.self)
        return tableView
    }()
    
    let titles = [["全部","精品"],["默认排序","最新发布","最多评论"]]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.layoutSubviews()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.selectionView.hideSelection()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.layoutSubviews()
        }, completion: nil)
    }
    
    private func layoutSubviews() {
        self.tableView.frame =  CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight - 40)
        self.selectionView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40)
    }
    
    func qs_equal<T:Equatable>(x:T,y:T)->Bool{
        return x == y
    }
    
    func initSubview(){
        selectionView = ZSMultiSelectionView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40))
        selectionView.delegate = self
        view.addSubview(selectionView)
        
        selectIndexs = [0,0]
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)

        let header = initRefreshHeader(tableView) {
            self.viewModel.fetchDiscuss(selectIndexs: self.selectIndexs, completion: { (comments) in
                self.tableView.reloadData()
            })
        }
        let footer = initRefreshFooter(tableView) {
            self.viewModel.fetchMore(selectIndexs: self.selectIndexs, completion: { (comments) in
                self.tableView.reloadData()
            })
        }
        headerRefresh = header
        footerRefresh = footer
        
        headerRefresh?.beginRefreshing()
        viewModel.autoSetRefreshHeaderStatus(header: header, footer: footer).disposed(by: disposeBag)
    }
    
    func fetchHelp(_ selectIndexs:[Int]){
        viewModel.fetchDiscuss(selectIndexs: selectIndexs) { (comments) in
            self.tableView.reloadData()
            if self.viewModel.models.count > 0 {
                let indexPath = IndexPath(row: 0, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.none, animated: false)
            }
        }
    }
    
    //MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.models.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:QSHelpViewCell? = tableView.qs_dequeueReusableCell(QSHelpViewCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.configureCell(model: viewModel.models[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = viewModel.models[indexPath.row]
        let commentVC = ZSBookCommentViewController(style: .grouped)
        commentVC.viewModel.model = model
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
}

extension ZSDiscussViewController:ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) -> Int {
        return titles.count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath: IndexPath) -> String {
        return titles[indexPath.section][indexPath.row]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section: Int) -> String {
        return titles[section][0]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath: IndexPath) {
         selectIndexs[indexPath.section] = indexPath.row
        fetchHelp(selectIndexs)
    }
}

class ZSBookReviewViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate {
    var models:[BookComment] = []
    private var selectIndexs:[Int] = []
    private var configure:[[[String:String]]] = []
//    private var selectionView:QSSegmentDropView!
    private var selectionView:ZSMultiSelectionView!

    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 99
        tableView.qs_registerCellNib(ZSReviewsCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.layoutSubviews()
        }, completion: nil)
    }
    
    private func layoutSubviews() {
        self.selectionView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40)
        self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight - 40)
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
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)
        selectionView = ZSMultiSelectionView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40))
        selectionView.delegate = self
        view.addSubview(selectionView)
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
        let commentVC = ZSBookCommentViewController(style: .grouped)
        commentVC.viewModel.model = model
        self.navigationController?.pushViewController(commentVC, animated: true)
    }
}

extension ZSBookReviewViewController: ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) -> Int {
        return configure.count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int {
        return configure[section].count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath: IndexPath) -> String {
        return configure[indexPath.section][indexPath.row]["title"] ?? ""
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section: Int) -> String {
        return configure[section][0]["title"] ?? ""
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath: IndexPath) {
        selectIndexs[indexPath.section] = indexPath.row
        fetchHelp(selectIndexs)
    }
}

class ZSFemaleViewController:BaseViewController,UITableViewDataSource,UITableViewDelegate,QSSegmentDropViewDelegate {
    var models:[BookComment] = []
    var selectIndexs:[Int] = []
    let titles = [["全部","精品"],["默认排序","最新发布","最多评论"]]
    private var selectionView:ZSMultiSelectionView!
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 97
        tableView.qs_registerCellNib(QSHelpViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.layoutSubviews()
        }, completion: nil)
    }
    
    private func layoutSubviews() {
        self.tableView.frame =  CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight - 40)
        self.selectionView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40)
    }
    
    func qs_equal<T:Equatable>(x:T,y:T)->Bool{
        return x == y
    }
    
    func initSubview(){
        self.title = "女生区"
        selectIndexs = [0,0]
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)
        selectionView = ZSMultiSelectionView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40))
        selectionView.delegate = self
        view.addSubview(selectionView)
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
        let commentVC = ZSBookCommentViewController(style: .grouped)
        commentVC.viewModel.model = model
        self.navigationController?.pushViewController(commentVC, animated: true)    }
}

extension ZSFemaleViewController: ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) -> Int {
        return titles.count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath: IndexPath) -> String {
        return titles[indexPath.section][indexPath.row]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section: Int) -> String {
        return titles[section][0]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath: IndexPath) {
        selectIndexs[indexPath.section] = indexPath.row
        fetchHelp(selectIndexs)
    }
}

class LookBookViewController: BaseViewController,UITableViewDataSource,UITableViewDelegate {

    var models:[BookComment] = []
    var selectIndexs:[Int] = []
    private var selectionView:ZSMultiSelectionView!
    let titles = [["全部","精品"],["默认排序","最新发布","最多评论"]]

    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 97
        tableView.qs_registerCellNib(QSHelpViewCell.self)
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        coordinator.animate(alongsideTransition: { (context) in
            self.layoutSubivews()
        }, completion: nil)
    }
    
    private func layoutSubivews() {
        self.selectionView.frame = CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40)
        self.tableView.frame = CGRect(x: 0, y: kNavgationBarHeight + 40, width: self.view.bounds.width, height: self.view.bounds.height - kNavgationBarHeight - 40)
    }
    
    func qs_equal<T:Equatable>(x:T,y:T)->Bool{
        return x == y
    }
    
    func initSubview(){
        self.title = "书荒求助区"
        selectIndexs = [0,0]
        fetchHelp(self.selectIndexs)
        view.addSubview(self.tableView)
        selectionView = ZSMultiSelectionView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 40))
        selectionView.delegate = self
        view.addSubview(selectionView)
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
        let commentVC = ZSBookCommentViewController(style: .grouped)
        commentVC.viewModel.model = model
        self.navigationController?.pushViewController(commentVC, animated: true)    }
}

extension LookBookViewController: ZSMultiSelectionDelegate {
    func numberOfSections(in multiSelectionView: ZSMultiSelectionView) -> Int {
        return titles.count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, numberOfRowsInSection section: Int) -> Int {
        return titles[section].count
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForRowAt indexPath: IndexPath) -> String {
        return titles[indexPath.section][indexPath.row]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, titleForHeaderIn section: Int) -> String {
        return titles[section][0]
    }
    
    func multiSelectionView(_ multiSelectionView: ZSMultiSelectionView, didSelectAt indexPath: IndexPath) {
        selectIndexs[indexPath.section] = indexPath.row
        fetchHelp(selectIndexs)
    }
    
    
}
