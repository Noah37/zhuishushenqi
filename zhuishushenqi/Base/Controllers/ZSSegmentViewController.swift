//
//  ZSSegmentViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2018/8/13.
//  Copyright © 2018年 QS. All rights reserved.
//

import UIKit

protocol ZSSegmentProtocol {
    func segmentViewControllers() ->[UIViewController]
}

class ZSSegmentViewController: UIViewController ,UICollectionViewDelegate{

    
    var delegate:ZSSegmentProtocol?
    private var collectionView:UICollectionView!
    
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
    
    override func viewWillLayoutSubviews() {
        collectionView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
        }
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func scrollToItem(at indexPath: IndexPath, at scrollPosition: UICollectionView.ScrollPosition, animated: Bool) {
        self.collectionView.scrollToItem(at: indexPath, at: scrollPosition, animated: animated)
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
}

extension ZSSegmentViewController:UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    //MARK: -
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let viewControllers = self.delegate?.segmentViewControllers() {
            return viewControllers.count
        }
        return 0
    }
    
    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UICollectionViewCell", for: indexPath)
        cell.contentView.backgroundColor = UIColor.white
        if let viewControllers = self.delegate?.segmentViewControllers() {
            cell.contentView.removeAllSubviews()
            let viewController = viewControllers[indexPath.item]
            viewController.view.frame = cell.contentView.bounds
            if let _ = viewController.view.superview {
                viewController.view.removeFromSuperview()
            }
            if let _ = viewController.parent {
                viewController.removeFromParent()
            }
            addChild(viewController)
            cell.contentView.addSubview(viewController.view)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.bounds.width, height: self.view.bounds.height)
    }
}

extension ZSSegmentViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index:Int = Int(abs(scrollView.contentOffset.x/self.view.bounds.width))
        scrollViewDidEndDeceleratingHandler?(index)
    }
}
