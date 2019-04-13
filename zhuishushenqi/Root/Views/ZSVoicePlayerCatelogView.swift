//
//  ZSVoicePlayerCatelogView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/4/12.
//  Copyright © 2019年 QS. All rights reserved.
//

import Foundation

class ZSVoicePlayerCatelogView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        addSubview(tableView)
    }
    
    fileprivate var tableView:UITableView!
    fileprivate var headerView:UITableViewHeaderFooterView!
    fileprivate var backButton:UIButton!
    fileprivate var titleLabel:UILabel!
    fileprivate var totalLabel:UILabel!
}

extension ZSVoicePlayerCatelogView:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        return cell!
    }
}
