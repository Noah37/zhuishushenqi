//
//  ZSReaderCatalogViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/9.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderCatalogViewControllerDelegate:class {
    func catalog(catalog:ZSReaderCatalogViewController, clickChapter:ZSBookChapter)
}

class ZSReaderCatalogViewController: BaseViewController , ZSSearchInfoTableViewCellDelegate{
    
    var model:ZSAikanParserModel? { didSet { } }
    
    var chapter:ZSBookChapter?
    
    weak var delegate:ZSReaderCatalogViewControllerDelegate?
    
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
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    fileprivate var reverse:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupSubview()
        setupNavItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollToCurrent()
    }
    
    private func setupSubview() {
        title = model?.bookName
        view.addSubview(tableView)
        tableView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(kNavgationBarHeight)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - kTabbarBlankHeight)
        }
    }
    
    private func setupNavItem() {
        let addItem = UIBarButtonItem(title: "正序/倒序", style: UIBarButtonItem.Style.done, target: self, action: #selector(sortReverse))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    private func scrollToCurrent() {
        guard let book = model else { return }
        guard let cp = chapter else { return }
        if cp.chapterIndex < book.chaptersModel.count {
            if reverse {
                let indexPath = IndexPath(row: book.chaptersModel.count - cp.chapterIndex - 1, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            } else {
                let indexPath = IndexPath(row: cp.chapterIndex, section: 0)
                self.tableView.scrollToRow(at: indexPath, at: .middle, animated: false)
            }
        }
    }
    
    @objc
    private func sortReverse() {
        reverse = !reverse
        tableView.reloadData()
    }
    
    //MARK: - ZSSearchInfoTableViewCellDelegate
    func infoCell(cell: ZSSearchInfoTableViewCell, click download: UIButton) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        if let chapter = self.model?.chaptersModel[indexPath.row] {
            ZSReaderDownloader.share.download(chapter: chapter,book:model!, reg: model!.content) { [weak self] (chapter) in
                if chapter.contentNil() {
                    Toast.show(tip: "下载失败", .failure, 1)
                } else {
                    self?.tableView.reloadData()
                }
            }
        }
    }
}

extension ZSReaderCatalogViewController:UITableViewDataSource, UITableViewDelegate {
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
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.qs_dequeueReusableCell(ZSSearchInfoTableViewCell.self)
        cell?.delegate = self
        cell?.selectionStyle = .none
        cell?.accessoryType = .disclosureIndicator
        var chapter:ZSBookChapter!
        if reverse {
            chapter = self.model!.chaptersModel[self.model!.chaptersModel.count - indexPath.row - 1]
        } else {
            chapter = self.model!.chaptersModel[indexPath.row]
        }
        cell?.textLabel?.text = chapter.chapterName
        if let cp = ZSBookMemoryCache.share.content(for: chapter.chapterUrl) {
            if cp.chapterContent.length > 0 {
                cell?.downloadFinish()
            }
        }
        if let cp = self.chapter {
            if cp.chapterIndex == chapter.chapterIndex {
                cell?.textLabel?.textColor = UIColor.red
            } else {
                cell?.textLabel?.textColor = UIColor.black
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let chapters = model?.chaptersModel else {
            return
        }
        if reverse {
            delegate?.catalog(catalog: self, clickChapter: chapters[chapters.count - 1 - indexPath.row])
        } else {
            delegate?.catalog(catalog: self, clickChapter: chapters[indexPath.row])
        }
        navigationController?.popViewController(animated: true)
    }
}
