//
//  ZSCommunityViewController.swift
//  ZSCommunity
//
//  Created by caony on 2019/6/18.
//

import UIKit
import MJRefresh

class ZSCommunityViewController: BaseViewController, ZSCommunityNavigationBarDelegate {
    
    lazy var navImages:[ShelfNav] = {
        var images:[ShelfNav] = []
        let mine = ShelfNav(rawValue: 4)
        let notification = ShelfNav(rawValue: 5)
        if let _ = mine?.image {
            images.append(mine!)
        }
        if let _ = notification?.image {
            images.append(notification!)
        }
        return images
    }()
    
    lazy var navigationBar:ZSCommunityNavigationBar = {
        let nav = ZSCommunityNavigationBar(navImages: self.navImages, delegate: self)
        return nav
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
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    var viewModel:ZSCommunityViewModel = ZSCommunityViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        observe()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func setupSubviews() {
        view.addSubview(navigationBar)
        view.addSubview(tableView)
        navigationBar.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight)
        }
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.navigationBar.snp_bottom)
            make.bottom.equalToSuperview()
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
        self.viewModel.requestCommunity()
    }
    
    @objc
    private func loadAction() {
        self.viewModel.requestMore()
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
    
    //MARK: - ZSCommunityNavigationBarDelegate
    func navView(navView: ZSCommunityNavigationBar, didSelectRight at: Int) {
        
    }
    
    func navView(navView: ZSCommunityNavigationBar, didSelectLeft at: Int) {
        
    }
}

extension ZSCommunityViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.twitters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let model = self.viewModel.twitters[indexPath.row]
        if let book = model.tweet.book {
            return book.title.count == 0 ? (382 - 125):382
        }
        return 382 - 125
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSCommunityCell.self)
        cell?.selectionStyle = .none
        cell?.congfigure(model: self.viewModel.twitters[indexPath.row])
        return cell!
    }
}
