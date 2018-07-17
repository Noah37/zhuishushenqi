//
//  ZSHorizonalMoveViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/9.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSHorizonalMoveViewController: UIViewController {
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    var pageViewController:PageViewController = PageViewController()
    
    var record:QSRecord = QSRecord()
    
    var lastIndexPath = IndexPath(item: -1, section: 0)
    
    fileprivate lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight)
        let collection = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collection.qs_registerCellClass(ZSHorizonalMoveCell.self)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if let model = record.chapterModel {
            viewModel.cachedChapter[model.id] = model
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ZSHorizonalMoveViewController:UICollectionViewDataSource,UICollectionViewDelegate {
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.book?.chaptersInfo?.count ?? 1
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let key = viewModel.book?.chaptersInfo?[section].link {
            if let model = viewModel.cachedChapter[key] {
                return model.pages.count
            }
        }
        return 1
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.qs_dequeueReusableCell(ZSHorizonalMoveCell.self, for: indexPath)
        pageViewController = cell.pageViewController
        if indexPath.item > lastIndexPath.item {
            viewModel.fetchNextPage { (page) in
                self.pageViewController.page = page
            }
        } else  if indexPath.item == lastIndexPath.item {
            if indexPath.row > lastIndexPath.row {
                viewModel.fetchNextPage { (page) in
                    self.pageViewController.page = page
                }
            } else {
                viewModel.fetchLastPage { (page) in
                    self.pageViewController.page = page
                }
            }
        } else {
            viewModel.fetchLastPage { (page) in
                self.pageViewController.page = page
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //
        
    }
}

extension ZSHorizonalMoveViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let indexPath = self.collectionView.indexPathsForVisibleItems.first {
            lastIndexPath = indexPath
        }
    }
}
