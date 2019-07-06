//
//  ZSBookReviewViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/10/27.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import RxSwift
import MJRefresh

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
        
    }
    
    private func setupSubviews() {
        
        scrollView = UIScrollView(frame: self.view.bounds)
        scrollView.delegate = self
        scrollView.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        
        detailView = ZSReviewDetailView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 0))
        scrollView.addSubview(detailView)
        
        bestReviewView = ZSBestReviewView(frame:CGRect(x: 0, y: self.detailView.frame.maxY, width: self.view.bounds.width, height: 0))
        bestReviewView.backgroundColor = UIColor.red
        scrollView.addSubview(bestReviewView)
        
        normalReviewView = ZSBestReviewView(frame:CGRect(x: 0, y: self.bestReviewView.frame.maxY, width: self.view.bounds.width, height: 0))
        normalReviewView.backgroundColor = UIColor.green
        scrollView.addSubview(normalReviewView)
        
        let header = initRefreshHeader(scrollView) {
            self.viewModel.fetchCommentDetail(handler: { (detail) in
                self.setupSubviews()
                self.zs_layoutSubviews()
            })
            self.viewModel.fetchNewNormal(handler: { (normals) in
                self.normalReviewView.models = normals
            })
            self.viewModel.fetchCommentBest(handler: { (best) in
                self.bestReviewView.models = best
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
            if layoutModel == nil {
                layoutModel = ZSBookCTLayoutModel(book: detail, data: data)
            } else {
                layoutModel?.setupLayout(book: detail, data: data)
            }
            let height = layoutModel?.totalHeight ?? 0
            detailView.height = height
            detailView.setupDetail(detail: detail, data: data)
            scrollView.contentSize = CGSize(width: self.view.bounds.width, height: height)
        }
    }
}
