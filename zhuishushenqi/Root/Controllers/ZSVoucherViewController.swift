//
//  ZSVoucherViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/1/9.
//  Copyright © 2019年 QS. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

typealias ZSVoucherHandler = (_ indexPath:IndexPath)->Void

class ZSVoucherParentViewController: BaseViewController {
    
    var segmentViewController = ZSSegmentViewController()
    
    var segmentView:UISegmentedControl!
    var headerView:UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segmentViewController.scrollViewDidEndDeceleratingHandler = { index in
            self.segmentView.selectedSegmentIndex = index
        }
        segmentViewController.view.frame = CGRect(x: 0, y: headerView.frame.maxY, width: self.view.bounds.width, height: self.view.bounds.height - headerView.frame.maxY)
    }
    
    func setupSubviews() {
        headerView = UIView(frame: CGRect(x: 0, y: kNavgationBarHeight, width: self.view.bounds.width, height: 60))
        headerView.backgroundColor = UIColor.white
        segmentView = UISegmentedControl(frame: CGRect(x: 0, y: 20, width: self.view.bounds.width, height: 30))
        segmentView.tintColor = UIColor.red
        headerView.addSubview(segmentView)
        view.addSubview(headerView)
        
        var viewControllers:[UIViewController] = []
        var titles = ["可使用","已用完","已过期"]
        for i in 0..<3 {
            let viewController = ZSVoucherViewController()
            viewController.index = i
            viewController.title = titles[i]
            viewController.didSelectRowHandler = { indexPath in
                
            }
            viewControllers.append(viewController)
            segmentView.insertSegment(withTitle: titles[i], at: i, animated: false)
        }
        segmentView.selectedSegmentIndex = 0
        segmentView.addTarget(self, action: #selector(segmentTap), for: .valueChanged)
        addChild(segmentViewController)
        view.addSubview(segmentViewController.view)
        segmentViewController.viewControllers = viewControllers
    }
    
    @objc func segmentTap() {
        let index = segmentView.selectedSegmentIndex
        self.segmentViewController.didSelect(index: index)
    }
}

class ZSVoucherViewController: ZSBaseTableViewController, Refreshable {
    
    var index:Int = 0
    var viewModel:ZSMyViewModel = ZSMyViewModel()
    fileprivate let disposeBag = DisposeBag()
    var headerRefresh:MJRefreshHeader?
    var footerRefresh:MJRefreshFooter?
    
    var start = 0
    var limit = 20
    
    var didSelectRowHandler:ZSVoucherHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSubviews()
    }
    
    func setupSubviews() {

        let header = initRefreshHeader(tableView) {
            self.start = 0
            self.viewModel.fetchVoucher(token: ZSLogin.share.token, type: self.voucherType(), start: self.start, limit: self.limit, completion: { (voucherList) in
                self.tableView.reloadData()
            })
        }
        let footer = initRefreshFooter(tableView) {
            self.start += self.limit
            self.viewModel.fetchMoreVoucher(token: ZSLogin.share.token, type: self.voucherType(), start: self.start, limit: self.limit, completion: { (vouchers) in
                self.tableView.reloadData()
            })
        }
        headerRefresh = header
        footerRefresh = footer
        headerRefresh?.beginRefreshing()
        viewModel
            .autoSetRefreshHeaderStatus(header: header, footer: footer)
            .disposed(by: disposeBag)
        
    }
    
    func vouchers() ->[ZSVoucher]? {
        if index == 0 {
            return viewModel.useableVoucher
        } else if index == 1 {
            return viewModel.unuseableVoucher
        }
        return viewModel.expiredVoucher
    }
    
    func voucherType()->String {
        let types = ["useable","unuseable","expired"]
        return types[index]
    }
    
    override func registerCellClasses() -> Array<AnyClass> {
        return [ZSVoucherCell.self]
    }
    
    //MARK: - UITableView
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vouchers()?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSVoucherCell.self)
        if let voucherList = vouchers() {
            cell?.titleText = "\(voucherList[indexPath.row].amount)"
            cell?.rightText = "\(voucherList[indexPath.row].balance)"
            cell?.titleDetailText = "\(voucherList[indexPath.row].expired.qs_subStr(to: 10))" 
            cell?.rightDetailText = voucherList[indexPath.row].from
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
