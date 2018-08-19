//
//  QSRankDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import Kingfisher

class ZSRankItemViewController:BaseViewController {
    
    //标记控制器在父控制器中的序号
    var index:Int = 0
    
    var dataSource:[Book] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    var tableView:UITableView!
    
    var rank:QSRankModel?
    
    var viewModel = ZSRankDetailViewModel()
    
    var clickRow:ZSBaseCallback<Book>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.frame = view.bounds
    }
    
    func setupSubviews(){
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        view.addSubview(tableView)
    }
    
    func request(){
        if let rankInfo = rank {
            viewModel.fetchRanking(rank: rankInfo, index: index) { (books) in
                if let models = books {
                    self.dataSource = models
                }
            }
        }
    }
    
}


extension ZSRankItemViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = dataSource[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        clickRow?(dataSource[indexPath.row])
    }
}

class ZSRankViewController:BaseViewController {
    
    var rank:QSRankModel?
    var segmentViewController = ZSSegmentViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentViewController.view.frame = view.bounds
    }
    
    func setupSubviews(){
        var viewControllers:[UIViewController] = []
        var titles = ["周榜","月榜","总榜"]
        for i in 0..<3 {
            let viewController = ZSRankItemViewController()
            viewController.index = i
            viewController.rank = rank
            viewController.title = titles[i]
            viewController.clickRow = { (book) in
                self.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: book?._id ?? ""), animated: true)
            }
            viewControllers.append(viewController)
        }
        segmentViewController.viewControllers = viewControllers
        addChildViewController(segmentViewController)
        view.addSubview(segmentViewController.view)
    }
}

class QSRankDetailViewController: BaseViewController ,SegMenuDelegate,UITableViewDataSource,UITableViewDelegate,QSRankDetailViewProtocol{
    
    var presenter: QSRankDetailPresenterProtocol?
    
    var selectedIndex = 0
    var model:QSRankModel!
    var books:[[Book]] = [[],[],[]]

    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: kNavgationBarHeight + 40, width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - 40), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = CGFloat.leastNormalMagnitude
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        initSubview()
        presenter?.viewDidLoad(novel: model)
    }
    
    func initSubview(){
        let segView = SegMenu(frame: CGRect(x: 0, y: kNavgationBarHeight, width: UIScreen.main.bounds.size.width, height: 40), WithTitles: ["周榜","月榜","总榜"])
        segView.menuDelegate = self
        view.addSubview(segView)
        self.title = model.title
        view.addSubview(self.tableView)
    }
    
    func didSelectAtIndex(_ index:Int){
        selectedIndex = index
        presenter?.didSelectSeg(index: index)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books[selectedIndex].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = books[selectedIndex][indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter?.didSelectResultRow(indexPath: indexPath)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showRanks(ranks:[[Book]]){
        self.books = ranks
        self.tableView.reloadData()
    }
    
    func showEmpty(){
        self.books = [[],[],[]]
        self.tableView.reloadData()
    }
}

public class QSResource:Resource{
    
    public var imageURL:URL? = URL(string: "http://statics.zhuishushenqi.com/ranking-cover/142319144267827")
    public var downloadURL: URL {
        return imageURL!
    }
    
    public var cacheKey: String{
        return "\(String(describing: self.imageURL))"
    }
    
    init(url:URL) {
        self.imageURL = url
    }
}

