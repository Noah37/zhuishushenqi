//
//  CategoryViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import QSNetwork

class ZSCatelogViewController:BaseViewController {
    
    var collectionView:UICollectionView!
    var viewModel:ZSCatelogViewModel = ZSCatelogViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "分类"
        configureCollectionView()
        request()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView.frame = self.view.bounds
    }
    
    fileprivate func request() {
        viewModel.request { (_) in
            self.collectionView.reloadData()
        }
    }
    
    fileprivate func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0.01
        layout.minimumInteritemSpacing = 0.01
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.isPagingEnabled = true
        collectionView.register(ZSCatelogCell.self, forCellWithReuseIdentifier: "ZSCatelogCell")
        collectionView.register(ZSCatelogHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZSCatelogHeaderView")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
}

extension ZSCatelogViewController:UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.catelogModel.sections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let items = viewModel.catelogModel.items(at: section)
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZSCatelogCell", for: indexPath) as? ZSCatelogCell
        let items = viewModel.catelogModel.items(at: indexPath.section)
        cell?.updateCell(items[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width/2 - 10, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: self.collectionView.bounds.width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZSCatelogHeaderView", for: indexPath) as! ZSCatelogHeaderView
        let name = viewModel.catelogModel.name(for: indexPath.section)
        headerView.titleLabel.text = name
        return headerView
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catalogDetailVC = ZSCatelogDetailViewController()
        let item = viewModel.catelogModel.items(at: indexPath.section)[indexPath.row]
        let gender = viewModel.catelogModel.gender(for: indexPath.section)
        catalogDetailVC.parameterModel = ZSCatelogParameterModel(major: item.name, gender: gender)
        self.navigationController?.pushViewController(catalogDetailVC, animated: true)
    }
}

//http://api.zhuishushenqi.com/cats/lv2/statistics
