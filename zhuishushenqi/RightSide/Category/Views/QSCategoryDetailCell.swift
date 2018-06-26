//
//  CollectionViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/22.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias QSNetworkHandker = ()->Void

class QSCategoryDetailCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate,Refreshable {
    
    var booksModel:[Book] = []
    var handler:QSNetworkHandker?
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 93
        tableView.qs_registerCellNib(TopDetailCell.self)
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        initRefreshFooter(tableView) {
            self.requestMore()
        }
        self.backgroundColor = UIColor.clear
        self.contentView.backgroundColor = UIColor.clear
        self.contentView.addSubview(tableView)
        requestData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        QSLog(#function)
        
    }
    
    func requestData(){
        if let handlerr = handler  {
            handlerr()
        }
    }
    
    func bindData(data:[Book]){
        self.booksModel = data
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.booksModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:TopDetailCell? = tableView.qs_dequeueReusableCell(TopDetailCell.self)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell!.model = booksModel.count  > indexPath.row ? booksModel[indexPath.row ]:nil
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return tableView.sectionHeaderHeight
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return tableView.sectionFooterHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        presenter?.didSelectRowAt(indexPath: indexPath)
    }
    
    func requestMore(){
        
    }
}
