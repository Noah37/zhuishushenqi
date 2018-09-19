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

class ZSRootViewController: UIViewController,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,SegMenuDelegate {
    
    static let kCellHeight:CGFloat = 60

    var tableView = UITableView(frame: CGRect.zero, style: .grouped).then {
        $0.estimatedRowHeight = kCellHeight
        $0.rowHeight = UITableView.automaticDimension
    }
    
    var collectionView:UICollectionView!
    var segMenu:SegMenu!
    
    var viewControllers:[UIViewController] = []
    let disposeBag = DisposeBag()
    
    private var recView:QSLaunchRecView!
    private var tipImageView:UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(showRecommend), name: Notification.Name(rawValue:SHOW_RECOMMEND), object: nil)
        
        RootNavigationView.make(delegate: self,leftAction: #selector(leftAction(_:)),rightAction: #selector(rightAction(_:)))
        setupSegMenu()
        
        /*
        let items = Observable.just(
            [1,2,3].map{ $0 }
        )
        items.bind(to: tableView.rx.items(cellIdentifier: "eee", cellType: UITableViewCell.self))
         { (row,element,cell) in
            cell.textLabel?.text = ""
        }.disposed(by: DisposeBag())
         */
        
        view.backgroundColor = UIColor.cyan
        configureChildViewController()
        configureCollectionView()
        configureCollectionOffset()
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
    
    func configureChildViewController(){
        let shelvesVC = ZSShelfViewController()
        let forumVC = ZSForumViewController()
        addChild(shelvesVC)
        addChild(forumVC)
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
    
    func configureCollectionOffset() -> Void {
        collectionView.rx.contentOffset
            .subscribe{ point in
//                QSLog(point)
            }
            .disposed(by: disposeBag)
    
        collectionView.rx.didEndDecelerating
            .subscribe { _ in
                let contentOffset = self.collectionView.contentOffset
                if contentOffset.x.truncatingRemainder(dividingBy: ScreenWidth) == 0 {
                    let index = contentOffset.x/ScreenWidth
                    self.segMenu.selectIndex(Int(index))
                }
            }
            .disposed(by: disposeBag)
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
    
    @objc
    private func showRecommend(){
        // animate
        let nib = UINib(nibName: "QSLaunchRecView", bundle: nil)
        recView = nib.instantiate(withOwner: nil, options: nil).first as? QSLaunchRecView
        recView.frame = self.view.bounds
        recView.alpha = 0.0
        recView.closeCallback = { (btn) in
            self.dismissRecView()
        }
        recView.boyTipCallback = { (btn) in
            self.fetchRecList(index: 0)
            self.perform(#selector(self.dismissRecView), with: nil, afterDelay: 1)
        }
        
        recView?.girlTipCallback = { (btn) in
            self.fetchRecList(index: 1)
            self.perform(#selector(self.dismissRecView), with: nil, afterDelay: 1)
        }
        KeyWindow?.addSubview(recView)
        UIView.animate(withDuration: 0.35, animations: {
            self.recView.alpha = 1.0
        }) { (finished) in
            
        }
    }
    
    @objc
    func dismissRecView(){
        UIView.animate(withDuration: 0.35, animations: {
            self.recView.alpha = 0.0
        }) { (finished) in
            self.recView.removeFromSuperview()
            self.showUserTipView()
        }
    }
    
    @objc
    func dismissTipView(sender:Any){
        tipImageView.removeFromSuperview()
    }
    
    func showUserTipView(){
        tipImageView = UIImageView(frame: self.view.bounds)
        tipImageView.image = UIImage(named: "add_book_hint")
        tipImageView.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissTipView(sender:)))
        tipImageView.addGestureRecognizer(tap)
        KeyWindow?.addSubview(tipImageView)
    }
    
    func fetchRecList(index:Int){
        let gender = ["male","female"]
        let recURL = "\(BASEURL)/book/recommend?gender=\(gender[index])"
        zs_get(recURL) { (json) in
            if let books = json?["books"] as? [Any] {
                if let models = [BookDetail].deserialize(from: books) as? [BookDetail] {
                    BookManager.shared.modifyBookshelf(books: models)
                }
            }
        }
    }
    
    //MARK: - SegMenuDelegate
    func didSelectAtIndex(_ index:Int){
        let indexPath = IndexPath(row: index, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
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
