//
//  ZSUserDynamicViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/7/6.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import MJRefresh

enum UserDynamicType {
    case dynamic
    case mine
}

class ZSUserDynamicViewController: BaseViewController, ZSCommunityCellDelegate,ZSDynamicHeaderViewDelegate {
    
    lazy var errView:ZSNoNetworkView = {
        let errView = ZSNoNetworkView(frame: .zero)
        errView.loginHandler = { [weak self] in
            self?.loginAction()
        }
        return errView
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
        tableView.qs_registerCellClass(ZSCommunityCell.self)
        tableView.qs_registerHeaderFooterClass(ZSDynamicHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var viewModel:ZSDynamicViewModel = ZSDynamicViewModel()
    
    var id:String = ""
    
    var type:UserDynamicType = .dynamic
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        title = type == .dynamic ? "动态" :"我的"
        observe()
        view.addSubview(tableView)
        view.addSubview(errView)
        errView.snp.remakeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        tableView.snp.remakeConstraints { (make) in
            make.top.equalTo(kNavgationBarHeight)
            make.left.right.equalToSuperview()
            make.height.equalTo(ScreenHeight - kNavgationBarHeight)
        }
        let mj_header = ZSRefreshTextHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        mj_header?.endRefreshingCompletionBlock = { [weak mj_header] in
            mj_header?.changeText()
        }
        tableView.mj_header = mj_header
        if ZSLogin.share.hasLogin() {
            mj_header?.beginRefreshing()
        }
        
        let mj_footer = MJRefreshAutoStateFooter(refreshingTarget: self, refreshingAction: #selector(loadAction))
        mj_footer?.isAutomaticallyRefresh = false
        tableView.mj_footer = mj_footer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        errView.isHidden = ZSLogin.share.hasLogin()
        tableView.isHidden = !ZSLogin.share.hasLogin()

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

    
    func loginAction() {
        login { (finished) in
            
        }
    }
    
    @objc
    func refreshAction() {
//        self.viewModel.requestFollowings(id: id)
        self.viewModel.requestCommunity(id: id)
    }
    
    @objc
    func loadAction() {
        self.viewModel.requestMore(id: id)
    }
    
    //MARK: - ZSDynamicHeaderViewDelegate
    func headerView(headerView: ZSDynamicHeaderView, clickIcon: UIButton) {
        
    }
    
    func headerView(headerView: ZSDynamicHeaderView, clickFocus: UIButton) {
        if headerView.type == .mine {
            let userInfoVC = ZSUserInfoViewController()
            userInfoVC.hidesBottomBarWhenPushed = true
            navigationController?.pushViewController(userInfoVC, animated: true)
        } else {
            if headerView.focusState == false {
                self.viewModel.focus(id: id) { [weak headerView] (result) in
                    headerView?.focusState = result ? !headerView!.focusState:headerView!.focusState
                }
            } else {
                self.viewModel.unFocus(id: id) { [weak headerView] (result) in
                    headerView?.focusState = result ? !headerView!.focusState:headerView!.focusState
                }
            }
        }
    }
    
    func headerView(headerView: ZSDynamicHeaderView, clickFocusCount: UIButton) {
        
    }
    
    func headerView(headerView: ZSDynamicHeaderView, clickFans: UIButton) {
        
    }
    
    
    //MARK: - ZSCommunityCellDelegate
    func community(cell: ZSCommunityCell, clickIcon: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let dynamicVC = ZSUserDynamicViewController()
        dynamicVC.id = self.viewModel.dynamic?.tweets[indexPath.row].user?._id ?? ""
        dynamicVC.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(dynamicVC, animated: true)
    }
    
    func community(cell: ZSCommunityCell, clickFocus: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }
        let id = self.viewModel.dynamic?.tweets[indexPath.row].user?._id ?? ""
        if cell.focusState == false {
            self.viewModel.focus(id: id) { [weak cell] (result) in
                cell?.focusState = result ? !cell!.focusState:cell!.focusState
            }
        } else {
            self.viewModel.unFocus(id: id) { [weak cell] (result) in
                cell?.focusState = result ? !cell!.focusState:cell!.focusState
            }
        }
    }
    
    func community(cell: ZSCommunityCell, clickMsg: UIButton) {
        
    }
    
    func community(cell: ZSCommunityCell, clickShare: UIButton) {
        
    }
}

extension ZSUserDynamicViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.dynamic?.tweets.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.viewModel.dynamic?.tweets[indexPath.row]
        if let book = model?.book {
            return book.title.count == 0 ? (382 - 125):382
        }
        return 382 - 125
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSDynamicHeaderView.self)
        headerView?.delegate = self
        headerView?.configure(user: self.viewModel.dynamic?.user)
        headerView?.type = type
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSCommunityCell.self)
        cell?.selectionStyle = .none
        if let dynamic = self.viewModel.dynamic {
            cell?.congfigure(mo: dynamic.tweets[indexPath.row])
        }
        cell?.delegate = self
        return cell!
    }
}
