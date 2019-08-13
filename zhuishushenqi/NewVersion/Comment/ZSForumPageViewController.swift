//
//  ZSForumViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/8/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import MJRefresh

class ZSForumPageViewController: BaseViewController {
    
    fileprivate lazy var tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = UITableView.automaticDimension
        tableView.sectionFooterHeight = UITableView.automaticDimension
        tableView.estimatedSectionHeaderHeight = 100
        tableView.estimatedSectionFooterHeight = 100
        tableView.estimatedRowHeight = 180
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = UIColor.white
        tableView.qs_registerCellClass(ZSForumPageCell.self)
        tableView.qs_registerHeaderFooterClass(ZSForumPageHeaderView.self)
        tableView.qs_registerHeaderFooterClass(ZSForumPageFooterView.self)
        return tableView
    }()
    
    var viewModel:ZSForumViewModel = ZSForumViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        observe()
        
        let mj_header = ZSRefreshTextHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        mj_header?.endRefreshingCompletionBlock = { [weak mj_header] in
            mj_header?.changeText()
        }
        tableView.mj_header = mj_header
        mj_header?.beginRefreshing()
        
        let mj_footer = MJRefreshAutoStateFooter(refreshingTarget: self, refreshingAction: #selector(loadAction))
        mj_footer?.isAutomaticallyRefresh = false
        tableView.mj_footer = mj_footer
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
        }
    }
    
    private func observe() {
        self.viewModel.reloadBlock = {
            DispatchQueue.main.async { [unowned self] in
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
                if self.viewModel.noMoreData {
                    self.tableView.mj_footer.state = MJRefreshState.noMoreData
                }
            }
        }
        viewModel.request()
    }
    
    @objc
    func refreshAction() {
        viewModel.request()
    }
    
    @objc
    func loadAction() {
        viewModel.requestMore()
    }

}

extension ZSForumPageViewController:UITableViewDataSource , UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSForumPageCell.self)
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageHeaderView.self)
        headerView?.configure(review: viewModel.review)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.haveFooter() {
            let footerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageFooterView.self)
            return footerView
        }
        return nil
    }
}
