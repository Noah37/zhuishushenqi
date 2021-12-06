//
//  ZSReaderToolbar.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/8.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderToolbarDelegate:class {
    func toolBar(toolBar:ZSReaderToolbar, clickBack:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickListen:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickLast:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickNext:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickCatalog:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickDark:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickSetting:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickMore:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, progress:Float)
    func toolBar(toolBar:ZSReaderToolbar, lightProgress:Float)
    func toolBar(toolBar:ZSReaderToolbar, readerStyle:ZSReaderStyle)
    func toolBar(toolBar:ZSReaderToolbar, fontAdd:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, fontPlus:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, animationStyle:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, select style:ZSReaderPageStyle)

    func toolBarWillShow(toolBar:ZSReaderToolbar)
    func toolBarDidShow(toolBar:ZSReaderToolbar)
    func toolBarWillHiden(toolBar:ZSReaderToolbar)
    func toolBarDidHiden(toolBar:ZSReaderToolbar)
    
    func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView?

}

class ZSReaderToolbar: UIView, ZSReaderTopbarDelegate, ZSReaderBottomBarDelegate, ZSReaderBottomBigBarDelegate,ZSReaderStyleSelectionViewDelegate {
    
    weak var delegate:ZSReaderToolbarDelegate?
    
    private let bottomBarHeight:CGFloat = 140
    private let bottomBarBigHeight:CGFloat = 250
    
    var isToolBarShow:Bool {
        return topBar.frame.origin.y >= 0
    }
    
    lazy var bgView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.0)
        return view
    }()

    lazy var topBar:ZSReaderTopbar = {
        let top = ZSReaderTopbar(frame: CGRect(x: 0, y: -kNavgationBarHeight, width: self.bounds.width, height: kNavgationBarHeight))
        top.delegate = self
        return top
    }()
    
    lazy var bottomBar:ZSReaderBottomBar = {
        let bar = ZSReaderBottomBar(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: bottomBarHeight))
        bar.delegate = self
        return bar
    }()
    
    lazy var bottomBigBar:ZSReaderBottomBigBar = {
        let bar = ZSReaderBottomBigBar(frame: CGRect(x: 0, y: self.bounds.height - bottomBarBigHeight - kTabbarBlankHeight, width: self.bounds.width, height: bottomBarBigHeight + kTabbarBlankHeight))
        bar.delegate = self
        bar.isHidden = true
        return bar
    }()
    
    lazy var readerStyleView:ZSReaderStyleSelectionView = {
        let view = ZSReaderStyleSelectionView(frame: CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 375))
        view.delegate = self
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(bottomBigBar)
        addSubview(readerStyleView)
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        bgView.addGestureRecognizer(tap)
//        let pan = UIPanGestureRecognizer { (_) in
//            
//        }
//        addGestureRecognizer(pan)
        bgView.frame = CGRect(x: 0, y: topBar.height, width: self.bounds.width, height: self.bounds.height - topBar.height - bottomBar.height)
    }
    
    func progress(minValue:Float,maxValue:Float) {
        bottomBar.progressBar.minimumValue = minValue
        bottomBar.progressBar.maximumValue = maxValue
    }
    
    func show(_ animated:Bool) {
        bottomBar.isHidden = false
        bottomBigBar.isHidden = true
        readerStyleView.isHidden = true
        if animated {
            self.delegate?.toolBarWillShow(toolBar: self)
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar.frame.origin.y = 0
                self.bottomBar.frame.origin.y = self.bounds.height - self.bottomBarHeight
                self.bottomBigBar.frame.origin.y = self.bounds.height - self.bottomBarBigHeight - kTabbarBlankHeight
                self.delegate?.toolBarDidShow(toolBar: self)
            }) { (finish) in
            }
