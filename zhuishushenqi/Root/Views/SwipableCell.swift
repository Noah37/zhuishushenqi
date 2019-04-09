//
//  SwipableCell.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 16/9/18.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol SwipableCellDelegate {
    func swipableCell(swipableCell:SwipableCell, didSelectAt index:Int)
}

enum TranslationDirection {
    case left
    case right
}

enum SwipeCellState:String {
    case none = "none"
    case prepare = "prepare"
    case download = "download"
    case finish = "finish"
}

extension SwipeCellState {
    var icon:String {
        switch self {
        case .none:
            return "bs_download"
        case .prepare:
            return "bs_download_cancel"
        case .download:
            return "bs_download_cancel"
        case .finish:
            return "bs_download"
        }
    }
    var cornerIcon:String {
        switch self {
        case .none:
            return ""
        case .prepare:
            return "bs_download_waiting"
        case .download:
            return "bs_downloading"
        case .finish:
            return "bs_download_finished"
        }
    }
}

class ZSSwipeView: UIView {
    
    // container分为三部分，1.左边的view，中间的view，右边的view
    private var container:UIView!
    private var leftView:UIView!
    var centerView:UIView!
    private var rightView:UIView!
    private var touchOverlay:UIView!
    
    private var curOffset:CGFloat = 0
    private var rightOffSet:CGFloat = 0

    private var panGesture:UIPanGestureRecognizer!
    
    // 右侧的项,需要定义好后传入,根据传入的view的frame布局
    var rightItems:[UIView] = [] { didSet { setupRightView() } }
    
