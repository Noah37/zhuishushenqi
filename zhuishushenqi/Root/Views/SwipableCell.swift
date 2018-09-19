//
//  SwipableCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/18.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol SwipableCellDelegate {
    func swipeCell(clickAt:Int,model:BookDetail,cell:SwipableCell,selected:Bool)
}

enum TranslationDirection {
    case left
    case right
}

enum SwipeCellState {
    case none
    case prepare
    case download
    case finish
}

class SwipableCell: UITableViewCell {
    
    class var reuseIdentifier: String {
        get {
            return "SwipableCell"
        }
    }
    
    class var nib:UINib {
        get {
            return UINib(nibName: "SwipableCell", bundle: Bundle.main)
        }
    }

    var delegate:SwipableCellDelegate?
    var model:BookDetail?
    var imgView: UIImageView?
    var stateImage: UIImageView!
    var title:UILabel?
    var detailTitle:UILabel?
    var updatedLabel:UILabel!
    
    // container分为三部分，1.左边的view，中间的view，右边的view
    var container:UIView!
    var leftView:UIView!
    var centerView:UIView!
    var rightView:QSSwipeButtonsView!
    var touchOverlay:UIView!
    
    var curOffset:CGFloat = 0
    var rightOffSet:CGFloat = 0
    
    var titles:[String] = []
    var images:[String] = []
    var panGesture:UIPanGestureRecognizer!
    
    /// 缓存状态 ，初始为none
    var state:SwipeCellState = .none {
        didSet{
            stateChange()
        }
    }

    private var scrollView:UIScrollView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initSubview()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func initSubview(){
        titles = ["缓存","养肥","置顶","删除"]
        images = ["bs_download","bs_feed","bs_stick","bs_delete"]
        
        // 2.使用UIView作为容器，手势滑动时改变frame，即当前视图x左移即可
        container = UIView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        container.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        container.isUserInteractionEnabled = true

        centerView = UIView()
        centerView.frame = self.bounds
        
        rightView = QSSwipeButtonsView(frame: CGRect(x: self.bounds.width, y: 0, width: CGFloat(titles.count)*self.bounds.height, height: self.bounds.height), titles: titles, images: images,callback:{ (index,selected) in
            if let book = self.model {
                self.delegate?.swipeCell(clickAt: index,model:book,cell:self,selected:selected)
            }
        })
        
        let imgView = UIImageView(frame: CGRect(x: 15, y: 10, width: 34, height: 44))
        imgView.image = UIImage(named: "default_book_cover")
        self.imgView = imgView
        
        stateImage = UIImageView(frame: CGRect(x: 0, y: 0, width: 34, height: 44))
        self.imgView?.addSubview(stateImage)
        
        let label = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 10,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        label.font = UIFont.systemFont(ofSize: 13)
        self.title = label
        
        let detaillabel = UILabel(frame: CGRect(x: imgView.frame.maxX + 10,y: 30,width: ScreenWidth - imgView.frame.maxX - 20,height: 20))
        detaillabel.font = UIFont.systemFont(ofSize: 11)
        detaillabel.textColor = UIColor.gray

        self.detailTitle = detaillabel
        
        updatedLabel = UILabel(frame: CGRect(x: 0, y: 15, width: 40, height: 10))
        updatedLabel.backgroundColor = UIColor.red
        updatedLabel.font = UIFont.systemFont(ofSize: 9)
        updatedLabel.isHidden = true
        updatedLabel.text = "更新"
        updatedLabel.textAlignment = .center
        updatedLabel.textColor = UIColor.white
        
        
        centerView.addSubview(updatedLabel)
        centerView.addSubview(self.imgView!)
        centerView.addSubview(self.title!)
        centerView.addSubview(self.detailTitle!)
        
        touchOverlay = UIView()
        touchOverlay.frame = self.centerView.bounds;
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
        touchOverlay.addGestureRecognizer(tap)
        
        self.contentView.addSubview(container)
        container.addSubview(rightView)
        container.addSubview(centerView)

        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
        panGesture.delegate = self
        container.addGestureRecognizer(panGesture)
    }
    
    func stateChange(){
//        bs_download_waiting,bs_downloading,bs_download_finished,bs_download_cancel,bs_stick_icon
        var imageName = ""
        var cacheBtnSelected = false
        switch self.state {
        case .prepare:
            cacheBtnSelected = true
            imageName = "bs_download_waiting"
            break
        case .download:
            cacheBtnSelected = true
            imageName = "bs_downloading"
            break
        case .finish:
            imageName = "bs_download_finished"
            break
        default:
            imageName = ""
            break
        }
        QSLog(cacheBtnSelected)
        stateImage.image = UIImage(named: imageName)
    }
    
    func translation(direction:TranslationDirection,offset:CGFloat,animation:Bool){
        var animationDuration = 0.0001
        if animation {
            animationDuration = 0.35
        }
        if direction == .right && offset <= 0 {
            curOffset = 0
            //关闭右边显示
            UIView.animate(withDuration: animationDuration, animations: {
                self.centerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
                self.rightView.frame = CGRect(x: self.bounds.width, y: 0, width: CGFloat(self.titles.count) * self.bounds.height, height: self.bounds.height)
            }, completion: { (finished) in
                self.touchOverlay.removeFromSuperview()
            })
        }else if direction == .left && offset < 0 {
            UIView.animate(withDuration: animationDuration, animations: {
                self.centerView.frame = CGRect(x: offset, y: 0, width: self.bounds.width, height: self.bounds.height)
                self.rightView.frame = CGRect(x: self.bounds.width + offset, y: 0, width: CGFloat(self.titles.count) * self.bounds.height, height: self.bounds.height)
            }, completion: { (finished) in
                self.centerView.addSubview(self.touchOverlay)
            })
        }
    }
    
