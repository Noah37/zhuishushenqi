//
//  TopicDetailCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/3/9.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

class TopicDetailCell: UITableViewCell {
    @IBOutlet weak var lineHeight: NSLayoutConstraint!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var type: UILabel!
    @IBOutlet weak var reading: UILabel!
    @IBOutlet weak var comment: UILabel!

    @IBOutlet weak var typeWidth: NSLayoutConstraint!
    @IBOutlet weak var authorWidth: NSLayoutConstraint!
    
    @IBOutlet weak var commentHeight: NSLayoutConstraint!
    var model:TopicDetailModel?{
        didSet{
            self.name.text = "\(model?.book.title ?? "")"
            self.author.text = "\(model?.book.author ?? "")"
            
            let authorWidthS = widthOfString(self.author.text ?? "", font: UIFont.systemFont(ofSize: 11), height: 21)
            authorWidth.constant = authorWidthS + 5
            
            self.type.text = "\(model?.book.majorCate ?? "")"
            
            let typeWidthS = widthOfString(self.type.text ?? "", font: UIFont.systemFont(ofSize: 11), height: 21)
            typeWidth.constant = typeWidthS + 5

            self.reading.text = "\(model?.book.latelyFollower ?? 0)人在追"
            self.comment.text = "\(model?.comment ?? "")"
            self.commentHeight.constant = model?.commentHeight ?? 0 + 10
            self.lineHeight.constant = 0.5
            
            if self.model?.book.cover == "" {
                return;
            }
            let urlString = "\(IMAGE_BASEURL)\(self.model?.book.cover ?? "qqqqqqqq")"
            self.icon.qs_setBookCoverWithURLString(urlString: urlString)
        }
    }
    
    static func height(models:[TopicDetailModel],indexPath:IndexPath)->CGFloat{
        let baseCellHeight:CGFloat = 108
        let baseCellTextHeight:CGFloat = 25
        let model:TopicDetailModel = models[indexPath.section - 1]
        if model.commentHeight > baseCellTextHeight {
            let height = model.commentHeight - baseCellTextHeight + baseCellHeight
            return height
        }
        return baseCellHeight
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
