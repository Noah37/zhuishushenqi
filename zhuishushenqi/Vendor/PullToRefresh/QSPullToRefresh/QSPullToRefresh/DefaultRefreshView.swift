//
//  DefaultRefreshView.swift
//  PullToRefreshDemo
//
//  Created by Serhii Butenko on 26/7/16.
//  Copyright © 2016 Yalantis. All rights reserved.
//

import UIKit

class DefaultRefreshView: UIView {
    
    fileprivate(set) lazy var activityIndicator: UIActivityIndicatorView! = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        self.addSubview(activityIndicator)
        return activityIndicator
    }()
    
    fileprivate lazy var tipLabel:UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: self.bounds.height/2 - 21/2, width: self.bounds.width, height: 21)
        label.textColor = UIColor.darkGray
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    init(frame: CGRect,tip:String) {
        super.init(frame: frame)
        tipLabel.text = tip
        self.addSubview(tipLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        centerActivityIndicator()
        setupFrame(in: superview)
        
        super.layoutSubviews()
    }
    
    override func willMove(toSuperview newSuperview: UIView?) {
        super.willMove(toSuperview: newSuperview)
        centerActivityIndicator()
        setupFrame(in: superview)
    }
}

private extension DefaultRefreshView {
    
    func setupFrame(in newSuperview: UIView?) {
        guard let superview = newSuperview else { return }

        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: superview.frame.width, height: frame.height)
    }
    
     func centerActivityIndicator() {
        
        let width = widthOfString(tipLabel.text ?? "", font: UIFont.systemFont(ofSize: 13), height: 21)
        let qsCenter = CGPoint(x: self.center.x - width, y: self.center.y)
        tipLabel.frame = CGRect(x: 0, y: self.bounds.height/2 - 21/2, width: self.bounds.width, height: 21)
        activityIndicator.center = convert(qsCenter, from: superview)
    }
    
    func widthOfString(_ str:String, font:UIFont,height:CGFloat) ->CGFloat
    {
        let dict = [NSFontAttributeName:font]
        let sttt:NSString = str as NSString
        let rect:CGRect = sttt.boundingRect(with: CGSize(width: CGFloat(MAXFLOAT), height: CGFloat(height)), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: dict, context: nil)
        return rect.size.width
    }
}
