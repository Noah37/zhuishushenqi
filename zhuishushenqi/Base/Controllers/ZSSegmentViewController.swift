//
//  ZSSegmentViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

class ZSSegmentViewController: UIViewController ,UICollectionViewDelegate{

    
    fileprivate var collectionView:UICollectionView!
    fileprivate var segMenu:SegMenu!
    var viewControllers:[UIViewController] = [] {
        didSet {
            setupSegMenu()
            setupChildViewControllers()
            collectionView.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
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
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    fileprivate func configureCollectionView() {
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
    
    fileprivate func setupSegMenu(){
        var titles:[String] = []
        for controller in viewControllers {
            titles.append(controller.title ?? "")
        }
        segMenu = SegMenu(frame: CGRect.zero, WithTitles: titles)
        segMenu.menuDelegate = self
        self.view.addSubview(segMenu)
    }
    
    fileprivate func setupChildViewControllers() {
        for controller in viewControllers {
            addChildViewController(controller)
        }
    }
}

extension ZSSegmentViewController:UICollectionViewDataSource {
    
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

extension ZSSegmentViewController:SegMenuDelegate{
    //MARK: - SegMenuDelegate
    func didSelectAtIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

extension ZSSegmentViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(fabs(scrollView.contentOffset.x/self.view.bounds.width))
        segMenu.selectIndex(index)
    }
}