    @objc func tapGestureAction(tap:UITapGestureRecognizer){
        self.curOffset = 0
        translation(direction: .right, offset: self.curOffset, animation: true)
    }
    
    @objc func panGestureAction(pan:UIPanGestureRecognizer){
        let translation = pan.translation(in: container)
        let velocity = pan.velocity(in: container)
        var offset:CGFloat = 0
        if pan.state == .began {
            if curOffset == 0 {
                curOffset = translation.x
            }
            rightOffSet = rightView.bounds.width
            offset = curOffset
        }else if pan.state == .changed {
            //当前向左偏移，显示右边视图
            if offset <= 0 {
                offset = curOffset + translation.x
            }
            self.translation(direction: .left, offset: offset, animation: false)
        }else if pan.state == .ended {
            curOffset = offset
            if curOffset <= 0 {
                if velocity.x > 0 {
                    curOffset = 0
                    self.translation(direction: .right, offset: curOffset, animation: true)
                }else{
                    curOffset = -rightOffSet
                    self.translation(direction: .left, offset: curOffset, animation: true)
                }
            }
        }
    }
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != panGesture {
            return true
        }
        let translation = panGesture.translation(in: container)
        if fabs(translation.y) > fabs(translation.x)  {
            return false
        }
        return true
    }
    
    func configureCell(model:BookDetail){
        self.model = model
        title!.text = model.title
        
        let created = model.updateInfo?.updated ?? "2014-02-23T16:48:18.179Z"
        self.detailTitle?.qs_setCreateTime(createTime: created, append: "更新：\(model.updateInfo?.lastChapter ?? "")")
        let urlString = "\(model.cover)"
        self.imgView?.qs_setBookCoverWithURLString(urlString: urlString)
        updatedLabel.isHidden = !(model.isUpdated)
        let width = (title?.text ?? "").qs_width(UIFont.systemFont(ofSize: 13), height: 20)
        let x = (title?.frame.minX ?? 0) + width + 5
        updatedLabel.frame = CGRect(x:  x, y: 14.5, width: 22, height: 11)
    }
    
    override func prepareForReuse() {
        translation(direction: .right, offset: 0, animation: false)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
            self.container.frame = self.bounds
            self.centerView.frame = CGRect(x: curOffset, y: 0, width: self.bounds.width, height: self.bounds.height)
            self.rightView.frame = CGRect(x: self.bounds.width + curOffset, y: 0, width: CGFloat(self.titles.count) * self.bounds.height, height: self.bounds.height)
        self.touchOverlay.frame = CGRect(x: 0, y: 0, width: self.bounds.width - curOffset, height: self.bounds.height)
        
    }
}

typealias SwipeCallback = (_ index:Int,_ selected:Bool) ->Void

class QSSwipeButtonsView: UIView {
    let btnTag = 12324
    var titles:[String] = []
    var images:[String] = []
    var clickCallback:SwipeCallback?
    var buttons:[QSSwipeButton] = []
    
    init(frame: CGRect, titles:[String],images:[String],callback:@escaping SwipeCallback) {
        super.init(frame: frame)
        self.titles = titles
        self.images = images
        self.clickCallback = callback
        setupSubviews(titles: titles, images: images)
    }
    
    func setupSubviews(titles:[String],images:[String]){
        var selectedImages = ["bs_download_cancel",images[1],images[2],images[3]]
        var selectedTitles = ["取消缓存",titles[1],titles[2],titles[3]]
        for index in 0..<titles.count {
            let swipeBtn = QSSwipeButton(type:.custom)
            let image = UIImage(named: images[index])
            swipeBtn.setImage(image, for: .normal)
            swipeBtn.setTitle(titles[index], for: .normal)
            swipeBtn.tag = index + btnTag
            swipeBtn.setTitleColor(UIColor.gray, for: .normal)
            swipeBtn.setTitleColor(UIColor.gray, for: .highlighted)
            swipeBtn.autoresizingMask = [.flexibleHeight]
            swipeBtn.addTarget(self, action: #selector(swipeBtnAction(btn:)), for: .touchUpInside)
            swipeBtn.setImage(UIImage(named:selectedImages[index]), for: .selected)
            swipeBtn.setTitle(selectedTitles[index], for: .selected)
            if index == titles.count - 1 {
                swipeBtn.setTitleColor(UIColor.red, for: .normal)
            }
            buttons.append(swipeBtn)
            self.addSubview(swipeBtn)
        }
    }
    
    @objc func swipeBtnAction(btn:QSSwipeButton){
        let tag = btn.tag
        btn.isSelected = !btn.isSelected
        if let callback = self.clickCallback {
            callback(tag - btnTag,btn.isSelected)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        for index in 0..<titles.count {
            let btn = self.viewWithTag(index + btnTag)
            let height = self.bounds.height
            btn?.frame = CGRect(x: CGFloat(index)*height, y: 0, width: height, height: height)
        }
    }
    
}

class QSSwipeButton: UIButton {
    var separator:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        separator = UILabel(frame: CGRect(x: 0, y: frame.height/4, width: 0.5, height: frame.height/2))
        separator.backgroundColor  = UIColor.gray
        separator.autoresizingMask = [.flexibleHeight , .flexibleTopMargin,.flexibleBottomMargin]
        addSubview(separator)
        titleLabel?.font = UIFont.systemFont(ofSize: 11)
        titleLabel?.textAlignment = .center
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView?.frame = self.bounds
        titleLabel?.frame = CGRect(x: 0, y: 34, width: self.bounds.width, height: 12)
    }
}
