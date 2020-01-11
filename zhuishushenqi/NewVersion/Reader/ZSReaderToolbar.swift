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
    func toolBar(toolBar:ZSReaderToolbar, clickLast:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickNext:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickCatalog:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickDark:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, clickSetting:UIButton)
    func toolBar(toolBar:ZSReaderToolbar, progress:Float)
    func toolBarWillShow(toolBar:ZSReaderToolbar)
    func toolBarDidShow(toolBar:ZSReaderToolbar)
    func toolBarWillHiden(toolBar:ZSReaderToolbar)
    func toolBarDidHiden(toolBar:ZSReaderToolbar)

}

class ZSReaderToolbar: UIView, ZSReaderTopbarDelegate, ZSReaderBottomBarDelegate {
    
    weak var delegate:ZSReaderToolbarDelegate?
    
    private let bottomBarHeight:CGFloat = 140
    private let bottomBarBigHeight:CGFloat = 250
    
    lazy var bgView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = UIColor(white: 0.0, alpha: 0.4)
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
        bar.isHidden = true
        return bar
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(bgView)
        addSubview(topBar)
        addSubview(bottomBar)
        addSubview(bottomBigBar)
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction))
        bgView.addGestureRecognizer(tap)
    }
    
    func progress(minValue:Float,maxValue:Float) {
        bottomBar.progressBar.minimumValue = minValue
        bottomBar.progressBar.maximumValue = maxValue
    }
    
    func show(inView:UIView,_ animated:Bool) {
        bottomBar.isHidden = false
        bottomBigBar.isHidden = true
        if animated {
            self.delegate?.toolBarWillShow(toolBar: self)
            UIView.animate(withDuration: 0.5, animations: {
                self.topBar.frame.origin.y = 0
                self.bottomBar.frame.origin.y = self.bounds.height - self.bottomBarHeight
                self.delegate?.toolBarDidShow(toolBar: self)
            }) { (finish) in
            }
            inView.addSubview(self)
        } else {
            self.delegate?.toolBarWillShow(toolBar: self)
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
                self.delegate?.toolBarDidHiden(toolBar: self)
            }) { (finish) in
                self.removeFromSuperview()
            }
        } else {
            self.delegate?.toolBarWillHiden(toolBar: self)
            removeFromSuperview()
            self.delegate?.toolBarDidHiden(toolBar: self)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc
    private func tapAction() {
        hiden(true)
    }
    
    //MARK: - ZSReaderTopbarDelegate
    func topBar(topBar: ZSReaderTopbar, clickBack: UIButton) {
        removeFromSuperview()
        delegate?.toolBar(toolBar: self, clickBack: clickBack)
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
    }
    
    func bottomBar(bottomBar:ZSReaderBottomBar, progress:Float) {
        delegate?.toolBar(toolBar: self, progress: progress)
    }
}
