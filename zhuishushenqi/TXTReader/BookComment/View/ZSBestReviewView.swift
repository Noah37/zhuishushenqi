//
//  ZSBestReviewView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSBestReviewView: UIView {

    var tableView:UITableView!
    var models:[BookCommentDetail]?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        tableView = UITableView(frame: self.bounds, style: .plain)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.qs_registerCellNib(BookCommentViewCell.self)
        addSubview(tableView)
    }
    
    func bind(models:[BookCommentDetail]?) {
        if let _ = models {
            self.tableView.reloadData()
        }
    }

}

extension ZSBestReviewView:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(BookCommentViewCell.self)
        if let details = self.models {
            cell?.bind(book: details[indexPath.row])
        }
        return cell!
    }
    
    
}
