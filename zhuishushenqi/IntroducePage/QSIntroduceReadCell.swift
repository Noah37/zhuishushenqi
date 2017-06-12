//
//  QSIntroduceReadCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/12.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSIntroduceReadCell: UITableViewCell {

    var startRead:Completion?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func startReading(_ sender: Any) {
        if let start = startRead {
            start()
        }
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
