//
//  CategoryCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/3/10.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

protocol CategoryCellItemDelegate {
    func didSelected(at:Int,cell:CategoryCell)
}

class CategoryCell: UITableViewCell {
    var itemDelegate:CategoryCellItemDelegate?

    var models:NSArray?{
        didSet{
            var index = 0
            if let tempModels = models {
                for item in tempModels {
                    if let dict:NSDictionary = item as? NSDictionary {
                        let row = index/3
                        let col = index%3
                        let width = self.bounds.width/3
                        let height:CGFloat = 60.00
                        let x = CGFloat(col)*width
                        let y = CGFloat(row)*height
                        let categoryItem:CategoryCellItem = CategoryCellItem(frame: CGRect(x: x, y: y, width: width, height: height))
                        categoryItem.model = dict
                        categoryItem.tag = index + 12345
                        let ges:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapAction(ges:)))
                        ges.numberOfTapsRequired = 1
                        ges.numberOfTouchesRequired = 1
                        categoryItem.isUserInteractionEnabled = true
                        categoryItem.addGestureRecognizer(ges)
                        
                        self.addSubview(categoryItem)
                    }
                    index += 1
                }
                let types = models?.count ?? 0
                let row = (types%3 == 0 ? types/3:types/3 + 1)

                let width = self.bounds.width/3
                let height:CGFloat = 60.00
                for index in 0..<2 {
                    let verticalLine = UILabel()
                    verticalLine.frame = CGRect(x: width*CGFloat(index + 1), y: 0, width: CGFloat(0.5), height: CGFloat(row*60))
                    verticalLine.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
                    self.addSubview(verticalLine)
                }
                for index in 0..<row - 1 {
                    let verticalLine = UILabel()
                    verticalLine.frame = CGRect(x: 0, y: height*CGFloat(index + 1), width: self.bounds.width, height: 0.5)
                    verticalLine.backgroundColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
                    self.addSubview(verticalLine)
                }
            }
            
        }
    }
    var height:CGFloat = 0
    
    @objc func tapAction(ges:UITapGestureRecognizer){
        if ges.state == .ended {
            if  self.itemDelegate != nil {
                self.itemDelegate?.didSelected(at: (ges.view?.tag ?? 12345) - 12345,cell: self)
            }
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

class CategoryCellItem: UIView {
    var titleLabel:UILabel!
    var detailTitleLabel:UILabel!
    var model:NSDictionary?{
        didSet{
            titleLabel.text = "\(model?["name"] ?? "")"
            detailTitleLabel.text = "\(model?["bookCount"] ?? "")本"
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeTitle()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeTitle(){
        titleLabel = UILabel(frame: CGRect(x: 0, y: 10, width: self.bounds.width, height: 21))
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        
        detailTitleLabel = UILabel(frame: CGRect(x: 0, y: titleLabel.frame.maxY, width: self.bounds.width, height: 15))
        detailTitleLabel.textAlignment = .center
        detailTitleLabel.font = UIFont.systemFont(ofSize: 12)
        detailTitleLabel.textColor = UIColor(red: 0.78, green: 0.78, blue: 0.80, alpha: 1.0)
        
        addSubview(titleLabel)
        addSubview(detailTitleLabel)
    }

}
