//
//  ZSReaderThemeSelectionView.swift
//  zhuishushenqi
//
//  Created by caony on 2020/1/11.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit

protocol ZSReaderThemeSelectionViewDelegate:class {
    func selectionView(selectionView:ZSReaderThemeSelectionView, select:ZSReaderStyle)
}

class ZSReaderThemeSelectionView: UIView {

    weak var delegate:ZSReaderThemeSelectionViewDelegate?
    
    lazy var scrollView:UIScrollView = {
        let view = UIScrollView(frame: self.bounds)
        if #available(iOS 13.0, *) {
            view.automaticallyAdjustsScrollIndicatorInsets = false
        } else {
            // Fallback on earlier versions
        }
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(scrollView)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        let marginX:CGFloat = 20
        let spaceX:CGFloat = 15
        let width:CGFloat = (UIScreen.main.bounds.width - marginX * 2 - spaceX * 3)/4.0
        let height:CGFloat = 40
        for index in 0..<ZSReaderStyle.count {
            if let style = ZSReaderStyle(rawValue: index) {
               let bt = selectionButton(style: style)
                bt.frame = CGRect(x: marginX + (width + spaceX) * CGFloat(index), y: 0, width: width, height: height)
                bt.addTarget(self, action: #selector(tapAction(bt:)), for: .touchUpInside)
                scrollView.addSubview(bt)
                scrollView.contentSize = CGSize(width: bt.frame.maxX + width + marginX, height: 40)
            }
        }
    }
    
    @objc
    private func tapAction(bt:UIButton) {
        if let style = ZSReaderStyle(rawValue: bt.tag) {
            delegate?.selectionView(selectionView: self, select: style)
        }
    }
    
    private func selectionButton(style:ZSReaderStyle) ->UIButton {
        let bt = UIButton(type: .custom)
        bt.frame = CGRect(x: 0, y: 0, width: 82.5, height: 40)
        bt.layer.cornerRadius = 20
        bt.layer.masksToBounds = true
        bt.tag = style.rawValue
        bt.layer.borderColor = style.borderColor.cgColor
        bt.layer.borderWidth = 0.5
        bt.setImage(style.backgroundImage, for: .normal)
        return bt
    }
}
