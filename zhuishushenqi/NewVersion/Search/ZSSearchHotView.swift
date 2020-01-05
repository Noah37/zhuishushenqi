//
//  ZSSearchHotView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSSearchClickHandler = (_ hotword:String)->Void

class ZSSearchHotView: UIView {
    
    var cellsFrame:[ZSSearchHotwords] = [] { didSet { reloadData() } }
    
    var clickHandler:ZSSearchClickHandler?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
    
    func reloadData() {
        removeAllSubviews()
        
        for cellModel in cellsFrame {
            let cell = ZSSearchHotCell(title: cellModel.word, maxSize: cellModel.frame.size)
            let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
            cell.addGestureRecognizer(tap)
            cell.frame = cellModel.frame
            addSubview(cell)
        }
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        for cellModel in cellsFrame {
            if cellModel.frame.contains(tap.location(in: self)) {
                clickHandler?(cellModel.word)
                break
            }
        }
    }
}

class ZSSearchHotCell: UIView {
    
    lazy var titleLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .center
        lb.layer.borderWidth = 0.3
        lb.layer.borderColor = UIColor.gray.cgColor
        lb.layer.cornerRadius = 14
        return lb
    }()
    
    convenience init(title:String, maxSize:CGSize) {
        self.init()
        addSubview(self.titleLabel)
        self.titleLabel.text = title
        self.titleLabel.frame = CGRect(x: 0, y: 0, width: maxSize.width, height: maxSize.height)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
