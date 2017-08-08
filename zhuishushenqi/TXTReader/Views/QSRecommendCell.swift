//
//  QSRecommendCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

typealias BtnClickAction = (_ btn:UIButton)->Void

let RecBtnTag = 12345
//146
class QSRecommendCell: UITableViewCell {

    var books:[Book]? {
        didSet{
            if (books?.count ?? 0) > 0{
                setupSubviews()
            }
        }
    }
    
    var clickAction:BtnClickAction?
    
    @IBOutlet weak var more: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func moreAct(_ sender: Any) {
        let btn:UIButton? = sender as? UIButton
        btn?.tag = RecBtnTag + 4
        touchAction(btn: btn!)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupSubviews(){
        for item in contentView.subviews {
            if item.tag == 123 || item.tag == 124{
                continue
            }
            item.removeFromSuperview()
        }
        let spaceX:CGFloat = 15
        let spaceY:CGFloat = 43
        for item in 0..<4 {
            let witdh = (self.bounds.width - 15*5)/4
            let height:CGFloat = 86
            let x:CGFloat = spaceX*CGFloat(item + 1) + CGFloat(item)*witdh
            let btn = QSInterestdButton(type: .custom)
            btn.frame = CGRect(x: x, y: spaceY, width: witdh, height: height)
            btn.tag = RecBtnTag + item
            btn.addTarget(self, action: #selector(touchAction(btn:)), for: .touchUpInside)
            
            let label = UILabel(frame: CGRect(x: x, y: spaceY + height, width: witdh, height: 40))
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 11)
            label.textColor = UIColor.darkGray
            label.numberOfLines = 0
            
            if (self.books?.count ?? 0) > item {
                label.text = self.books?[item].title
                if let url = self.books?[item].cover{
                    btn.qs_setBookCoverWithUrlString(urlString: url)
                }
            }
            
            self.contentView.addSubview(btn)
            self.contentView.addSubview(label)
        }
    }
    
    @objc func touchAction(btn:UIButton){
        if let action = clickAction {
            action(btn)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
    }
}

class QSInterestdButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.imageView?.contentMode = .scaleToFill
    }
}
