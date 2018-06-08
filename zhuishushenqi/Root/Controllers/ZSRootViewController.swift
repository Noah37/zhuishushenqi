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

class ZSRootViewController: UIViewController,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SegMenuDelegate {
    
    static let kCellHeight:CGFloat = 60

    var tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.estimatedRowHeight = kCellHeight
        $0.rowHeight = UITableViewAutomaticDimension
    }
    
    var collectionView:UICollectionView!
    var segMenu:SegMenu!
    
    var viewControllers:[UIViewController] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        RootNavigationView.make(delegate: self,leftAction: #selector(leftAction(_:)),rightAction: #selector(rightAction(_:)))
        setupSegMenu()
        
        let items = Observable.just(
            [1,2,3].map{ $0 }
        )
        items.bind(to: tableView.rx.items(cellIdentifier: "eee", cellType: UITableViewCell.self))
         { (row,element,cell) in
            cell.textLabel?.text = ""
        }.disposed(by: DisposeBag())
        
        view.backgroundColor = UIColor.cyan
        configureChildViewController()
        configureCollectionView()
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.navigationBar.barTintColor = UIColor.green

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segMenu.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavgationBarHeight)
            make.height.equalTo(kTootSegmentViewHeight)
        }
        
        collectionView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(segMenu.snp.bottom)
        }
        
        if #available(iOS 11.0, *) {
            collectionView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        
//        self.navigationController?.navigationBar.barTintColor = UIColor ( red: 0.7235, green: 0.0, blue: 0.1146, alpha: 1.0 )
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
        layout.itemSize = CGSize(width: ScreenWidth, height: ScreenHeight - kNavgationBarHeight - kTootSegmentViewHeight)
        layout.minimumLineSpacing = 0.01
        layout.minimumInteritemSpacing = 0.01
        layout.scrollDirection = .horizontal
        collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate  = self
        collectionView.isPagingEnabled = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "UICollectionViewCell")
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.white
        view.addSubview(collectionView)
    }
    
    @objc func leftAction(_ btn:UIButton){
        SideVC.showLeftViewController()
    }
    
    @objc func rightAction(_ btn:UIButton){
        SideVC.showRightViewController()
    }
    
    fileprivate func setupSegMenu(){
        segMenu = SegMenu(frame: CGRect.zero, WithTitles: ["追书架","追书社区"])
        segMenu.menuDelegate = self
        self.view.addSubview(segMenu)
    }
    
    func didSelectAtIndex(_ index:Int){
        
    }
    
    //MARK: -
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
}