    // 是否可以滑动显示,如果为否,需调用show方法自行展示右侧视图
    var isSwipeEnable:Bool = true
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    private func setupSubviews() {
        // 2.使用UIView作为容器，手势滑动时改变frame，即当前视图x左移即可
        container = UIView(frame: CGRect(x:0,y:0,width:self.bounds.width,height:self.bounds.height))
        container.backgroundColor = UIColor ( red: 1.0, green: 1.0, blue: 1.0, alpha: 0.7 )
        container.isUserInteractionEnabled = true
        
        centerView = UIView()
        centerView.frame = self.bounds
        
        touchOverlay = UIView()
        touchOverlay.frame = self.centerView.bounds;
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(tap:)))
        touchOverlay.addGestureRecognizer(tap)
        
        
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(panGestureAction(pan:)))
        panGesture.delegate = self
        container.addGestureRecognizer(panGesture)
        
        rightView = UIView()
        rightView.frame = self.bounds
        
        addSubview(container)
        container.addSubview(rightView)
        container.addSubview(centerView)

    }
    
    private func setupRightView() {
        var itemWidth:CGFloat = 0
        var index = 0
        for itemView in rightItems {
            itemView.frame = CGRect(x: itemWidth, y: 0, width: itemView.bounds.height, height: itemView.bounds.height)
            itemWidth += itemView.bounds.width
            if itemView.superview == nil {
                rightView.addSubview(itemView)
            }
            index += 1
        }
        layoutUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showRightView(animated:Bool) {
        if rightView.bounds.width > 0 {
            rightOffSet = rightView.bounds.width
            curOffset = -rightOffSet
            self.translation(direction: .left, offset: curOffset, animation: true)
        }
    }
    
    private func translation(direction:TranslationDirection,offset:CGFloat,animation:Bool){
        var animationDuration = 0.0001
        if animation {
            animationDuration = 0.35
        }
        if direction == .right && offset <= 0 {
            curOffset = 0
            //关闭右边显示
            UIView.animate(withDuration: animationDuration, animations: {
                self.centerView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height)
                self.rightView.frame = CGRect(x: self.bounds.width, y: 0, width: CGFloat(self.rightItems.count) * self.bounds.height, height: self.bounds.height)
            }, completion: { (finished) in
                self.touchOverlay.removeFromSuperview()
            })
        }else if direction == .left && offset < 0 {
            UIView.animate(withDuration: animationDuration, animations: {
                self.centerView.frame = CGRect(x: offset, y: 0, width: self.bounds.width, height: self.bounds.height)
                self.rightView.frame = CGRect(x: self.bounds.width + offset, y: 0, width: CGFloat(self.rightItems.count) * self.bounds.height, height: self.bounds.height)
            }, completion: { (finished) in
                self.centerView.addSubview(self.touchOverlay)
            })
        }
    }
    
    @objc
    private func tapGestureAction(tap:UITapGestureRecognizer) {
        reset()
        animate(for: container, duration: 1)
    }
    
    func reset() {
        self.curOffset = 0
        translation(direction: .right, offset: self.curOffset, animation: true)
    }
    
    func animate(for content:UIView, duration:Double) {
        let keyframe = CAKeyframeAnimation(keyPath: "transform.translation.x")
        let currentTX = content.transform.tx
        keyframe.duration = duration
        keyframe.repeatCount = 1
        keyframe.values = [currentTX,currentTX + 10,currentTX - 8,currentTX + 8, currentTX - 5, currentTX + 5, currentTX]
        keyframe.keyTimes = [0,0.225,0.425,0.6,0.75,0.885,1]
        keyframe.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        content.layer.add(keyframe, forKey: "contentAnimatuinKey")
    }
    
    @objc
    private func panGestureAction(pan:UIPanGestureRecognizer) {
        if !isSwipeEnable {
            return
        }
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
    
    func prepareForReuse() {
        translation(direction: .right, offset: 0, animation: false)
    }
    
    private func layoutUI() {
        self.container.frame = self.bounds
        self.centerView.frame = CGRect(x: curOffset, y: 0, width: self.bounds.width, height: self.bounds.height)
        self.touchOverlay.frame = CGRect(x: 0, y: 0, width: self.bounds.width - curOffset, height: self.bounds.height)
        if self.rightItems.count > 0 {
            self.rightView.frame = CGRect(x: self.centerView.frame.maxX + curOffset, y: 0, width: CGFloat(self.rightItems.count) * self.bounds.height, height: self.bounds.height)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setupRightView()
    }
}

extension ZSSwipeView:UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer != panGesture {
            return true
        }
        let translation = panGesture.translation(in: container)
        if abs(translation.y) > abs(translation.x)  {
            return false
        }
        return true
    }
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
    
    var swipeView:ZSSwipeView!

    var delegate:SwipableCellDelegate?
    private var imgView: UIImageView?
    private var stateImage: UIImageView!
    var title:UILabel?
    private var detailTitle:UILabel?
    private var updatedLabel:UILabel!
    
    
    private let btnTag = 12324
    
    /// 缓存状态 ，初始为none
    var state:SwipeCellState = .none {
        didSet{
            stateChange()
        }
    }
    
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
        swipeView = ZSSwipeView(frame: self.bounds)
        contentView.addSubview(swipeView)
        
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
        
        
        swipeView.centerView.addSubview(updatedLabel)
        swipeView.centerView.addSubview(self.imgView!)
        swipeView.centerView.addSubview(self.title!)
        swipeView.centerView.addSubview(self.detailTitle!)
        
        
        let titles = ["缓存","养肥","置顶","删除"]
        let images = ["bs_download","bs_feed","bs_stick","bs_delete"]
        
        var selectedImages = ["bs_download_cancel",images[1],images[2],images[3]]
        var selectedTitles = ["取消缓存",titles[1],titles[2],titles[3]]
        
        var buttons:[UIButton] = []
        for index in 0..<titles.count {
            let swipeBtn = QSSwipeButton(type:.custom)
            let image = UIImage(named: images[index])
            swipeBtn.frame = CGRect(x: 0, y: 0, width: self.bounds.height, height: self.bounds.height)
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
        }
        swipeView.rightItems = buttons
    }
    
    @objc
    private func swipeBtnAction(btn:UIButton) {
        let index = btn.tag - btnTag
        self.delegate?.swipableCell(swipableCell: self, didSelectAt: index)
    }
    
    func stateChange(){
//        bs_download_waiting,bs_downloading,bs_download_finished,bs_download_cancel,bs_stick_icon
        stateImage.image = UIImage(named: state.cornerIcon)
        if let btn = self.swipeView.rightItems.first as? UIButton {
            btn.setImage(UIImage(named: state.icon), for: .normal)
        }
    }
    
    func configureCell(model:BookDetail){
        self.swipeView.reset()
        
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
        super.prepareForReuse()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        swipeView.frame = self.bounds
        
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
