//
//  ZSSearchBookView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import MJRefresh

class ZSSearchBookView: UIView {
    
    var viewModel:ZSSearchBookViewModel? { didSet { reloadData() } }
    
    var clickHandler:ZSSearchClickHandler?
    
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
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.qs_registerHeaderFooterClass(ZSHeaderSearchTopView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(tableView)
        let mj_header = ZSRefreshTextHeader(refreshingTarget: self, refreshingAction: #selector(refreshAction))
        mj_header?.endRefreshingCompletionBlock = { [weak mj_header] in
            mj_header?.changeText()
        }
        tableView.mj_header = mj_header
        mj_header?.beginRefreshing()
    }
    
    @objc
    private func refreshAction() {
        viewModel?.request()
    }
    
    @objc
    private func reloadData() {
        observe()
        refreshAction()
        self.tableView.reloadData()
    }
    
    private func observe() {
        self.viewModel?.reloadBlock = {
            DispatchQueue.main.async {
                self.tableView.mj_header.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        tableView.frame = self.bounds
    }
    
}

extension ZSSearchBookView:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return viewModel?.numberOfSections() ?? 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = viewModel?.model(for: section) {
            if model.type == .history {
                return model.items.count
            }
        }
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return viewModel?.height(for: indexPath.section) ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSHeaderSearchTopView.self)
        if let model = viewModel?.model(for: section) {
            headerView?.titleLabel.text = model.headerTitle
            headerView?.detailButton.setTitle(model.headerDetail, for: .normal)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        if let model = viewModel?.model(for: indexPath.section) {
            if model.type == .hot ||  model.type == .recommend {
                let cell = tableView.qs_dequeueReusableCell(ZSHeaderSearchCell.self)
                cell?.selectionStyle = .none
                cell?.configure(model: model)
                cell?.clickHandler = { [weak self] word in
                    self?.viewModel?.wordClick(word: word)
                    self?.tableView.reloadData()
                    self?.clickHandler?(word)
                }
                return cell!
            } else {
                if indexPath.row < model.items.count {
                    if let history = model.items[indexPath.row] as? ZSSearchHistory {
                        cell?.textLabel?.text = history.word
                        cell?.textLabel?.textColor = UIColor.gray
                    }
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let model = viewModel?.model(for: indexPath.section) {
            if model.type == .history {
                if let history = model.items[indexPath.row] as? ZSSearchHistory {
                    viewModel?.wordClick(word: history.word)
                    tableView.reloadData()
                    clickHandler?(history.word)
                }
            }
        }
    }
}
