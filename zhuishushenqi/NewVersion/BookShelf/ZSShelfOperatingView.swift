//
//  ZSShelfOperatingView.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/16.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSShelfOperatingViewDelegate:class {
    func opView(opView:ZSShelfOperatingView, clickDetail:UIButton)
    func opView(opView:ZSShelfOperatingView, clickDownload:UIButton)
    func opView(opView:ZSShelfOperatingView, clickTop:UIButton)
    func opView(opView:ZSShelfOperatingView, clickSource:UIButton)
    func opView(opView:ZSShelfOperatingView, clickDelete:UIButton)
}

class ZSShelfOperatingView: UIView {
    
    weak var delegate:ZSShelfOperatingViewDelegate?
    
    lazy var backgroundView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
        return view
    }()
    
    lazy var contentView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 1.0, alpha: 1.0)
        return view
    }()
    
    lazy var infoView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor(white: 0.96, alpha: 1.0)
        return view
    }()

    lazy var bookIconView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    lazy var bookNameLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor(red:0.51, green:0.33, blue:0.32, alpha:1.00)
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var authorLB:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor(red:0.51, green:0.33, blue:0.32, alpha:1.00)
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var detailButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("详情", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(detailAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var downloadButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("批量下载", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.setImage(UIImage(named: "icon_download_a_24x24_"), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(downloadAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var topButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("置顶", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.setImage(UIImage(named: "icon_top_selected_24x24_"), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(topAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var groupButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("查看来源", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.setImage(UIImage(named: "icon_download_a_24x24_"), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(sourceAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var deleteButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("删除", for: .normal)
        bt.setTitleColor(UIColor.black, for: .normal)
        bt.setImage(UIImage(named: "icon_delete_1_24x24_"), for: .normal)
        bt.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(deleteAction(bt:)), for: .touchUpInside)
        return bt
    }()
    
    var book:ZSAikanParserModel!
    
    var indexPath:IndexPath?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(contentView)
        contentView.addSubview(infoView)
        contentView.addSubview(downloadButton)
        contentView.addSubview(topButton)
        contentView.addSubview(groupButton)
        contentView.addSubview(deleteButton)

        infoView.addSubview(bookNameLB)
        infoView.addSubview(bookIconView)
        infoView.addSubview(authorLB)
        infoView.addSubview(detailButton)
        
        setupGesture()
        backgroundView.frame = bounds
        contentView.frame = CGRect(x: 0, y: bounds.height, width: bounds.width, height: 160)
        infoView.frame = CGRect(x: 0, y: 0, width: bounds.width, height: 80)
        bookIconView.frame = CGRect(x: 15, y: 10, width: 40, height: 60)
        bookNameLB.frame = CGRect(x: bookIconView.frame.maxX + 10, y: 10, width: 200, height: 20)
        authorLB.frame = CGRect(x: bookIconView.frame.maxX + 10, y: 40, width: 200, height: 20)
        detailButton.frame = CGRect(x: bounds.width - 75, y: 30, width: 60, height: 20)
        let bottomWidth:CGFloat = 80
        let spaceX = (bounds.width/4 - bottomWidth)/2
        downloadButton.frame = CGRect(x: spaceX, y: 80, width: bottomWidth, height: 60)
        topButton.frame = CGRect(x: spaceX * 3 + bottomWidth, y: 80, width: bottomWidth, height: 60)
        groupButton.frame = CGRect(x: spaceX * 5 + bottomWidth * 2, y: 80, width: bottomWidth, height: 60)
        deleteButton.frame = CGRect(x: spaceX * 7 + bottomWidth * 3, y: 80, width: bottomWidth, height: 60)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        backgroundView.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        hiden(true)
    }
    
    @objc
    private func detailAction(bt:UIButton) {
        delegate?.opView(opView: self, clickDetail: bt)
        hiden(false)
    }
    
    @objc
    private func downloadAction(bt:UIButton) {
        delegate?.opView(opView: self, clickDownload: bt)
        hiden(false)
    }
    
    @objc
    private func topAction(bt:UIButton) {
        delegate?.opView(opView: self, clickTop: bt)
        hiden(false)
    }
    
    @objc
    private func sourceAction(bt:UIButton) {
        delegate?.opView(opView: self, clickSource: bt)
        hiden(false)
    }
    
    @objc
    private func deleteAction(bt:UIButton) {
        delegate?.opView(opView: self, clickDelete: bt)
        hiden(false)
    }
    
    func configure(book:ZSAikanParserModel) {
        self.book = book
        let icon = book.bookIcon.length > 0 ? book.bookIcon:book.detailBookIcon
        let resource = QSResource(url: URL(string: icon) ?? URL(string: "www.baidu.com")!)
        bookIconView.kf.setImage(with: resource, placeholder: UIImage(named: "default_book_cover"))
        bookNameLB.text = book.bookName
        authorLB.text = book.bookAuthor
    }
    
    func show(inView:UIView,_ animated:Bool = true) {
        inView.addSubview(self)
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.contentView.frame.origin.y = self.bounds.height - 160
            }) { (finished) in
                
            }
        } else {
            self.contentView.frame.origin.y = self.bounds.height - 160
        }
    }
    
    func hiden(_ animated:Bool = true) {
        if animated {
            UIView.animate(withDuration: 0.5, animations: {
                self.contentView.frame.origin.y = self.bounds.height
            }) { (finished) in
                self.removeFromSuperview()
            }
        } else {
            self.contentView.frame.origin.y = self.bounds.height
            self.removeFromSuperview()
        }
    }
    
}
