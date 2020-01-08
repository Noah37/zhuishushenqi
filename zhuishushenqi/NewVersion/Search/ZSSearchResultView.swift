//
//  ZSSearchResultView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSSearchResultHander = (_ model:ZSAikanParserModel)->Void

class ZSSearchResultView: UIView {
    
    var books:[ZSAikanParserModel] = []
    
    var resultHandler:ZSSearchResultHander?

    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSSearchResultCell.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        addSubview(tableView)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addBook(book:ZSAikanParserModel) {
        DispatchQueue.main.async {
            if self.books.count != 0 {
                self.books.append(book)
                let indexPath:IndexPath = IndexPath(row: self.books.count - 1, section: 0)
                self.tableView.insertRows(at: [indexPath], with: .bottom)
                self.tableView.endUpdates()
            } else {
                self.books.append(book)
                self.reloadData()
            }
        }
    }
    
    func clearBooks() {
        self.books.removeAll()
        self.reloadData()
    }
    
    private func reloadData() {
        self.tableView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.tableView.frame = self.bounds
    }
}

extension ZSSearchResultView:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 130
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSSearchResultCell.self)
        cell?.selectionStyle = .none
        cell?.configure(model: self.books[indexPath.row])
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if resultHandler != nil {
            resultHandler?(books[indexPath.row])
        }
    }
}
