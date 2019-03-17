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
        tableView.frame = view.bounds
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
                    self.tableView.reloadData()
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
    var segmentViewController = ZSSegmenuViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentViewController.view.frame = view.bounds
    }
    
    func setupSubviews(){
        segmentViewController.delegate = self
        view.addSubview(segmentViewController.view)
        addChild(segmentViewController)
    }
}

extension ZSRankViewController:ZSSegmenuProtocol {
    func viewControllersForSegmenu(_ segmenu: ZSSegmenuViewController) -> [UIViewController] {
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
        return viewControllers
    }
    
    func segmenu(_ segmenu: ZSSegmenuViewController, didSelectSegAt index: Int) {
        
    }
    
    func segmenu(_ segmenu: ZSSegmenuViewController, didScrollToSegAt index: Int) {
        
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

