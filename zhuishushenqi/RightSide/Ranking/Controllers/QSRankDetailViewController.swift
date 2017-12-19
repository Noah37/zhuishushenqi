//
//  QSRankDetailViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import Kingfisher

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

