
//
//  FilterThemeViewController.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit
import ZSAPI
import SnapKit

class ZSFilterThemeViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var collectionView:UICollectionView!
    private var viewModel:ZSFilterThemeViewModel = ZSFilterThemeViewModel()
    var clickAction:ClickAction?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "筛选书单"
        configureCollectionView()
        viewModel.request { (_) in
            self.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubview()
    }
    
    override func viewWillLayoutSubviews() {
        layoutSubview()
    }
    
    private func layoutSubview() {
        collectionView.snp.remakeConstraints { (make) in
            make.left.equalToSuperview().offset(0)
            make.right.equalToSuperview().offset(0)
            make.top.bottom.equalToSuperview()
        }
    }
    
    fileprivate func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 15
        layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.isPagingEnabled = true
        collectionView.register(ZSFilterThemeCell.self, forCellWithReuseIdentifier: "ZSFilterThemeCell")
        collectionView.register(ZSCatelogHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZSCatelogHeaderView")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        
        view.addSubview(collectionView)
        
        view.backgroundColor = UIColor.white
    }
    
    //MARK: - UICollectionView
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items[section].tags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ZSFilterThemeCell", for: indexPath) as! ZSFilterThemeCell
        cell.layer.cornerRadius = 5
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.titleLabel.text = viewModel.items[indexPath.section].tags[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: collectionView.bounds.size.width - 30, height: 30)
        }
        return CGSize(width: 80, height: 30)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let name = viewModel.items[section].name
        if name.count > 0 {
            return CGSize(width: self.collectionView.bounds.width, height: 40)
        }
        return CGSize(width: self.collectionView.bounds.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "ZSCatelogHeaderView", for: indexPath) as! ZSCatelogHeaderView
        let name = viewModel.items[indexPath.section].name
        headerView.titleLabel.text = name
        return headerView
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let click = self.clickAction {
            _ = self.navigationController?.popViewController(animated: true)
            let item = viewModel.items[indexPath.section].tags[indexPath.row]
            click(indexPath.row,item,viewModel.items[indexPath.section].name)
        }
    }
}

typealias ClickAction = (_ index:Int,_ title:String,_ name:String)->Void
