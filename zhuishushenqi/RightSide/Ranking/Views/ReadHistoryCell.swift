//
//  TopDetailCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/10/4.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit


class ReadHistoryCell: UITableViewCell {
 
    @IBOutlet weak var authorWidth: NSLayoutConstraint!
    @IBOutlet weak var remain: UILabel!
    @IBOutlet weak var reading: UILabel!
    @IBOutlet weak var profile: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var icon: UIImageView!
    
    @IBOutlet weak var readingWidth: NSLayoutConstraint!
    var model:BookDetail?
    
    func configureCell(model:BookDetail){
        self.model = model
        self.remain.text = String(format: "%.2f %%读者留存", Float(self.model?.retentionRatio ?? "0") ?? 0)
        self.reading.text = String(format: "%.0f 人在追", Float(self.model?.latelyFollower ?? "0") ?? 0)
        self.profile.text = "\(self.model?.longIntro ?? "")"
        self.type.text = "\(self.model?.cat ?? "")"
        self.name.text = "\(self.model?.title ?? "")"
        self.author.text = "\(self.model?.author ?? "")"
        let width = (self.author.text ?? "").qs_width(UIFont.systemFont(ofSize: 11), height: 21)
        self.authorWidth.constant = width + 5
        let readWidth = (self.reading.text ?? "").qs_width(UIFont.systemFont(ofSize: 11), height: 21)
        readingWidth.constant = readWidth + 5
        
        let urlString = "\((self.model?.cover ?? "qqqqqqqq"))"
        self.icon.qs_setBookCoverWithURLString(urlString: urlString)
        if type.text == "" {
            type.text = self.model?.majorCate ?? ""
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
