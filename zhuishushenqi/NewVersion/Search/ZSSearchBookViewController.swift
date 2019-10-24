//
//  ZSSearchBookViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import MJRefresh

class ZSSearchBookViewController: BaseViewController {
    
    var viewModel = ZSSearchBookViewModel()
    
    lazy var topBar:ZSTopSearchBar = {
        let bar = ZSTopSearchBar(frame: .zero)
        return bar
    }()
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSHeaderSearchCell.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        observe()
        setupSubviews()
    }
    
    func setupSubviews() {
        view.addSubview(topBar)
        view.addSubview(tableView)
        topBar.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topBar.snp_bottom)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - kTabbarBlankHeight - FOOT_BAR_Height)
        }
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
    
    @objc
    private func refreshAction() {
        
    }
    
    @objc
    private func loadAction() {
        
    }
    
    private func observe() {
        self.viewModel.reloadBlock = {
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
                self.tableView.mj_footer.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

}

extension ZSSearchBookViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSHeaderSearchCell.self)
        cell?.selectionStyle = .none

        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
