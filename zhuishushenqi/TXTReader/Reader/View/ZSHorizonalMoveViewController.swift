//
//  ZSHorizonalMoveViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/7/9.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSHorizonalMoveViewController: UIViewController {
    
    let collectionMaxRows = 1000000
    
    var viewModel:ZSReaderViewModel = ZSReaderViewModel()
    
    var pageViewController:PageViewController = PageViewController()
    
    var record:QSRecord = QSRecord()
    
    var cachedChapter:[String:QSChapter] = [:]
    
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ZSHorizonalMoveViewController:UICollectionViewDataSource,UICollectionViewDelegate {

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionMaxRows
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.qs_dequeueReusableCell(ZSHorizonalMoveCell.self, for: indexPath)
        pageViewController = cell.pageViewController
        collectionMaxRows%3
        return cell
    }
}
