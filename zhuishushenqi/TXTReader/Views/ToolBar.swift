//
//  ToolBar.swift
//  PageViewController
//
//  Created by Nory Chao on 16/10/10.
//  Copyright © 2016年 QS. All rights reserved.
//

import UIKit

protocol ToolBarDelegate{
    func backButtonDidClicked()
    func catagoryClicked()
    func changeSourceClicked()
    func toolBarDidShow()
    func toolBarDidHidden()
    func readBg(type:ReadeeBgType)
    func fontChange(size:Int)
    func brightnessChange(value:CGFloat)
}

class ToolBar: UIView {

    private let kBottomBtnTag = 12345
    private let TopBarHeight:CGFloat = 64
    private let BottomBarHeight:CGFloat = 49
    var toolBarDelegate:ToolBarDelegate?
    var topBar:UIView?
    var bottomBar:UIView?
    var midBar:UIView?
    var isShow:Bool = false
    var showMid:Bool = false
    var whiteBtn:UIButton!
    var yellowBtn:UIButton!
    var greenBtn:UIButton!
    var fontSize:Int = 20
    var titleLabel:UILabel!
    var title:String  = "" {
        didSet{
            titleLabel.text = self.title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        fontSize = getFontSize()
        initSubview()
    }
    
    private func initSubview(){
        topBar = UIView(frame: CGRect(x: 0, y: -TopBarHeight, width: UIScreen.main.bounds.size.width, height: TopBarHeight))
        topBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(topBar!)
        
        bottomBar = UIView(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height,width:UIScreen.main.bounds.size.width,height:49))
        bottomBar?.backgroundColor = UIColor(white: 0.0, alpha: 1.0)
        addSubview(bottomBar!)
        
        midBar = UIView(frame: CGRect(x:0,y:UIScreen.main.bounds.size.height - 180 - 49,width:UIScreen.main.bounds.size.width,height:180))
        midBar?.backgroundColor = UIColor(white: 0.0, alpha: 0.7)

        midBarSubviews()
        
        bottomSubviews()
        
        let backBtn = UIButton(type: .custom)
        backBtn.setImage(UIImage(named: "sm_exit"), for: .normal)
        backBtn.addTarget(self, action: #selector(backAction(btn:)), for: .touchUpInside)
        backBtn.frame = CGRect(x:self.bounds.width - 55, y: 20,width: 49,height: 49)
        topBar?.addSubview(backBtn)
        
        let changeSourceBtn = UIButton(type: .custom)
        changeSourceBtn.setTitle("换源", for: .normal)
        changeSourceBtn.setTitleColor(UIColor.white, for: .normal)
        changeSourceBtn.addTarget(self, action: #selector(changeSourceAction(btn:)), for: .touchUpInside)
        changeSourceBtn.frame = CGRect(x:self.bounds.width - 65, y: 27,width: 50,height: 30)
        changeSourceBtn.frame = CGRect(x:10, y:27,width: 50,height: 30)
        topBar?.addSubview(changeSourceBtn)
        
        titleLabel = UILabel(frame: CGRect(x: self.bounds.width/2 - 100, y: 27, width: 200, height: 30))
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
        let white = button(with: UIImage(named:"background_white"), selectedImage: UIImage(named:"background_white_selected"), title: nil, frame: CGRect(x: fontminus.frame.minX, y: 115, width: 60, height: 60), selector: #selector(whiteAction(btn:)), font: nil)
        whiteBtn = white
        let yellow = button(with: UIImage(named:"background_yellow"), selectedImage: UIImage(named:"background_yellow_selected"), title: nil, frame: CGRect(x: 80, y: 115, width: 60, height: 60), selector: #selector(yellowAction(btn:)), font: nil)
        yellowBtn = yellow
        let green = button(with: UIImage(named:"background_green"), selectedImage: UIImage(named:"background_green_selected"), title: nil, frame: CGRect(x: 150, y: 115, width: 60, height: 60), selector: #selector(greenAction(btn:)), font: nil)
        greenBtn = green
        let senior = button(with: UIImage(named:"reading_more_setting"), selectedImage: nil, title: "高级设置", frame: CGRect(x: 205, y: 130, width: 115, height: 30), selector: #selector(seniorSettingAction(btn:)), font: UIFont.systemFont(ofSize: 15))
        midBar?.addSubview(leftImg)
        midBar?.addSubview(rightImg)
        midBar?.addSubview(progressBar)
        midBar?.addSubview(fontminus)
        midBar?.addSubview(fontPlus)
        midBar?.addSubview(landscape)
        midBar?.addSubview(autoReading)
        midBar?.addSubview(whiteBtn)
        midBar?.addSubview(yellowBtn)
        midBar?.addSubview(greenBtn)
        midBar?.addSubview(senior)
        
        let type = getReaderBg()
        if type == .white {
            whiteBtn.isSelected = true
        }else if type == .yellow {
            yellowBtn.isSelected = true
        }else{
            greenBtn.isSelected = true
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
    
    func showWithAnimations(animation:Bool){
        let keyWindow = UIApplication.shared.keyWindow
        keyWindow?.addSubview(self)
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0, y:0,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0,y: self.bounds.size.height - self.BottomBarHeight,width: self.bounds.size.width,height: self.BottomBarHeight)
        }) { (finished) in
        
        }
        toolBarDelegate?.toolBarDidShow()
    }
    
    func hideWithAnimations(animation:Bool){
        midBar?.removeFromSuperview()
        showMid = false
        UIView.animate(withDuration: 0.35, animations: {
            self.topBar?.frame = CGRect(x:0,y: -self.TopBarHeight,width: self.bounds.size.width,height: self.TopBarHeight)
            self.bottomBar?.frame = CGRect(x:0, y:self.bounds.size.height, width:self.bounds.size.width, height:self.BottomBarHeight)
            }) { (finished) in
                self.removeFromSuperview()
        }
        toolBarDelegate?.toolBarDidHidden()
    }
    
    @objc private func brightnessChange(btn:UISlider){
        //调节屏幕亮度
        self.toolBarDelegate?.brightnessChange(value: CGFloat(btn.value))
    }
    
    @objc private func fontMinusAction(btn:UIButton){
        fontSize -= 1
        self.toolBarDelegate?.fontChange(size: fontSize)
    }
    
    @objc private func fontPlusAction(btn:UIButton){
        fontSize += 1
        self.toolBarDelegate?.fontChange(size: fontSize)
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
    
    @objc private func seniorSettingAction(btn:UIButton){
        
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
    
    
    @objc private func changeSourceAction(btn:UIButton){
        toolBarDelegate?.changeSourceClicked()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

