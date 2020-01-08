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
        tf.text = "books"
        tf.delegate = self
        return tf
    }()
    
    lazy var searchUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.delegate = self
        tf.text = "searchUrl"
        return tf
    }()
    
    lazy var nameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "name"
        tf.delegate = self
        return tf
    }()
    
    lazy var hostTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "host"
        tf.delegate = self
        return tf
    }()
    
    lazy var contentTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "content"
        tf.delegate = self
        return tf
    }()
    
    lazy var chapterUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "chapterUrl"
        tf.delegate = self
        return tf
    }()
    
    lazy var chapterNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "chapterName"
        tf.delegate = self
        return tf
    }()
    
    lazy var chaptersTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "chapters"
        tf.delegate = self
        return tf
    }()
    
    lazy var detailBookIconTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "detailBookIcon"
        tf.delegate = self
        return tf
    }()
    
    lazy var detailChaptersUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "detailChaptersUrl"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookLastChapterNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookLastChapterName"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookUpdateTimeTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookUpdateTime"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookUrlTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookUrl"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookIconTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookIcon"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookDescTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookDesc"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookCategoryTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookCategory"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookAuthorTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookAuthor"
        tf.delegate = self
        return tf
    }()
    
    lazy var bookNameTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "bookName"
        tf.delegate = self
        return tf
    }()
    
    lazy var detailBookDescTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "detailBookDesc"
        tf.delegate = self
        return tf
    }()
    
    lazy var searchEncodingTF:ZSAddLineView = {
        let tf = ZSAddLineView(frame: .zero)
        tf.placeholder = "请输入"
        tf.text = "searchEncoding"
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

        self.title = "添加来源"
        
        setupSubviews()
        setupNavItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        scrollView.contentSize = CGSize(width: self.view.bounds.width, height: 18 * 50 + 16*10 + kNavgationBarHeight + 20)
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
        scrollView.addSubview(self.bookNameTF)
        bookNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.booksTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookAuthorTF)
        bookAuthorTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookCategoryTF)
        bookCategoryTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookAuthorTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookDescTF)
        bookDescTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookCategoryTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookIconTF)
        bookIconTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookDescTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookUrlTF)
        bookUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookIconTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookUpdateTimeTF)
        bookUpdateTimeTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.bookLastChapterNameTF)
        bookLastChapterNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookUpdateTimeTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.detailChaptersUrlTF)
        detailChaptersUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.bookLastChapterNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.detailBookIconTF)
        detailBookIconTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailChaptersUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.chaptersTF)
        chaptersTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailBookIconTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.chapterNameTF)
        chapterNameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chaptersTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.chapterUrlTF)
        chapterUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chapterNameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.contentTF)
        contentTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.chapterUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.hostTF)
        hostTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.contentTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.nameTF)
        nameTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.hostTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.searchUrlTF)
        searchUrlTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.nameTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.detailBookDescTF)
        detailBookDescTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.searchUrlTF.snp.bottom).offset(10)
            make.right.equalTo(self.view.snp.right).offset(-20)
            make.height.equalTo(50)
        }
        scrollView.addSubview(self.searchEncodingTF)
        searchEncodingTF.snp.makeConstraints { (make) in
            make.left.equalTo(self.view.snp.left).offset(20)
            make.top.equalTo(self.detailBookDescTF.snp.bottom).offset(10)
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
        booksTF.tfText = model.books
        bookCategoryTF.tfText = model.bookCategory
        bookNameTF.tfText = model.bookName
        bookAuthorTF.tfText = model.bookAuthor
        bookDescTF.tfText = model.bookDesc
        bookIconTF.tfText = model.bookIcon
        bookUrlTF.tfText = model.bookUrl
        bookUpdateTimeTF.tfText = model.bookUpdateTime
        bookLastChapterNameTF.tfText = model.bookLastChapterName
        detailChaptersUrlTF.tfText = model.detailChaptersUrl
        detailBookIconTF.tfText = model.detailBookIcon
        chaptersTF.tfText = model.chapters
        chapterNameTF.tfText = model.chapterName
        chapterUrlTF.tfText = model.chapterUrl
        contentTF.tfText = model.content
        hostTF.tfText = model.host
        nameTF.tfText = model.name
        searchUrlTF.tfText = model.searchUrl
        detailBookDescTF.tfText = model.detailBookDesc
        searchEncodingTF.tfText = model.searchEncoding
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
        ZSSourceManager.share.add(source: model)
        navigationController?.popViewController(animated: true)
    }
    
}

extension ZSAddSourceViewController:ZSAddLineViewDelegate {
    
}

protocol ZSAddLineViewDelegate:UITextFieldDelegate {
    
}

class ZSAddLineView: UIView, UITextFieldDelegate {
    var placeholder:String = "" { didSet { textField.placeholder = placeholder } }
    var text:String = "" { didSet { titleLabel.text = text } }
    var tfText:String = "" { didSet { textField.text = tfText } }

    weak var delegate:ZSAddLineViewDelegate? { didSet { textField.delegate = delegate }  }
    
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
        self.textField.frame = CGRect(x: 120, y: 5, width: self.width - 140, height: self.bounds.height - 10)
    }
}
