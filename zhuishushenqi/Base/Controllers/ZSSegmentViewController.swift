//
//  ZSSegmentViewController.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2018/8/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

typealias ZSSegmentHandler = (_ index:Int)->Void

protocol ZSSegmenuProtocol {
    func viewControllersForSegmenu(_ segmenu:ZSSegmenuViewController) ->[UIViewController]
    func segmenu(_ segmenu:ZSSegmenuViewController, didSelectSegAt index:Int)
    func segmenu(_ segmenu:ZSSegmenuViewController, didScrollToSegAt index:Int)
}

class ZSSegmenuViewController: UIViewController {
    
    fileprivate var segMenu:SegMenu!
    
    fileprivate var segmentViewController:ZSSegmentViewController = ZSSegmentViewController()
    
    var delegate:ZSSegmenuProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let viewControllers = self.delegate?.viewControllersForSegmenu(self) {
            setupSubviews(viewControllers: viewControllers)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        segMenu.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavgationBarHeight)
            make.height.equalTo(kTootSegmentViewHeight)
        }
        segmentViewController.view.snp.makeConstraints { (make) in
            make.left.bottom.right.equalToSuperview()
            make.top.equalTo(segMenu.snp.bottom)
        }
    }
    
    fileprivate func setupSubviews(viewControllers:[UIViewController]) {
        var titles:[String] = []
        for controller in viewControllers {
            titles.append(controller.title ?? "")
        }
        segMenu = SegMenu(frame: CGRect.zero, WithTitles: titles)
        segMenu.menuDelegate = self
        self.view.addSubview(segMenu)
        
        segmentViewController.scrollViewDidEndDeceleratingHandler = { index in
            self.segMenu.selectIndex(index)
        }
        view.addSubview(segmentViewController.view)
        addChild(segmentViewController)
        segmentViewController.viewControllers = viewControllers
    }
}

extension ZSSegmenuViewController:SegMenuDelegate{
    //MARK: - SegMenuDelegate
    func didSelectAtIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        self.segmentViewController.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
    }
}

class ZSSegmentViewController: UIViewController ,UICollectionViewDelegate{

    
    var collectionView:UICollectionView!
    var viewControllers:[UIViewController] = [] {
        didSet {
            setupChildViewControllers()
        }
    }
    
    var scrollViewDidEndDeceleratingHandler:ZSSegmentHandler?

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureCollectionView()
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
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
    
    func didSelect(index:Int) {
        let indexPath = IndexPath(item: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    
    fileprivate func configureCollectionView() {
        let layout = UICollectionViewFlowLayout()
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
    
    fileprivate func setupChildViewControllers() {
        for controller in viewControllers {
            addChild(controller)
        }
    }
}

extension ZSSegmentViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
    
    func viewControllerFor(index:Int) -> UIViewController{
        if index > viewControllers.count - 1 {
            return UIViewController()
        }
        return viewControllers[index]
    }
}

extension ZSSegmentViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(abs(scrollView.contentOffset.x/self.view.bounds.width))
        scrollViewDidEndDeceleratingHandler?(index)
    }
}
