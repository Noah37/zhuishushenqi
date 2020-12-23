//
//  ZSDiscoverHeaderView.swift
//  zhuishushenqi
//
//  Created by yung on 2019/7/7.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

typealias ZSDiscoverHandler = (_ index:Int)->Void

class ZSDiscoverHeaderView: UITableViewHeaderFooterView {
    
    var items:[UIButton] = []
    
    var handler:ZSDiscoverHandler?

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        for item in 0..<items.count {
            let button = items[item]
            let width:CGFloat = 109
            let height:CGFloat = 50
            let x = (bounds.width - 3*width - 2 * 10)/2 + CGFloat(item) * width + CGFloat(item * 10)
            button.frame = CGRect(x: x, y: 20, width: width, height: height)
        }
    }
    
    func setupSubviews() {
        contentView.backgroundColor = UIColor.white
        let images:[String] = ["discover_classify_108x50_", "discover_Ranking_109x50_", "discover_booklist_108x50_"]
        let titles:[String] = ["分类", "排行", "书单"]
        for item in 0..<images.count {
            let button = UIButton(type: .custom)
            button.setBackgroundImage(UIImage(named: "\(images[item])"), for: .normal)
            button.addTarget(self, action: #selector(itemAction(btn:)), for: .touchUpInside)
            button.setTitle("\(titles[item])", for: .normal)
            button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
            items.append(button)
            contentView.addSubview(button)
        }
    }
    
    @objc
    private func itemAction(btn:UIButton) {
        for item in 0..<items.count {
            let button = items[item]
            if btn == button {
                handler?(item)
            }
        }
    }
}
