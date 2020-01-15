//
//  ZSVerticalViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/9.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSVerticalViewController: BaseViewController, ZSReaderVCProtocol {
    
    fileprivate var pageVC:PageViewController = PageViewController()
    
    weak var toolBar:ZSReaderToolbar?
    
    weak var dataSource:UIPageViewControllerDataSource?
    weak var delegate:UIPageViewControllerDelegate?
    
    var nextPageHandler: ZSReaderPageHandler?
    
    var lastPageHandler: ZSReaderPageHandler?
    
    lazy var tableView:UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionHeaderHeight = 0.01
        tableView.sectionFooterHeight = 0.01
        if #available(iOS 11, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        }
        tableView.register(ZSShelfTableViewCell.self, forCellReuseIdentifier: "\(ZSShelfTableViewCell.self)")
        tableView.qs_registerHeaderFooterClass(ZSBookShelfHeaderView.self)
        let blurEffect = UIBlurEffect(style: .extraLight)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        tableView.backgroundView = blurEffectView
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func bind(toolBar: ZSReaderToolbar) {
        self.toolBar = toolBar
    }
    
    func destroy() {
        pageVC.destroy()
    }
    
    func changeBg(style: ZSReaderStyle) {
        pageVC.bgView.image = style.backgroundImage
    }
    
    func jumpPage(page: ZSBookPage) {
        pageVC.newPage = page
        tableView.beginUpdates()
        tableView.reloadSection(UInt(page.chapterIndex), with: UITableView.RowAnimation.automatic)
        tableView.endUpdates()
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tap.numberOfTouchesRequired = 1
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        toolBar?.show(inView: view, true)
    }
}

extension ZSVerticalViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
