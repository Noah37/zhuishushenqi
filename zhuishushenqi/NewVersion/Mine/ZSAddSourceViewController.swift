//
//  ZSAddSourceViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/11/11.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSAddSourceViewController: BaseViewController {
    
    var source:ZSAikanParserModel? { didSet { reloadData() } }
    
    lazy var booksTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "books"
        tf.delegate = self
        return tf
    }()

    lazy var searchUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.delegate = self
        tf.title = "searchUrl"
        return tf
    }()

    lazy var nameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "name"
        tf.delegate = self
        return tf
    }()

    lazy var hostTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "host"
        tf.delegate = self
        return tf
    }()

    lazy var contentTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "content"
        tf.delegate = self
        return tf
    }()

    lazy var chapterUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "chapterUrl"
        tf.delegate = self
        return tf
    }()

    lazy var chapterNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "chapterName"
        tf.delegate = self
        return tf
    }()

    lazy var chaptersTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "chapters"
        tf.delegate = self
        return tf
    }()

    lazy var detailBookIconTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "detailBookIcon"
        tf.delegate = self
        return tf
    }()

    lazy var detailChaptersUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "detailChaptersUrl"
        tf.delegate = self
        return tf
    }()

    lazy var bookLastChapterNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookLastChapterName"
        tf.delegate = self
        return tf
    }()

    lazy var bookUpdateTimeTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookUpdateTime"
        tf.delegate = self
        return tf
    }()

    lazy var bookUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookUrl"
        tf.delegate = self
        return tf
    }()

    lazy var bookIconTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookIcon"
        tf.delegate = self
        return tf
    }()

    lazy var bookDescTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookDesc"
        tf.delegate = self
        return tf
    }()

    lazy var bookCategoryTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookCategory"
        tf.delegate = self
        return tf
    }()

    lazy var bookAuthorTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookAuthor"
        tf.delegate = self
        return tf
    }()

    lazy var bookNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "bookName"
        tf.delegate = self
        return tf
    }()

    lazy var detailBookDescTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "detailBookDesc"
        tf.delegate = self
        return tf
    }()

    lazy var contentRemoveTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "contentRemove"
        tf.delegate = self
        return tf
    }()

    lazy var contentReplaceTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "contentReplace"
        tf.delegate = self
        return tf
    }()

    lazy var contentTagRemoveTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "contentTagRemove"
        tf.delegate = self
        return tf
    }()

    lazy var searchEncodingTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.title = "searchEncoding"
        tf.delegate = self
        return tf
    }()

    lazy var scrollView:UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = UIColor.white
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = (source?.host.length ?? 0) > 0 ? "修改来源": "添加来源"
        
        setupSubviews()
        setupNavItem()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 22 * 50 + 19*10 + kNavgationBarHeight + 20)
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(self.booksTF)
        booksTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(20)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookNameTF)
        bookNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.booksTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookAuthorTF)
        bookAuthorTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookCategoryTF)
        bookCategoryTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookAuthorTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookDescTF)
        bookDescTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookCategoryTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookIconTF)
        bookIconTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookDescTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookUrlTF)
        bookUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookIconTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookUpdateTimeTF)
        bookUpdateTimeTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(bookLastChapterNameTF)
        bookLastChapterNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookUpdateTimeTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(detailChaptersUrlTF)
        detailChaptersUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookLastChapterNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(detailBookIconTF)
        detailBookIconTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailChaptersUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(chaptersTF)
        chaptersTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailBookIconTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(chapterNameTF)
        chapterNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chaptersTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(chapterUrlTF)
        chapterUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chapterNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(contentTF)
        contentTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chapterUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(hostTF)
        hostTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.contentTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.hostTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(searchUrlTF)
        searchUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.nameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(detailBookDescTF)
        detailBookDescTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.searchUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(contentRemoveTF)
        contentRemoveTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailBookDescTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        scrollView.addSubview(contentReplaceTF)
        contentReplaceTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.contentRemoveTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }

        scrollView.addSubview(contentTagRemoveTF)
        contentTagRemoveTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.contentReplaceTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(searchEncodingTF)
        searchEncodingTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.contentTagRemoveTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
    }
    
    private func setupNavItem() {
        let addItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(addAction))
        self.navigationItem.rightBarButtonItem = addItem
    }
    
    private func reloadData() {
        guard let model = source else { return }
        booksTF.text = model.books
        bookCategoryTF.text = model.bookCategory
        bookNameTF.text = model.bookName
        bookAuthorTF.text = model.bookAuthor
        bookDescTF.text = model.bookDesc
        bookIconTF.text = model.bookIcon
        bookUrlTF.text = model.bookUrl
        bookUpdateTimeTF.text = model.bookUpdateTime
        bookLastChapterNameTF.text = model.bookLastChapterName
        detailChaptersUrlTF.text = model.detailChaptersUrl
        detailBookIconTF.text = model.detailBookIcon
        chaptersTF.text = model.chapters
        chapterNameTF.text = model.chapterName
        chapterUrlTF.text = model.chapterUrl
        contentTF.text = model.content
        hostTF.text = model.host
        nameTF.text = model.name
        searchUrlTF.text = model.searchUrl
        detailBookDescTF.text = model.detailBookDesc
        searchEncodingTF.text = model.searchEncoding
        contentRemoveTF.text = model.contentRemove
        contentReplaceTF.text = model.contentReplace
        contentTagRemoveTF.text = model.contentTagReplace
    }
    
    @objc
    private func addAction() {
        if booksTF.text.length == 0 {
            alert(with: "提醒", message: "books不能为空", okTitle: "确定")
            return
        }
        let model:ZSAikanParserModel = source == nil ? ZSAikanParserModel():source!
        model.books = booksTF.textField.text ?? ""
        model.bookName = bookNameTF.textField.text ?? ""
        model.bookAuthor = bookAuthorTF.textField.text ?? ""
        model.bookCategory = bookCategoryTF.textField.text ?? ""
        model.bookDesc = bookDescTF.textField.text ?? ""
        model.bookIcon = bookIconTF.textField.text ?? ""
        model.bookUrl = bookUrlTF.textField.text ?? ""
        model.bookUpdateTime = bookUpdateTimeTF.textField.text ?? ""
        model.bookLastChapterName = bookLastChapterNameTF.textField.text ?? ""
        model.detailChaptersUrl = detailChaptersUrlTF.textField.text ?? ""
        model.detailBookIcon = detailBookIconTF.textField.text ?? ""
        model.chapters = chaptersTF.textField.text ?? ""
        model.chapterName = chapterNameTF.textField.text ?? ""
        model.chapterUrl = chapterUrlTF.textField.text ?? ""
        model.content = contentTF.textField.text ?? ""
        model.host = hostTF.textField.text ?? ""
        model.name = nameTF.textField.text ?? ""
        model.searchUrl = searchUrlTF.textField.text ?? ""
        model.detailBookDesc = detailBookDescTF.textField.text ?? ""
        model.searchEncoding = searchEncodingTF.textField.text ?? ""
        model.contentReplace = contentReplaceTF.textField.text ?? ""
        model.contentRemove = contentRemoveTF.textField.text ?? ""
        model.contentTagReplace = contentTagRemoveTF.textField.text ?? ""
        ZSSourceManager.share.add(source: model)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ZSAddSourceViewController:ZSAddLineViewDelegate {
    
}

protocol ZSAddLineViewDelegate:UITextFieldDelegate {
    
}

class ZSAddLineView: UIView {
    var placeholder:String = "" { didSet { textField.placeholder = placeholder } }
    var title:String {
        set{
            titleLabel.text = newValue
        }
        get{
            return titleLabel.text ?? ""
        }
    }
    var text:String {
        set {
            textField.text = newValue
        }
        get {
            return textField.text ?? ""
        }
    }

    weak var delegate:ZSAddLineViewDelegate? { didSet {  }  }
    
    lazy var titleLabel:UILabel = {
        let tf = UILabel(frame: .zero)
        tf.font = UIFont.systemFont(ofSize: 11)
        tf.text = ""
        return tf
    }()
    
    lazy var textField:UITextField = {
        let tf = UITextField(frame: .zero)
        tf.layer.borderColor = UIColor.gray.cgColor
        tf.layer.borderWidth = 0.3
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        tf.font = UIFont.systemFont(ofSize: 13)
        tf.borderStyle = .roundedRect
        tf.placeholder = "请输入"
        return tf
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(titleLabel)
        self.addSubview(textField)
//        self.titleLabel.snp.makeConstraints { (make) in
//            make.left.equalTo(self.view.snp.left).offset(20)
//            make.width.equalTo(100)
//            make.top.height.equalToSuperview()
//        }
//        self.textField.snp.makeConstraints { (make) in
//            make.left.equalTo(self.titleLabel.snp_right).offset(10)
//            make.top.height.equalToSuperview()
//            make.right.equalTo(self.view.snp.right).offset(-20)
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: 100, height: self.bounds.height)
        self.textField.frame = CGRect(x: 120, y: 5, width: self.bounds.size.width - 140, height: self.bounds.height - 10)
    }
    
    deinit {
        print(titleLabel.text)
    }
}
