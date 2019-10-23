//
//  ZSSearchHotView.swift
//  zhuishushenqi
//
//  Created by caony on 2019/10/22.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

class ZSSearchHotView: UIView {
    
    var cellsFrame:[ZSSearchHotwords] = [] { didSet { reloadData() } }

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
        let marginX:CGFloat = 20
        let marginY:CGFloat = 15
        let cellHeight:CGFloat = 28
        let spaceX:CGFloat = 15
        let spaceY:CGFloat = 20
        var cellX = marginX
        var cellY = marginY
        var index = 0
        for cell in cellsFrame {
            let cellWidth = cell.word.qs_width(13, height: cellHeight/2)
            let cell = ZSSearchHotCell(title: cell.word, maxSize: CGSize(width: cellWidth, height: cellHeight))
            if (cellX + cellWidth + marginX + spaceX) > UIScreen.main.bounds.width {
                cellY += (cellHeight + spaceY)
                cellX = 0
            } else if index != 0 {
                cellX += spaceX
            }
            cell.frame = CGRect(x: cellX, y: cellY, width: cellWidth, height: cellHeight)
            addSubview(cell)
            cellX += cellWidth
            index += 1
        }
    }
    
}

class ZSSearchHotCell: UIView {
    
    lazy var titleLabel:UILabel = {
        let lb = UILabel(frame: .zero)
        lb.textColor = UIColor.gray
        lb.font = UIFont.systemFont(ofSize: 13)
        lb.textAlignment = .center
        return lb
    }()
    
    convenience init(title:String, maxSize:CGSize) {
        self.init()
        addSubview(self.titleLabel)
        self.titleLabel.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
