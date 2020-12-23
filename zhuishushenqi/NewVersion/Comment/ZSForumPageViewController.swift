//
//  ZSForumViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2019/8/6.
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
        tableView.qs_registerHeaderFooterClass(ZSForumPageTitleHeaderView.self)
        return tableView
    }()
    
    private lazy var textView:ZSForumTextView = {
        let textView = ZSForumTextView(frame: .zero)
        return textView
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
        
        view.addSubview(textView)
        view.addSubview(tableView)
        textView.snp.remakeConstraints { (make) in
            make.bottom.left.right.equalToSuperview()
            make.height.equalTo(52)
        }
        tableView.snp.remakeConstraints { [unowned self](make) in
            make.bottom.equalTo(self.textView.snp.top)
            make.left.right.top.equalToSuperview()
        }
        navigationController?.isNavigationBarHidden = false
    }
    
    private func observe() {
        self.viewModel.reloadBlock = { [weak self] in
            DispatchQueue.main.async { [unowned self] in
                self?.tableView.mj_header.endRefreshing()
                self?.tableView.reloadData()
                if self?.viewModel.noMoreData == true {
                    self?.tableView.mj_footer.state = MJRefreshState.noMoreData
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
        return viewModel.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRowsInSection(section: section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSForumPageCell.self)
        cell?.selectionStyle = .none
        cell?.configure(model: viewModel.cellModel(for: indexPath))
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageHeaderView.self)
            headerView?.configure(review: viewModel.review)
            return headerView
        } else if section == 1 {
            if viewModel.haveBest() {
                let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageTitleHeaderView.self)
                headerView?.titleLabel.text = "仰望神评论"
                return headerView
            } else if viewModel.haveNormal() {
                let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageTitleHeaderView.self)
                headerView?.titleLabel.text = "最新评论"
                return headerView
            }
        } else if section == 2 {
            let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageTitleHeaderView.self)
            headerView?.titleLabel.text = "最新评论"
            headerView?.totalLabel.text = "共\(viewModel.review?.commentCount ?? 0)条评论"
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        if viewModel.haveFooter() {
            let footerView = tableView.qs_dequeueReusableHeaderFooterView(ZSForumPageFooterView.self)
            return footerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        } else if viewModel.haveBest() {
            return 50
        } else if viewModel.haveNormal() {
            return 50
        }
        return 0.01
    }
}
