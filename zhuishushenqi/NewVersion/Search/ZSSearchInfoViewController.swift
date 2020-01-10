//
//  ZSSearchInfoViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2019/10/28.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSSearchInfoViewController: BaseViewController, ZSSearchInfoTableViewCellDelegate, ZSSearchInfoBottomViewDelegate {
    
    var model:ZSAikanParserModel? { didSet { } }
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.qs_registerCellClass(ZSSearchInfoTableViewCell.self)
        tableView.qs_registerHeaderFooterClass(ZSBookInfoHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()
    
    lazy var bottomView:ZSSearchInfoBottomView = {
        let view = ZSSearchInfoBottomView(frame: .zero)
        view.delegate = self
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubview()
        setupNavItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func popAction() {
        ZSReaderDownloader.share.cancelDownload()
        super.popAction()
    }
    
    private func setupSubview() {
        title = model?.bookName
        view.addSubview(tableView)
        view.addSubview(bottomView)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavgationBarHeight)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - kTabbarBlankHeight - 60)
        }
        bottomView.snp.makeConstraints { (make) in
            let height = kTabbarBlankHeight + 60
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(height)
        }
    }
    
    private func setupNavItem() {
        let addItem = UIBarButtonItem(title: "缓存全本", style: UIBarButtonItem.Style.done, target: self, action: #selector(downloadAll))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    @objc
    private func downloadAll() {
        guard let book = model else { return }
        ZSReaderDownloader.share.download(book: book, start: 0) { [weak self] (finished) in
            self?.tableView.reloadData()
        }
    }

    func infoCell(cell:ZSSearchInfoTableViewCell,click download:UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let chapter = self.model?.chaptersModel[indexPath.row] {
            ZSReaderDownloader.share.download(chapter: chapter,book:model!, reg: model!.content) { [weak self] (chapter) in
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    //MARK: - ZSSearchInfoBottomViewDelegate
    func bottomView(bottomView: ZSSearchInfoBottomView, clickAdd: UIButton) {
        let selected = clickAdd.isSelected
        if selected {
            if let book = self.model {
                ZSShelfManager.share.addAikan(book)
            }
        } else {
            if let book = self.model {
                ZSShelfManager.share.removeAikan(book)
            }
        }
    }
    
    func bottomView(bottomView: ZSSearchInfoBottomView, clickRead: UIButton) {
        guard let book = self.model else { return }
        if book.chaptersModel.count > 0 {
            let readerVC = ZSReaderController(chapter: book.chaptersModel[0], book)
            readerVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(readerVC, animated: true)
        } else {
            alert(with: "提示", message: "找不到该书籍", okTitle: "确定")
        }
    }
    
    deinit {
        
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
        if let book = model {
            return ZSBookInfoHeaderView.height(for: book)
        }
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
        let cell = tableView.qs_dequeueReusableCell(ZSSearchInfoTableViewCell.self)
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        if let dict = self.model?.chaptersModel[indexPath.row] as? ZSBookChapter {
            cell?.textLabel?.text = dict.chapterName
            if let chapter = ZSBookMemoryCache.share.content(for: dict.chapterUrl) {
                if chapter.chapterContent.length > 0 {
                    cell?.downloadFinish()
                }
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapters = model?.chaptersModel as? [ZSBookChapter] else {
            return
        }
        let pageVC = ZSReaderController(chapter: chapters[indexPath.row], model)
        self.navigationController?.pushViewController(pageVC, animated: true)
    }
}



