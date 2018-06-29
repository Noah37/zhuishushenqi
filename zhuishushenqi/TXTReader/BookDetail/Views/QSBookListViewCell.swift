//
//  QSBookListViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/21.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class QSBookListViewCell: UITableViewCell {
    @IBOutlet weak var icon: UIImageView!

    @IBOutlet weak var totalWidth: NSLayoutConstraint!
    @IBOutlet weak var collectLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    
    var book:QSBookList? {
        didSet{
            self.icon.qs_setBookCoverWithURLString(urlString: book?.cover ?? "")
            titleLabel.text = book?.title
            authorLabel.text = book?.author
            contentLabel.text = book?.desc
            totalLabel.text = "共\(book?.bookCount ?? 0)本书"
            collectLabel.text = "\(book?.collectorCount ?? 0)人收藏"
            let widht =  (totalLabel.text ?? "").qs_width(UIFont.systemFont(ofSize: 11), height: 21) + 10
            totalWidth.constant = widht
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