//            inView.addSubview(self)
        } else {
            self.delegate?.toolBarWillShow(toolBar: self)
            self.topBar.frame.origin.y = 0
            self.bottomBar.frame.origin.y = self.bounds.height - self.bottomBarHeight
            self.bottomBigBar.frame.origin.y = self.bounds.height - self.bottomBarBigHeight - kTabbarBlankHeight
//            inView.addSubview(self)
            self.delegate?.toolBarDidShow(toolBar: self)
        }
    }
    
    func show(inView:UIView,_ animated:Bool) {
        bottomBar.isHidden = false
        bottomBigBar.isHidden = true
        readerStyleView.isHidden = true
        if animated {
            self.delegate?.toolBarWillShow(toolBar: self)
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar.frame.origin.y = 0
                self.bottomBar.frame.origin.y = self.bounds.height - self.bottomBarHeight
                self.bottomBigBar.frame.origin.y = self.bounds.height - self.bottomBarBigHeight - kTabbarBlankHeight
                self.delegate?.toolBarDidShow(toolBar: self)
            }) { (finish) in
            }
            inView.addSubview(self)
        } else {
            self.delegate?.toolBarWillShow(toolBar: self)
            self.topBar.frame.origin.y = 0
            self.bottomBar.frame.origin.y = self.bounds.height - self.bottomBarHeight
            self.bottomBigBar.frame.origin.y = self.bounds.height - self.bottomBarBigHeight - kTabbarBlankHeight
            inView.addSubview(self)
            self.delegate?.toolBarDidShow(toolBar: self)
        }
    }
    
    func hiden(_ animated:Bool) {
        if animated {
            self.delegate?.toolBarWillHiden(toolBar: self)
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar.frame.origin.y = -kNavgationBarHeight
                self.bottomBar.frame.origin.y = self.bounds.height
                self.bottomBigBar.frame.origin.y = self.bounds.height
                self.readerStyleView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 375)
            }) { (finish) in
                self.delegate?.toolBarDidHiden(toolBar: self)
                self.removeFromSuperview()
            }
        } else {
            self.delegate?.toolBarWillHiden(toolBar: self)
            self.topBar.frame.origin.y = -kNavgationBarHeight
            self.bottomBar.frame.origin.y = self.bounds.height
            self.bottomBigBar.frame.origin.y = self.bounds.height
            self.readerStyleView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 375)
            removeFromSuperview()
            self.delegate?.toolBarDidHiden(toolBar: self)
        }
    }
    
    func bind(title:String) {
        topBar.titleLabel.text = title
    }
    
    func enableFontPlus(_ enable:Bool) {
        self.bottomBigBar.fontPlusButton.isEnabled = enable
        self.bottomBigBar.fontSizeLabel.text = "\(ZSReader.share.theme.fontSize.size)"
    }
    
    func enablFontAdd(_ enable:Bool) {
        self.bottomBigBar.fontAddButton.isEnabled = enable
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func tapAction() {
        hiden(true)
    }
    
    deinit {
        QSLog("释放了")
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
//        let readerPoint = self.convert(point, to: readerStyleView)
//        if readerStyleView.frame.contains(point) {
//            return readerStyleView
//        }
        if let other = delegate?.hitTest(point, with: event) {
            return other
        }
        return view
    }
    
    //MARK: - ZSReaderTopbarDelegate
    func topBar(topBar: ZSReaderTopbar, clickBack: UIButton) {
        removeFromSuperview()
        delegate?.toolBar(toolBar: self, clickBack: clickBack)
    }
    
    func topBar(topBar: ZSReaderTopbar, clickListen: UIButton) {
        delegate?.toolBar(toolBar: self, clickListen: clickListen)
    }
    
    //MARK: - ZSReaderBottomBarDelegate
    func bottomBar(bottomBar:ZSReaderBottomBar, clickLast:UIButton) {
        delegate?.toolBar(toolBar: self, clickLast: clickLast)
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, clickNext:UIButton) {
        delegate?.toolBar(toolBar: self, clickNext: clickNext)
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, clickCatalog:UIButton) {
        delegate?.toolBar(toolBar: self, clickCatalog: clickCatalog)
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, clickDark:UIButton) {
        delegate?.toolBar(toolBar: self, clickDark: clickDark)
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, clickSetting:UIButton) {
        delegate?.toolBar(toolBar: self, clickSetting: clickSetting)
        bottomBar.isHidden = true
        bottomBigBar.isHidden = false
        bgView.frame = CGRect(x: 0, y: topBar.height, width: self.bounds.width, height: self.bounds.height - topBar.height - bottomBigBar.height)
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, progress:Float) {
        delegate?.toolBar(toolBar: self, progress: progress)
    }
    
    //MARK: - ZSReaderBottomBigBarDelegate
    func bigBar(bigBar: ZSReaderBottomBigBar, progress: Float) {
        delegate?.toolBar(toolBar: self, lightProgress: progress)
    }
    
    func bigBar(bigBar: ZSReaderBottomBigBar, readerStyle: ZSReaderStyle) {
        delegate?.toolBar(toolBar: self, readerStyle: readerStyle)
    }
    
    func bigBar(bigBar: ZSReaderBottomBigBar, fontAdd: UIButton) {
        delegate?.toolBar(toolBar: self, fontAdd: fontAdd)
    }
    
    func bigBar(bigBar: ZSReaderBottomBigBar, fontPlus: UIButton) {
        delegate?.toolBar(toolBar: self, fontPlus: fontPlus)
    }
    
    func bigBar(bigBar: ZSReaderBottomBigBar, animationStyle: UIButton) {
        delegate?.toolBar(toolBar: self, animationStyle: animationStyle)
        readerStyleView.isHidden = false
        bottomBar.isHidden = true
        bigBar.isHidden = true
        readerStyleView.frame = CGRect(x: 0, y: self.bounds.height - 375, width: self.bounds.width, height: 375)
        readerStyleView.tableView.reloadData()
    }
    
    func bigBar(bigBar: ZSReaderBottomBigBar, moreSetting: UIButton) {
        delegate?.toolBar(toolBar: self, clickMore: moreSetting)
    }
    
    //MARK: - ZSReaderStyleSelectionViewDelegate
    func style(selectionView:ZSReaderStyleSelectionView, select style:ZSReaderPageStyle) {
        delegate?.toolBar(toolBar: self, select: style)
    }
}
