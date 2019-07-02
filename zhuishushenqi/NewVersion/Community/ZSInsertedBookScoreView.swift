//
//  ZSInsertedBookScoreView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/7/2.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSInsertedBookScoreViewHandler = ()->Void

class ZSInsertedBookScoreView: UIView {
    
    lazy var backgroundView:UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = UIColor.init(red: 0.94, green: 0.94, blue: 0.96, alpha: 1)
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    lazy var bookIconView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    lazy var scoreView:UIImageView = {
        let view = UIImageView(frame: .zero)
        return view
    }()
    
    lazy var bookNameLabel:UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = UIColor.black
        view.font = UIFont.systemFont(ofSize: 17)
        return view
    }()
    
    lazy var scoreLabel:UILabel = {
        let view = UILabel(frame: .zero)
        view.textColor = UIColor.init(red: 0.68, green: 0.68, blue: 0.68, alpha: 1)
        view.font = UIFont.systemFont(ofSize: 14)
        return view
    }()
    
    lazy var touchableView:UIControl = {
        let control = UIControl(frame: .zero)
        control.addTarget(self, action: #selector(touchAction(control:)), for: .touchUpInside)
        return control
    }()
    
    var touchHandler:ZSInsertedBookScoreViewHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backgroundView)
        addSubview(bookIconView)
        addSubview(bookNameLabel)
        addSubview(scoreLabel)
        addSubview(scoreView)
        addSubview(touchableView)
        isUserInteractionEnabled = true
        self.layer.masksToBounds = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        backgroundView.frame = self.bounds
        bookIconView.frame = CGRect(x: 20, y: 14, width: 68, height: 93)
        bookNameLabel.frame = CGRect(x: 102, y: 14, width: bounds.width - 102 - 10, height: 24)
        scoreLabel.frame = CGRect(x: 102, y: 53, width: bounds.width - 102 - 10, height: 20)
        scoreView.frame = CGRect(x: 102, y: 81.5, width: 150, height: 25)
        touchableView.frame = self.bounds
    }
    
    func configure(model:ZSHotBook?) {
        if let book = model {
            self.bookIconView.qs_setBookCoverWithURLString(urlString: book.cover)
            self.bookNameLabel.text = "\(book.title)"
            self.scoreLabel.text = "楼主打分"
            self.scoreView.image = UIImage(named: "")
        }
        
    }
    
    @objc
    private func touchAction(control:UIControl) {
        touchHandler?()
    }
}
