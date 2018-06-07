//
//  ZSRootViewController.swift
//  zhuishushenqi
//
//  Created by caony on 2018/5/21.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit
import Then
import RxSwift
import RxCocoa
import RxDataSources

class ZSRootViewController: BaseViewController,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource {
    
    static let kCellHeight:CGFloat = 60

    var tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.estimatedRowHeight = kCellHeight
        $0.rowHeight = UITableViewAutomaticDimension
    }
    
    var collectionView:UICollectionView!
    
    var viewControllers:[UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let items = Observable.just(
            [1,2,3].map{ $0 }
        )
        items.bind(to: tableView.rx.items(cellIdentifier: "eee", cellType: UITableViewCell.self))
         { (row,element,cell) in
            cell.textLabel?.text = ""
        }.disposed(by: DisposeBag())
        
        view.backgroundColor = UIColor.gray
        configureChildViewController()
        configureCollectionView()
    }
    
    func configureChildViewController(){
        let shelvesVC = ZSBookShelvesViewController()
        let forumVC = ZSForumViewController()
        addChildViewController(shelvesVC)
        addChildViewController(forumVC)
        viewControllers.append(shelvesVC)
        viewControllers.append(forumVC)
    }
    
    func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight)
        layout.minimumLineSpacing = 0.01
        layout.minimumInteritemSpacing = 0.01
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return viewControllers.count
    }
    
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        let viewController = viewControllerFor(index: indexPath.row)
        viewController.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(viewController.view)
        return cell
    }

    func viewControllerFor(index:Int) -> UIViewController{
        if index > viewControllers.count - 1 {
            return UIViewController()
        }
        return viewControllers[index]
    }
    
    private func bindViewModel() {
        
    }

}
