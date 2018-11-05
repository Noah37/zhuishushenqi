//
//  ZSBookReviewViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift

class ZSBookReviewDetailViewController: BaseViewController, UIScrollViewDelegate, Refreshable {
    
    var scrollView:UIScrollView!
    var detailView:ZSReviewDetailView!
    var bestReviewView:ZSBestReviewView!
    var normalReviewView:ZSBestReviewView!
    
    var viewModel:ZSBookCTViewModel = ZSBookCTViewModel()
    
    var headerRefresh:MJRefreshHeader?
    var footerRefresh:MJRefreshFooter?
    
    var disposeBag = DisposeBag()
    
    var layoutModel:ZSBookCTLayoutModel?


    override func viewDidLoad() {
        super.viewDidLoad()

        setupSubviews()
    }
    
    private func setupSubviews() {
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        detailView = ZSReviewDetailView(frame: CGRect.zero)
        detailView.backgroundColor = UIColor.orange
        view.addSubview(detailView)
        
        bestReviewView = ZSBestReviewView(frame:CGRect.zero)
        bestReviewView.backgroundColor = UIColor.red
        view.addSubview(bestReviewView)
        
        normalReviewView = ZSBestReviewView(frame:CGRect.zero)
        normalReviewView.backgroundColor = UIColor.green
        view.addSubview(normalReviewView)
        
        let header = initRefreshHeader(scrollView) {
            self.viewModel.fetchCommentDetail(handler: { (detail) in
                
            })
            self.viewModel.fetchNewNormal(handler: { (normals) in
                
            })
            self.viewModel.fetchCommentBest(handler: { (best) in
                
            })
        }
        let footer = initRefreshFooter(scrollView) {
            if let _  = self.viewModel.best {
                
            } else {
                self.viewModel.fetchCommentBest(handler: { (best) in
                    if let _ = self.viewModel.best {
                        
                    }
                })
            }
            self.viewModel.fetchNormalMore(handler: { (more) in
                
            })
        }
        headerRefresh = header
        footerRefresh = footer
        
        headerRefresh?.beginRefreshing()
        viewModel.autoSetRefreshHeaderStatus(header: header, footer: footer).disposed(by: disposeBag)
    }
    
    func zs_layoutSubviews() {
        if let detail = viewModel.detail,let data = viewModel.data {
            layoutModel = ZSBookCTLayoutModel(book: detail, data: data)
            
        }
    }
}
