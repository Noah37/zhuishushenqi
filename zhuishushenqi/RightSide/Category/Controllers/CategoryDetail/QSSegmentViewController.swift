//
//  QSSegmentViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/8/23.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSSegmentViewController: BaseViewController,QSSegmentViewProtocol,Refreshable {
    
    var presenter: QSSegmentPresenterProtocol?

    func showData(books:[Book]){
        booksModel = books
        if booksModel.count == 0 {
            self.tableView.showErrorPage()
        }
        self.tableView.reloadData()
    }
    
    func showSeg(titles:[String]){
        
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let header = initRefreshHeader(tableView) {
            self.requestData()
        }
        initRefreshFooter(tableView) {
            self.requestMore()
        }
        header.beginRefreshing()
        self.view.addSubview(self.tableView)
        if cellClass == UITableViewCell.self {
            self.tableView.qs_registerCellClass(UITableViewCell.self)
        }
        self.tableView.showLoadingPage()
        self.presenter?.didSelectAt(index: selectedIndex)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    var booksModel:[Book] = []
    var handler:QSNetworkHandker?
    var cellClass:AnyClass = UITableViewCell.self {
        didSet{
            self.tableView.qs_registerCellNib(cellClass as! UITableViewCell.Type)
        }
    }
    var selectedIndex:Int = 0
    var rowHeight:CGFloat = 44 {
        didSet{
            self.tableView.rowHeight = rowHeight
        }
    }
    
    private lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight - 104), style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = CGFloat.leastNormalMagnitude
        tableView.sectionFooterHeight = 10
        tableView.rowHeight = 44
        return tableView
    }()
    
    func requestData(){
        
    }
    
    func requestMore(){
        
    }

}

extension QSSegmentViewController:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.booksModel.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(cellClass as! TopDetailCell.Type)
        cell?.backgroundColor = UIColor.white
        cell?.selectionStyle = .none
        cell?.bindData(model: booksModel[indexPath.row ])
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
}

protocol QSSegmentCellProtocol {
    func bindData(model:AnyObject?)
}

//extension UITableViewCell:QSSegmentCellProtocol{
//    func bindData(model: AnyObject?) {
//
//    }
//}

