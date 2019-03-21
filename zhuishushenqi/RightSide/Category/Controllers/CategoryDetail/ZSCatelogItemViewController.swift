//
//  QSRankInteractor.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

class ZSCatelogItemViewController: ZSBaseSegmentItemViewController {
    
//    override var viewModel: ZSSegmentBaseViewProtocol?
    
    private let _viewModel = ZSCatelogDetailViewModel()
    override var viewModel: ZSCatelogDetailViewModel {
        return _viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = viewModel.parameterModel?.major
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func request() {
        
        viewModel.request { (_) in
            self.tableView.reloadData()
        }
    }
}
