//
//  EmptyView.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/17.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias ReloadAction = ()->Void

protocol EmptyViewDelegate {
    func didClickReloadButton()
}

class EmptyView: UIView {

    @IBOutlet weak var emptyBtn: UIButton!
   
    @IBOutlet weak var title: UILabel!
    
    var delegate:EmptyViewDelegate?
    
    var reloadAction:ReloadAction?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    var tittle:String = "暂无数据，点击重新加载" {
        didSet{
            self.title.text = tittle
        }
    }
    
    var image:UIImage? = UIImage(named: "sure_placeholder_error") {
        didSet{
            emptyBtn.setImage(image, for: .normal)
        }
    }

    @IBAction func emptyAction(_ sender: Any) {
        delegate?.didClickReloadButton()
        if let action = self.reloadAction {
            action()
        }
    }
    
    
}
