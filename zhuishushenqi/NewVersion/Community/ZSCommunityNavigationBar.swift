//
//  ZSCommunityNavigationBar.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSCommunityNavigationBarDelegate:class {
    func navView(navView:ZSCommunityNavigationBar, didSelectRight at:Int)
    func navView(navView:ZSCommunityNavigationBar, didSelectLeft at:Int)
}

class ZSCommunityNavigationBar: UIView, ZSVoiceSegmentProtocol {
    
    lazy var titleView:ZSVoiceSegmentView = {
        let titleView = ZSVoiceSegmentView(frame: .zero)
        titleView.delegate = self
        titleView.backgroundColor = UIColor.clear
        titleView.collectionView.backgroundColor = UIColor.clear
        titleView.type = .bigselect
        return titleView
    }()
    
    var titles:[String] = ["热门","关注","论坛"]
    
    private var navButtons:[UIButton] = []
    private var navImages:[ShelfNav] = []
    
    weak var delegate:ZSCommunityNavigationBarDelegate?
    
    convenience init(navImages:[ShelfNav], delegate:ZSCommunityNavigationBarDelegate?) {
        self.init(frame: CGRect.zero)
        self.navImages = navImages
        self.delegate = delegate
        configureNavButtons()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleView)
        self.backgroundColor = UIColor.init(hexString: "#A70A0B")    
        isUserInteractionEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleView.frame = CGRect(x: 20, y: kNavgationBarHeight - 44, width: 240, height: 44)
        
        var index = navButtons.count - 1
        while index >= 0 {
            let btn = navButtons[index]
            let originX = self.bounds.width - CGFloat(navButtons.count - index) * 42 - 13
            btn.frame = CGRect(x: originX, y: kNavgationBarHeight - 44, width: 42, height: 42)
            index -= 1
        }
    }
    
    private func configureNavButtons() {
        for image in navImages {
            let btn = UIButton(type: .custom)
            btn.setImage(image.image, for: .normal)
            btn.addTarget(self, action: #selector(navAction(btn:)), for: .touchUpInside)
            addSubview(btn)
            navButtons.append(btn)
        }
    }
    
    @objc
    private func navAction(btn:UIButton) {
        var index = 0
        for button in navButtons {
            if button == btn {
                break
            }
            index += 1
        }
        delegate?.navView(navView: self, didSelectRight: index)
    }
    
    //MARK: - ZSVoiceSegmentProtocol
    func titlesForSegment(segmentView: ZSVoiceSegmentView) -> [String] {
        return titles
    }
    
    func didSelect(segment: ZSVoiceSegmentView, at index: Int) {
        delegate?.navView(navView: self, didSelectLeft: index)
    }
    
}
