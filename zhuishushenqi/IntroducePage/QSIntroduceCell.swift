//
//  QSIntroduceCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/11.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSIntroduceCell: UITableViewCell {

    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var titleImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        headerImageView.contentMode = .scaleAspectFit
        titleImageView.contentMode = .scaleToFill
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
