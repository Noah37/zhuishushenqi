//
//  ZSSourceCell.swift
//  zhuishushenqi
//
//  Created by caony on 2019/11/11.
//  Copyright © 2019 QS. All rights reserved.
//

import UIKit

protocol ZSSourceCellDelegate:class {
    func cellDidClickCheck(cell:ZSSourceCell)
    func cellDidClickDelete(cell:ZSSourceCell)
}

class ZSSourceCell: UITableViewCell {
    
    weak var delegate:ZSSourceCellDelegate?
    
    lazy var checkButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "source_checkbox_normal"), for: .normal)
        bt.setImage(UIImage(named: "source_checkbox_selected"), for: .selected)
        bt.imageView?.contentMode = .scaleToFill
        bt.addTarget(self, action: #selector(checkAction(btn:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var deleteButton:UIButton = {
        let bt = UIButton(type: .custom)
        bt.setImage(UIImage(named: "source_delete"), for: .normal)
        bt.addTarget(self, action: #selector(deleteAction(btn:)), for: .touchUpInside)
        return bt
    }()
    
    var source:AikanParserModel?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(checkButton)
        contentView.addSubview(deleteButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(source:AikanParserModel) {
        self.source = source
        self.textLabel?.text = source.name
        self.checkButton.isSelected = source.checked
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.checkButton.frame = CGRect(x: 20, y: self.contentView.size.height/2 - 20, width: 40, height: 40)
        self.deleteButton.frame = CGRect(x: self.contentView.width - 20 - 20, y: self.contentView.size.height/2 - 10, width: 20, height: 20)
        self.textLabel?.frame = CGRect(x: 60, y: 0, width: 200, height: self.contentView.bounds.height)
    }

    @objc
    private func checkAction(btn:UIButton) {
        btn.isSelected = !btn.isSelected
        self.source?.checked = btn.isSelected
        self.delegate?.cellDidClickCheck(cell: self)
    }
    
    @objc
    private func deleteAction(btn:UIButton) {
        self.delegate?.cellDidClickDelete(cell: self)
    }
}
