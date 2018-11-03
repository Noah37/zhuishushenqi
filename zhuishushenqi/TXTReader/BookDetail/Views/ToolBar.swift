//
//  ToolBar.swift
//  PageViewController
//
//  Created by Nory Cao on 16/10/10.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

typealias ZSBgViewHandler = ()->Void

enum ToolBarFontChangeAction {
    case plus
    case minimus
}

protocol ToolBarDelegate{
    func backButtonDidClicked()
    func catagoryClicked()
    func changeSourceClicked()
    func toolBarDidShow()
    func toolBarDidHidden()
    func readBg(type:Reader)
    func fontChange(action:ToolBarFontChangeAction)
    func brightnessChange(value:CGFloat)
    func cacheAll()
    func toolbar(toolbar:ToolBar, clickMoreSetting:UIView)
    func listen()
}

class ToolBar: UIView {

    private let kBottomBtnTag = 12345
    private let TopBarHeight:CGFloat = kNavgationBarHeight
    private let BottomBarHeight:CGFloat = 49 + CGFloat(kTabbarBlankHeight)
    var toolBarDelegate:ToolBarDelegate?
    var topBar:UIView?
    var bottomBar:UIView?
    var midBar:UIView?
    var isShow:Bool = false
    var showMid:Bool = false
    var whiteBtn:UIButton!
    var yellowBtn:UIButton!
    var greenBtn:UIButton!
    var mode_bgView:UIScrollView!
    var fontSize:Int = QSReaderSetting.shared.fontSize
    var titleLabel:UILabel!
    var title:String  = "" {
        didSet{
            titleLabel.text = self.title
        }
    }
    var bgItemViews:[ZSModeBgItemView] = []
    var progressView:ProgressView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        fontSize = QSReaderSetting.shared.fontSize
        initSubview()
    }
    
    private func initSubview(){
        topBar = UIView(frame: CGRect(x: 0, y: -TopBarHeight, width: UIScreen.main.bounds.size.width, height: TopBarHeight))
        topBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(topBar!)
        
        bottomBar = UIView(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:BottomBarHeight))
        bottomBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(bottomBar!)
        
        midBar = UIView(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height - 180 - BottomBarHeight,width:UIScreen.main.bounds.size.width,height:180))
        midBar?.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        midBarSubviews()
        
        bottomSubviews()
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "sm_exit"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(btn:)), for: .touchUpInside)
        backBtn.frame = CGRect(x:self.bounds.width - 55, y: STATEBARHEIGHT,width: 49,height: 49)
        topBar?.addSubview(backBtn)
        
        let changeSourceBtn = UIButton(type: .custom)
        changeSourceBtn.setTitle("换源", for: .normal)
        changeSourceBtn.setTitleColor(UIColor.white, for: .normal)
        changeSourceBtn.addTarget(self, action: #selector(changeSourceAction(btn:)), for: .touchUpInside)
        changeSourceBtn.frame = CGRect(x:self.bounds.width - 65, y: 27,width: 50,height: 30)
        changeSourceBtn.frame = CGRect(x:10, y:STATEBARHEIGHT + 7,width: 50,height: 30)
        topBar?.addSubview(changeSourceBtn)
        
        let listenBtn = UIButton(type: .custom)
        listenBtn.setImage(UIImage(named: "readAloud"), for: .normal)
        listenBtn.addTarget(self, action: #selector(listenAction(btn:)), for: .touchUpInside)
        listenBtn.frame = CGRect(x:self.bounds.width - 104, y: STATEBARHEIGHT,width: 49,height: 49)
        topBar?.addSubview(listenBtn)
        
        
        titleLabel = UILabel(frame: CGRect(x: self.bounds.width/2 - 100, y: STATEBARHEIGHT+7, width: 200, height: 30))
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        topBar?.addSubview(titleLabel)
        
        let tap = UITapGestureRecognizer(target: self, action:#selector(hideWithAnimations(animation:)) )
        addGestureRecognizer(tap)
    }
    
    func midBarSubviews(){
        let progressBar = UISlider(frame: CGRect(x: 50, y: 25, width: self.bounds.width - 100, height: 15))
        progressBar.minimumTrackTintColor = UIColor.orange
        progressBar.value = Float(UIScreen.main.brightness)
        progressBar.addTarget(self, action: #selector(brightnessChange(btn:)), for: .valueChanged)
        
        let leftImg = UIImageView(frame: CGRect(x: 25, y: 25, width: 15, height: 15))
        leftImg.image = UIImage(named: "brightess_white_low")
        let rightImg = UIImageView(frame: CGRect(x: self.bounds.width - 40, y: 23, width: 25, height: 25))
        rightImg.image = UIImage(named: "brightess_white_high")
        
        let fontminus = button(with: UIImage(named:"font_decrease"), selectedImage: nil, title: nil, frame: CGRect(x: 13, y: 55, width: 60, height: 60), selector: #selector(fontMinusAction(btn:)), font: nil)
        let fontPlus = button(with: UIImage(named:"font_increase"), selectedImage: nil, title: nil, frame: CGRect(x: fontminus.frame.maxX + 13, y: fontminus.frame.minY, width: 60, height: 60), selector: #selector(fontPlusAction(btn:)), font: nil)
        let landscape = button(with: UIImage(named:"landscape"), selectedImage: nil, title: nil, frame: CGRect(x: fontPlus.frame.maxX, y: fontminus.frame.minY + 5, width: 60, height: 50), selector: #selector(landscape(btn:)), font: nil)
        let autoReading = button(with: UIImage(named:"autoreading_start"), selectedImage: nil, title: "自动阅读", frame: CGRect(x: landscape.frame.maxX, y: landscape.frame.minY + 10, width: 115, height: 30), selector: #selector(autoReading(btn:)), font: UIFont.systemFont(ofSize: 15))
        
        mode_bgView = UIScrollView(frame: CGRect(x: 0, y: 115, width: self.bounds.width - 140, height: 60))
        mode_bgView.isUserInteractionEnabled = true
//        mode_bgView.backgroundColor = UIColor.orange
        mode_bgView.showsHorizontalScrollIndicator = true
        midBar?.addSubview(mode_bgView)

        let itemImages = ["white_mode_bg","yellow_mode_bg","green_mode_bg","blackGreen_mode_bg","pink_mode_bg","sheepskin_mode_bg","violet_mode_bg","water_mode_bg","weekGreen_mode_bg","weekPink_mode_bg","coffee_mode_bg"]
        var index = 0
        for image in itemImages {
            let bgView = ZSModeBgItemView(frame: CGRect(x: 25*(index + 1) + 60 * index, y: 0, width: 60, height: 60))
            bgView.setImage(image: UIImage(named: image))
            bgView.index = index
            bgView.selectHandler = {
                self.itemAction(index: bgView.index)
            }
            mode_bgView.addSubview(bgView)
            bgItemViews.append(bgView)
            index += 1
        }
        mode_bgView.contentSize = CGSize(width: itemImages.count * (60 + 25), height: 60)
        
        let senior = button(with: UIImage(named:"reading_more_setting"), selectedImage: nil, title: "高级设置", frame: CGRect(x: self.bounds.width - 140, y: 130, width: 115, height: 30), selector: #selector(seniorSettingAction(btn:)), font: UIFont.systemFont(ofSize: 15))
        progressView = ProgressView(frame: CGRect(x: 0, y: self.bounds.height - 49 - 20, width: self.bounds.width, height: 20))
        progressView.backgroundColor = UIColor.black
        progressView.isHidden  = true
        progressView.alpha = 0.7
        
        addSubview(progressView)
        midBar?.addSubview(leftImg)
        midBar?.addSubview(rightImg)
        midBar?.addSubview(progressBar)
        midBar?.addSubview(fontminus)
        midBar?.addSubview(fontPlus)
        midBar?.addSubview(landscape)
        midBar?.addSubview(autoReading)
        midBar?.addSubview(senior)
        
        let type = AppStyle.shared.reader
        if type.rawValue >= 0 && type.rawValue < bgItemViews.count {
            var index = 0
            for bgView in bgItemViews {
                if type.rawValue == index {
                    bgView.select(select: true)
                } else {
                    bgView.select(select: false)
                }
                index += 1
            }
        }
    }
    
    func bottomSubviews(){
        let width = UIScreen.main.bounds.width/5
        let btnWidth:CGFloat = 30.0
        let btnHeight:CGFloat = 34.0
        let images = ["night_mode","feedback","directory","preview_btn","reading_setting"]
        let titles = ["夜间","反馈","目录","缓存","设置"]
        for item in 0..<5 {
            let x = (width - btnWidth)/2*CGFloat(item*2 + 1) + btnWidth*CGFloat(item)
            let y = 49/2 - btnHeight/2
            let btn = CategoryButton(type: .custom)
            btn.setImage(UIImage(named: images[item]), for: .normal)
            btn.setTitle(titles[item], for: .normal)
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 9)
            btn.frame = CGRect(x:x,y: y,width: btnWidth,height: btnHeight)
            btn.addTarget(self, action: #selector(bottomBtnAction(btn:)), for: .touchUpInside)
            btn.tag = kBottomBtnTag + item
            bottomBar?.addSubview(btn)
        }
    }
    
    func button(with image:UIImage?,selectedImage:UIImage?,title:String?,frame:CGRect,selector:Selector,font:UIFont?)->UIButton{
        let button = UIButton(frame: frame)
        button.setImage(selectedImage, for: .selected)
        button.setImage(image, for: .normal)
        button.setTitle(title, for: .normal)
        button.addTarget(self, action: selector, for: .touchUpInside)
        button.titleLabel?.font = font
        return button
    }
    
    func showWithAnimations(animation:Bool,inView:UIView){
        self.isShow = true
        inView.addSubview(self)
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0, y:0,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0,y: self.bounds.size.height - self.BottomBarHeight,width: self.bounds.size.width,height: self.BottomBarHeight)
            self.progressView.frame = CGRect(x: 0, y: self.bounds.height - 49 - 20, width: self.bounds.width, height: 20)
        }) { (finished) in
        }
        toolBarDelegate?.toolBarDidShow()
    }
    
    @objc func hideWithAnimations(animation:Bool){
        midBar?.removeFromSuperview()
        showMid = false
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0,y: -self.TopBarHeight,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0, y:self.bounds.size.height + 20, width:self.bounds.size.width, height:self.BottomBarHeight)
            self.progressView.frame = CGRect(x: 0, y: self.bounds.height, width: self.bounds.width, height: 20)

            }) { (finished) in
                self.isShow = false
                self.removeFromSuperview()
        }
        toolBarDelegate?.toolBarDidHidden()
    }
    
    @objc private func brightnessChange(btn:UISlider){
        //调节屏幕亮度
        self.toolBarDelegate?.brightnessChange(value: CGFloat(btn.value))
    }
    
    @objc private func fontMinusAction(btn:UIButton){
        self.toolBarDelegate?.fontChange(action: .minimus)
    }
    
    @objc private func fontPlusAction(btn:UIButton){
        self.toolBarDelegate?.fontChange(action: .plus)
    }
    
    @objc private func landscape(btn:UIButton){
        
    }
    
    @objc private func autoReading(btn:UIButton){
        
    }
    
    @objc private func whiteAction(btn:UIButton){
        btn.isSelected = true
        yellowBtn.isSelected = false
        greenBtn.isSelected = false
        self.toolBarDelegate?.readBg(type: .white)
    }
    
    @objc private func yellowAction(btn:UIButton){
        btn.isSelected = true
        whiteBtn.isSelected = false
        greenBtn.isSelected = false
        self.toolBarDelegate?.readBg(type: .yellow)
    }
    
    @objc private func greenAction(btn:UIButton){
        btn.isSelected = true
        whiteBtn.isSelected = false
        yellowBtn.isSelected = false
        self.toolBarDelegate?.readBg(type: .green)
    }
    
    @objc private func itemAction(index:Int) {
        var viewIndex = 0
        for bgView in bgItemViews {
            if viewIndex != index {
                bgView.select(select: false)
            }
            viewIndex += 1
        }
        self.toolBarDelegate?.readBg(type: Reader(rawValue: index) ?? .white)
    }
    
    @objc private func seniorSettingAction(btn:UIButton){
        self.toolBarDelegate?.toolbar(toolbar: self, clickMoreSetting: btn)
    }
    
    @objc private func bottomBtnAction(btn:UIButton){
        let tag = btn.tag - kBottomBtnTag
        switch tag {
        case 0:
            darkNight(btn: btn)
            break
        case 1:
            feedback(btn: btn)
            break
        case 2:
            catalogAction(btn: btn)
            break
        case 3:
            cache(btn: btn)
            break
        case 4:
            setting(btn: btn)
            break
        default:
            darkNight(btn: btn)
        }
    }
    
    @objc private func darkNight(btn:UIButton){
        
    }
    
    @objc private func feedback(btn:UIButton){
        
    }
    
    @objc private func catalogAction(btn:UIButton){
        toolBarDelegate?.catagoryClicked()
    }
    
    @objc private func cache(btn:UIButton){
        toolBarDelegate?.cacheAll()
    }
    
    @objc private func setting(btn:UIButton){
        showMid = !showMid
        if showMid {
            self.addSubview(midBar!)
        }else{
            midBar?.removeFromSuperview()
        }
    }
    
    @objc private func  backAction(btn:UIButton){
        toolBarDelegate?.backButtonDidClicked()
    }
    
    @objc private func  listenAction(btn:UIButton){
        toolBarDelegate?.listen()
    }
    
    
    @objc private func changeSourceAction(btn:UIButton){
        toolBarDelegate?.changeSourceClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

class ZSModeBgItemView: UIView {
    
    
    var backgroundImage:UIImageView!
    private var selectedImage:UIImageView!
    
    var selectHandler:ZSBgViewHandler?
    
    var index:Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        isUserInteractionEnabled = true
        backgroundImage = UIImageView(frame: self.bounds)
        backgroundImage.isUserInteractionEnabled = true
        backgroundImage.layer.cornerRadius = self.bounds.width/2
        backgroundImage.layer.masksToBounds = true
        selectedImage = UIImageView(frame: CGRect(x: self.bounds.width/2 - 18, y: self.bounds.width/2 - 18, width: 36, height: 36))
        selectedImage.isUserInteractionEnabled = true
        selectedImage.image = UIImage(named: "cell_selected_tip")
        selectedImage.isHidden = true
        
        addSubview(backgroundImage)
        addSubview(selectedImage)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(selectAction))
        backgroundImage.addGestureRecognizer(tap)
    }
    
    @objc
    private func selectAction() {
        selectedImage.isHidden = false
        selectHandler?()
    }
    
    func select(select:Bool) {
        selectedImage.isHidden = !select
    }
    
    func setImage(image:UIImage?) {
        backgroundImage.image = image
    }
}

