//
//  ZSSearchInfoViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/10/28.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSSearchInfoViewController: BaseViewController {
    
    var model:AikanParserModel? { didSet { } }
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(UITableViewCell.self)
        tableView.qs_registerHeaderFooterClass(ZSBookInfoHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
    }
    
    private func setupSubview() {
        title = model?.bookName
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavgationBarHeight)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight)
        }
    }

}

extension ZSSearchInfoViewController:UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.model?.chaptersModel.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return  40
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.qs_dequeueReusableHeaderFooterView(ZSBookInfoHeaderView.self)
        if let book = model {
            headerView?.configure(model: book)
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(UITableViewCell.self)
        cell?.selectionStyle = .none
        if let dict = self.model?.chaptersModel[indexPath.row] as? [String:Any] {
            cell?.textLabel?.text = dict["chapterName"] as? String
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

