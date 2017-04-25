//
//  UserfulCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class UserfulCell: UITableViewCell {
    @IBOutlet weak var userful: UILabel!

    @IBOutlet weak var unuserful: UILabel!
    
    var model:BookComment? {
        didSet{
            userful.text = "\(model?.helpful.yes ?? 0)"
            unuserful.text = "\(model?.helpful.no ?? 0)"
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
