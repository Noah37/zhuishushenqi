//
//  FilterThemeCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

enum FilterType {
    case list
    case all
}

protocol FilterThemeCellDelegate {
    func didSelectedTag(index:Int,title:String,name:String)
}

class FilterThemeCell: UITableViewCell {

    var model:NSDictionary? {
        didSet{
            if model?["name"] as? String != "" {
                makeSubviews(dictModel: model)
            }
        }
    }
    
    var delegate:FilterThemeCellDelegate?
    var headerLabel:UILabel?
    var cellH:CGFloat = 0.0
    private var type:FilterType = .list
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
    }
    
    func makeSubviews(dictModel:NSDictionary?){
        if let name = dictModel?["name"] as? String {
            if name == "all" {
                type = .all
            }else{
                let label = UILabel()
                label.frame = CGRect(x: 15, y: 0, width: self.bounds.width - 30, height: 30)
                label.textColor = UIColor.darkGray
                label.font = UIFont.systemFont(ofSize: 11)
                label.text = dictModel?["name"] as? String
                headerLabel = label
                addSubview(headerLabel!)
            }
        }
        if let tags = dictModel?["tags"] as? [String] {
            for index in 0..<tags.count{
                let row = index/4
                let col = index%4
                var width:CGFloat = (self.bounds.width - 15*5)/4
                let height:CGFloat = 30
                let x = CGFloat(15*(col + 1)) + CGFloat(col)*width
                var y = CGFloat(row)*height + CGFloat(10*row) + 30
                let btn = UIButton(type: .custom)
                if type == .all {
                   width  = self.bounds.width - 30
                    y = CGFloat(row)*height + CGFloat(10*row) + 15
                }
                btn.frame = CGRect(x: x, y: y, width: width, height: height)
                btn.setTitle(tags[index], for: .normal)
                btn.setTitleColor(UIColor.gray, for: .normal)
                btn.layer.cornerRadius = 3
                btn.titleLabel?.font = UIFont.systemFont(ofSize: 13)
                btn.layer.borderWidth = 1
                btn.tag = index + 11111
                btn.layer.borderColor = UIColor(red: 0.52, green: 0.52, blue: 0.52, alpha: 0.3).cgColor
                btn.addTarget(self, action: #selector(tagSelectAction(btn:)), for: .touchUpInside)
                addSubview(btn)
                cellH = y + height
            }
        }
    }
    
    @objc func tagSelectAction(btn:UIButton){
        if delegate != nil {
            delegate?.didSelectedTag(index: btn.tag - 11111, title: btn.titleLabel?.text ?? "", name: headerLabel?.text ?? "")
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func cellHeight(cellModel:NSDictionary?) ->CGFloat{
        let cell = FilterThemeCell(style: .default, reuseIdentifier: "FilterThemeCell")
        
        cell.makeSubviews(dictModel: cellModel)
        
        return cell.cellH
    }
    
    override func prepareForReuse() {
        type = .list
        let subviews = self.subviews
        for index in 0..<subviews.count {
            subviews[index].removeFromSuperview()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
