//
//  ZSSearchBookViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSSearchBookViewController: BaseViewController,ZSTopSearchBarProtocol  {
    
    var viewModel = ZSSearchBookViewModel()
    
    lazy var topBar:ZSTopSearchBar = {
        let bar = ZSTopSearchBar(frame: .zero)
        bar.delegate = self
        return bar
    }()
    
    lazy var bookView:ZSSearchBookView = {
        let view = ZSSearchBookView(frame: .zero)
        view.viewModel = self.viewModel
        view.clickHandler = { [weak self] word in
            self?.searchHotClick(word: word)
        }
        return view
    }()
    
    lazy var resultView:ZSSearchResultView = {
        let view = ZSSearchResultView(frame: .zero)
        view.resultHandler = { [weak self] model in
            self?.resultClick(model: model)
        }
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    func setupSubviews() {
        view.addSubview(topBar)
        view.addSubview(bookView)
        view.addSubview(resultView)
        topBar.snp.remakeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavgationBarHeight + 22)
        }
        bookView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topBar.snp.bottom)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - 22)
        }
        resultView.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.topBar.snp.bottom)
            make.height.equalTo(ScreenHeight - kNavgationBarHeight - 22)
        }
        resultView.isHidden = true
    }
    
    func searchHotClick(word:String) {
        topBar.textfield.text = word
        request(text: word)
    }
    
    func resultClick(model:ZSAikanParserModel) {
        let infoVC = ZSSearchInfoViewController()
        infoVC.model = model
        self.navigationController?.pushViewController(infoVC, animated: true)
    }
    
    func request(text:String) {
        viewModel.wordClick(word: text)
        bookView.tableView.reloadData()
        viewModel.startRequestBooks()
        viewModel.request(text: text) { [weak self] (book) in
            self?.resultView.isHidden = false
            self?.resultView.addBook(book: book)
        }
    }
    
    //MARK: - ZSTopSearchBarProtocol
    func zsTopSearchBar(topSearchBar: ZSTopSearchBar, searchTextFieldShouldBeginEditing text: String) {
        
    }
    
    func zsTopSearchBar(topSearchBar: ZSTopSearchBar, searchTextFieldEditChanged text: String) {
        if text.length == 0 {
            self.resultView.isHidden = true
            self.viewModel.stopRequestBooks()
            self.resultView.clearBooks()
            self.view.endEditing(true)
        }
    }
    
    func zsTopSearchBar(topSearchBar: ZSTopSearchBar, searchTextFieldReturn text: String) {
        if text.length > 0 {
            self.view.endEditing(true)
            request(text: text)
        }
    }
    
    func zsTopSearchBarCancelButtonClick(topSearchBar: ZSTopSearchBar) {
        self.navigationController?.popViewController(animated: false)
    }

}
