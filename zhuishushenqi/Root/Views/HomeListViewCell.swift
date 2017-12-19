//
//  HomeListViewCell.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/6/6.
//  Copyright © 2017年 QS. All rights reserved.
//

import UIKit

protocol HomeListViewCellDelegate {
    func delete(model:BookDetail)
}

class HomeListViewCell: UITableViewCell,UIScrollViewDelegate {
    
    var delegate:HomeListViewCellDelegate?
    var model:BookDetail?{
        didSet{
            if let modelll = model {
                self.configureCell(model: modelll)
            }
        }
    }
    
    var imgView: UIImageView?
    var title:UILabel?
    
    var detailTitle:UILabel?
    var updatedLabel:UILabel!
    
    private var scrollView:UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubview(){
        scrollView = UIScrollView(frame: CGRect(x: 0,y: 0,width: ScreenWidth,height: 64))
        scrollView.contentSize = CGSize(width: (ScreenWidth - 74)*2, height: 64)
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.showsHorizontalScrollIndicator = false
        contentView.addSubview(scrollView)
        //此处解决 UIScrollView屏蔽 UITableViewCell的点击事件，将 scrollView的手势识别交给他的父视图，苹果官方推荐的做法,但是这样回造成UIScrollView上的button无法点击，本次使用第二种方式，传递事件
        //        scrollView.isUserInteractionEnabled = false
        //        contentView.addGestureRecognizer(scrollView.panGestureRecognizer)
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 10, width: 34, height: 44))
        imgView.backgroundColor = UIColor.orange
        imgView.image = UIImage(named: "default_book_cover")
        self.imgView = imgView
        
        let label = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 10,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        self.title = label
        
        let detaillabel = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 30,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        detaillabel.font = UIFont.systemFont(ofSize: 13)
        
        self.detailTitle = detaillabel
        
        updatedLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 40, height: 10))
        updatedLabel.backgroundColor = UIColor.red
        updatedLabel.font = UIFont.systemFont(ofSize: 9)
        updatedLabel.isHidden = true
        updatedLabel.text = "更新"
        updatedLabel.textAlignment = .center
        updatedLabel.textColor = UIColor.white
        
        
        scrollView.addSubview(updatedLabel)
        scrollView.addSubview(self.imgView!)
        scrollView.addSubview(self.title!)
        scrollView.addSubview(self.detailTitle!)
        
        let delete:QSHomeDeleteBtn = QSHomeDeleteBtn(type: .custom)
        delete.frame = CGRect(x: scrollView.contentSize.width - 65, y: 0, width: 64, height: 64)
        delete.setTitle("删除", for: .normal)
        delete.setImage(UIImage(named:"bs_delete"), for: .normal)
        delete.contentHorizontalAlignment = .center
        delete.setTitleColor(UIColor.red, for: .normal)
        delete.addTarget(self, action: #selector(deleteAction(btn:)), for: .touchUpInside)
//        delete.layoutImageView()
        scrollView.addSubview(delete)
    }
    
    @objc func deleteAction(btn:UIButton){
        delegate?.delete(model: self.model!)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        
    }
    
    func configureCell(model:BookDetail){
        title!.text = model.title
        
        let created = model.updateInfo?.updated ?? "2014-02-23T16:48:18.179Z"
        self.detailTitle?.qs_setCreateTime(createTime: created, append: "更新：\(model.updateInfo?.lastChapter ?? "")")
        let urlString = "\(self.model?.cover ?? "")"
        self.imgView?.qs_setBookCoverWithURLString(urlString: urlString)
        updatedLabel.isHidden = (model.isUpdated)
        let width = (title?.text ?? "").qs_width(UIFont.systemFont(ofSize: 13), height: 20)
        let x = (title?.frame.minX ?? 0) + width + 5
        updatedLabel.frame = CGRect(x:  x, y: 14.5, width: 22, height: 11)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        scrollView.contentOffset = CGPoint(x: 0, y: 0)
    }
}

//extension UIScrollView{
//    //2.解决UIScrollView屏蔽UITableViewCell的点击事件
//    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let next = touches.first?.view?.next?.next
//        if next?.isKind(of: UITableViewCell.self) == true {
//            next?.touchesBegan(touches, with: event)
//        }
//    }
//    
//    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let next = touches.first?.view?.next?.next
//        if next?.isKind(of: UITableViewCell.self) == true {
//            next?.touchesEnded(touches, with: event)
//        }
//    }
//    
//    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
//        let next = touches.first?.view?.next?.next
//        if next?.isKind(of: UITableViewCell.self) == true {
//            next?.touchesCancelled(touches, with: event)
//        }
//    }
//}

//protocol DeleteButton {
//    func layoutImageView()
//}
//
//extension DeleteButton where Self:UIButton{
//    func layoutImageView() {
//        self.imageView?.frame = CGRect(x: 10, y: 0, width: 30, height: 30)
//        self.imageView?.contentMode = .scaleToFill
//        self.titleLabel?.frame = CGRect(x: 0, y: 30, width: 50, height: 20)
//    }
//}

