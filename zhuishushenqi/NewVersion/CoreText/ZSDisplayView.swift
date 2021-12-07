//
//  ZSDisplayView.swift
//  CoreTextDemo
//
//  Created by caony on 2019/7/12.
//  Copyright © 2019 cj. All rights reserved.
//

import UIKit
import Kingfisher

typealias ZSDisplayHandler = ()->Void

class ZSDisplayView: UIView {
    
    // MARK: - Properties
    var ctFrame: CTFrame?
    
    var coreHeight: CGFloat = 0
    
    fileprivate var images: [(image: UIImage, frame: CGRect)] = []
    
    fileprivate var imageModels:[ZSImageData] = []

    // MARK: - Properties
    fileprivate var imageIndex: Int!
    
    fileprivate var longPress:UILongPressGestureRecognizer!
    
    fileprivate var originRange = NSRange(location: 0, length: 0)
    
    fileprivate var selectedRange = NSRange(location: 0, length: 0)
    
    fileprivate var attributeString:NSMutableAttributedString = NSMutableAttributedString(string: "")
    
    fileprivate var rects:[CGRect] = []
    
    fileprivate var leftCursor:ZSTouchAnchorView!
    fileprivate var rightCursor:ZSTouchAnchorView!
    
    // 移动光标
    var isTouchCursor = false
    
    // 是否编辑状态
    var isEditing:Bool {
        return rects.count > 0
    }
    // 编辑回调
    var startEditingHandler:ZSDisplayHandler?
    var endEditingHandler:ZSDisplayHandler?
    private var touchRightCursor = false
    private var touchOriginRange = NSRange(location: 0, length: 0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.clear
        isUserInteractionEnabled = true
        if longPress == nil {
            longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(gesture:)))
            addGestureRecognizer(longPress)
        }
        _ = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
//        addGestureRecognizer(tap)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func clearEditing() {
        rects = []
        hideCursor()
        setNeedsDisplay()
    }
    
    @objc
    private func tapAction(tap:UITapGestureRecognizer) {
        originRange = NSRange(location: 0, length: 0)
        selectedRange = NSRange(location: 0, length: 0)
        rects.removeAll()
        hideCursor()
        setNeedsDisplay()
    }
    
    @objc
    private func longPressAction(gesture:UILongPressGestureRecognizer) {
        var originPoint = CGPoint.zero
        switch gesture.state {
        case .began:
            originPoint = gesture.location(in: self)
            originRange = touchLocation(point: originPoint, str: self.attributeString.string)
            selectedRange = originRange
            rects = rangeRects(range: selectedRange, ctframe: ctFrame)
            showCursor()
            setNeedsDisplay()
            break
        case .changed:
            let finalRange = touchLocation(point: gesture.location(in: self), str: attributeString.string)
            if finalRange.location == 0 || finalRange.location == NSNotFound {
                return
            }
            var range = NSRange(location: 0, length: 0)
            range.location = min(finalRange.location, originRange.location)
            if finalRange.location > originRange.location {
                range.length = finalRange.location - originRange.location + finalRange.length
            } else {
                range.length = originRange.location - finalRange.location + originRange.length
            }
            selectedRange = range
            rects = rangeRects(range: selectedRange, ctframe: ctFrame)
            showCursor()
            startEditingHandler?()
            setNeedsDisplay()
            break
        case .ended:
            break
        case .cancelled:
            endEditingHandler?()
            break
        default:
            break
        }
    }
    
    func showCursor() {
        guard rects.count > 0 else {
            return
        }
        showMenuController()
        let leftRect = rects.first!
        let rightRect = rects.last!
        if leftCursor == nil {
            let rect = CGRect(x: leftRect.minX - 5, y: leftRect.origin.y - 10, width: 10, height: leftRect.height + 6)
            leftCursor = ZSTouchAnchorView(frame: rect)
            addSubview(leftCursor)
        } else {
            let rect = CGRect(x: leftRect.minX - 5, y: leftRect.origin.y - 10, width: 10, height: leftRect.height + 6)
            leftCursor.frame = rect
        }
        if rightCursor == nil {
            let rect = CGRect(x: rightRect.maxX - 2, y: rightRect.origin.y - 10, width: 10, height: rightRect.height + 6)
            rightCursor = ZSTouchAnchorView(frame: rect)
            addSubview(rightCursor)
        } else {
            rightCursor.frame = CGRect(x: rightRect.maxX - 4, y: rightRect.origin.y - 10, width: 10, height: rightRect.height + 6)
        }
    }
    
    func hideCursor() {
        hideMenuController()
        if leftCursor != nil {
            leftCursor.removeFromSuperview()
            leftCursor = nil
        }
        if rightCursor != nil {
            rightCursor.removeFromSuperview()
            rightCursor = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard leftCursor != nil && rightCursor != nil else { return }
        
        if rightCursor.frame.insetBy(dx: -30, dy: -30).contains(point) {
            touchRightCursor = true
            isTouchCursor = true
        } else if leftCursor.frame.insetBy(dx: -30, dy: -30).contains(point) {
            touchRightCursor = false
            isTouchCursor = true
        }
        
        touchOriginRange = selectedRange
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        guard leftCursor != nil && rightCursor != nil else { return }
        
        if isTouchCursor {
            let finalRange = touchLocation(point: point, str: attributeString.string)
            
            if (finalRange.location == 0 && finalRange.length == 0) || finalRange.location == NSNotFound {
                return
            }
            var range = NSRange(location: 0, length: 0)
            
            if touchRightCursor { // 移动右边光标
                if finalRange.location >= touchOriginRange.location {
                    range.location = touchOriginRange.location
                    range.length = finalRange.location - touchOriginRange.location + 1
                } else {
                    range.location = finalRange.location
                    range.length = touchOriginRange.location - range.location
                }
            } else {  // 移动左边光标
                
                if finalRange.location <= touchOriginRange.location {
                    range.location = finalRange.location
                    range.length = touchOriginRange.location - finalRange.location + touchOriginRange.length
                    
                } else if finalRange.location > touchOriginRange.location {
                    
                    if finalRange.location <= touchOriginRange.location + touchOriginRange.length - 1 {
                        range.location = finalRange.location
                        range.length = touchOriginRange.location + touchOriginRange.length - finalRange.location
                    } else {
                        range.location = touchOriginRange.location + touchOriginRange.length
                        range.length = finalRange.location - range.location
                    }
                }
            }
            
            selectedRange = range
            rects = rangeRects(range: selectedRange, ctframe: ctFrame)
            
            // 显示光标
            showCursor()
            setNeedsDisplay()
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        isTouchCursor = false
        touchOriginRange = selectedRange
    }
    
    func rangeRects(range:NSRange, ctframe:CTFrame?) ->[CGRect] {
        var rects:[CGRect] = []
        guard let ctframe = ctframe  else {
            return rects
        }
        guard range.location != NSNotFound else {
            return rects
        }
        let lines = CTFrameGetLines(ctframe) as Array
        var origins = [CGPoint](repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRange(location: 0, length: 0), &origins)
        for index in 0..<lines.count {
            let line = lines[index] as! CTLine
            let origin = origins[index]
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            CTLineGetTypographicBounds(line, &ascent, &descent, nil)
//            let rect = CGRect(x: origin.x, y: coreHeight - origin.y - ascent, width: self.bounds.width, height: ascent + descent)
//            rects.append(rect)
            let lineCFRange = CTLineGetStringRange(line)
            if lineCFRange.location != NSNotFound {
                let lineRange = NSRange(location: lineCFRange.location, length: lineCFRange.length)
                if lineRange.location + lineRange.length > range.location && lineRange.location < (range.location + range.length) {
                    var ascent: CGFloat = 0
                    var descent: CGFloat = 0
                    var startX: CGFloat = 0
                    var contentRange = NSRange(location: range.location, length: 0)
                    let end = min(lineRange.location + lineRange.length, range.location + range.length)
                    contentRange.length = end - contentRange.location
                    CTLineGetTypographicBounds(line, &ascent, &descent, nil)
                    let y = coreHeight - origin.y - ascent
                    startX = CTLineGetOffsetForStringIndex(line, contentRange.location, nil)
                    let endX = CTLineGetOffsetForStringIndex(line, contentRange.location + contentRange.length, nil)
                    let rect = CGRect(x: origin.x + startX, y: y, width: endX - startX, height: ascent + descent)
                    rects.append(rect)
                }
            }
        }
        return rects
    }
    
    func touchLocation(point:CGPoint, str:String = "") ->NSRange {
        var touchRange = NSMakeRange(0, 0)
        guard let ctFrame = self.ctFrame else {
            return touchRange
        }
        let lines = CTFrameGetLines(ctFrame) as Array
        var origins = [CGPoint](repeating: CGPoint.zero, count: lines.count)
        CTFrameGetLineOrigins(ctFrame, CFRange(location: 0, length: 0), &origins)
        for index in 0..<lines.count {
            let num = lines.count - index - 1
            let line = lines[index] as! CTLine
            let origin = origins[num]
            var ascent: CGFloat = 0
            var descent: CGFloat = 0
            
            CTLineGetTypographicBounds(line, &ascent, &descent, nil)
            let lineRect = CGRect(x: origin.x, y: origin.y - descent, width: CTLineGetOffsetForStringIndex(line, 100000, nil), height: ascent + descent)
            if lineRect.contains(point) {
                let lineRange = CTLineGetStringRange(line)
                for rangeIndex in 0..<lineRange.length {
                    let location = lineRange.location + rangeIndex
                    var offsetX = CTLineGetOffsetForStringIndex(line, location, nil)
                    var offsetX2 = CTLineGetOffsetForStringIndex(line, location + 1, nil)
                    offsetX += origin.x
                    offsetX2 += origin.x
                    let runs = CTLineGetGlyphRuns(line) as Array
                    for runIndex in 0..<runs.count {
                        let run = runs[runIndex] as! CTRun
                        let runRange = CTRunGetStringRange(run)
                        if runRange.location <= location && location <= (runRange.location + runRange.length - 1) {
                            // 说明在当前的run中
                            var ascent: CGFloat = 0
                            var descent: CGFloat = 0
                            CTRunGetTypographicBounds(run, CFRange(location: 0, length: 0), &ascent, &descent, nil)
                            let frame = CGRect(x: offsetX, y: origin.y - descent, width: (offsetX2 - offsetX)*2, height: ascent + descent)
                            if frame.contains(point) {
                                touchRange = NSRange(location: location, length: min(2, lineRange.length + lineRange.location - location))
                            }
                        }
                    }
                }
            }
        }
        return touchRange
    }
    
    func buildContent(attr:NSAttributedString, andImages:[ZSImageData] , settings:CTSettings) {
        attributeString = NSMutableAttributedString(attributedString: attr)
        imageIndex = 0
        let framesetter = CTFramesetterCreateWithAttributedString(attr as CFAttributedString)
        
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize(width: settings.pageRect.size.width, height: CGFloat.greatestFiniteMagnitude), nil)

        let path = CGMutablePath()
        path.addRect(CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: settings.pageRect.width, height: textSize.height)))
        let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        self.ctFrame = ctframe
        self.coreHeight = textSize.height
        self.imageModels = andImages
        attachImages(andImages, ctframe: ctframe, margin: settings.margin)
        setNeedsDisplay()
    }
    
    func build(withAttrString attrString: NSAttributedString,
               andImages images: [[String: Any]]) {
        imageIndex = 0
        //4
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        let settings = CTSettings.shared
        
        let textSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), nil, CGSize(width: settings.pageRect.size.width, height: CGFloat.greatestFiniteMagnitude), nil)
        self.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: textSize.height)
        if let parentView = self.superview as? UIScrollView {
            parentView.contentSize = CGSize(width: self.bounds.width, height: textSize.height)
        }
        let path = CGMutablePath()
        path.addRect(CGRect(origin: CGPoint(x: 20, y: 20), size: CGSize(width: settings.pageRect.width, height: textSize.height)))
        let ctframe = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        self.ctFrame = ctframe
        attachImagesWithFrame(images, ctframe: ctframe, margin: settings.margin)
    }
    
    func attachImages(_ images: [ZSImageData],ctframe: CTFrame,margin: CGFloat) {
        if images.count == 0 {
            return
        }
        let lines = CTFrameGetLines(ctframe) as NSArray
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        var nextImage:ZSImageData? = imageModels[imageIndex]
        for lineIndex in 0..<lines.count {
            if nextImage == nil {
                break
            }
            let line = lines[lineIndex] as! CTLine
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun]
            {
                for run in glyphRuns {
                    let runAttr = CTRunGetAttributes(run) as? [NSAttributedString.Key:Any]
                    let delegate = runAttr?[(kCTRunDelegateAttributeName as NSAttributedString.Key)]
                    if delegate == nil {
                        continue
                    }
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    var descent: CGFloat = 0
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, &descent, nil))
                    imgBounds.size.height = ascent + descent
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    
                    imgBounds.origin.y -= descent;
                    
                    let pathRef = CTFrameGetPath(ctframe)
                    let colRect = pathRef.boundingBox
                    let delegateBounds = imgBounds.offsetBy(dx: colRect.origin.x, dy: colRect.origin.y)
                    nextImage!.imagePosition = delegateBounds
                    imageModels[imageIndex].imagePosition = imgBounds
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                    } else {
                        nextImage = nil
                    }
                }
            }
        }
    }
    
    func attachImagesWithFrame(_ images: [[String: Any]],
                               ctframe: CTFrame,
                               margin: CGFloat) {
        //1
        let lines = CTFrameGetLines(ctframe) as NSArray
        //2
        var origins = [CGPoint](repeating: .zero, count: lines.count)
        CTFrameGetLineOrigins(ctframe, CFRangeMake(0, 0), &origins)
        //3
        var nextImage = images[imageIndex]
        guard var imgLocation = nextImage["location"] as? Int else {
            return
        }
        //4
        for lineIndex in 0..<lines.count {
            let line = lines[lineIndex] as! CTLine
            //5
            if let glyphRuns = CTLineGetGlyphRuns(line) as? [CTRun],
                let imageFilename = nextImage["filename"] as? String,
                let img = UIImage(named: imageFilename)  {
                for run in glyphRuns {
                    // 1
                    let runRange = CTRunGetStringRange(run)
                    if runRange.location > imgLocation || runRange.location + runRange.length <= imgLocation {
                        continue
                    }
                    //2
                    var imgBounds: CGRect = .zero
                    var ascent: CGFloat = 0
                    imgBounds.size.width = CGFloat(CTRunGetTypographicBounds(run, CFRangeMake(0, 0), &ascent, nil, nil))
                    imgBounds.size.height = ascent
                    //3
                    let xOffset = CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, nil)
                    imgBounds.origin.x = origins[lineIndex].x + xOffset
                    imgBounds.origin.y = origins[lineIndex].y
                    //4
                    self.images += [(image: img, frame: imgBounds)]
                    //5
                    imageIndex! += 1
                    if imageIndex < images.count {
                        nextImage = images[imageIndex]
                        imgLocation = (nextImage["location"] as AnyObject).intValue
                    }
                }
            }
        }
    }
    
    // MARK: - Life Cycle
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        context.textMatrix = .identity
        context.translateBy(x: 0, y: coreHeight)
        context.scaleBy(x: 1.0, y: -1.0)
        
        if rects.count > 0 {
            let lineRects = rects.map { rect -> CGRect in
                return CGRect(x: rect.origin.x - 2, y: coreHeight - rect.origin.y - rect.height, width: rect.width + 4, height: rect.height)
            }
            let fillPath = CGMutablePath()
            UIColor(red:0.92, green:0.5, blue:0.5, alpha:1.00).withAlphaComponent(0.5).setFill()
            fillPath.addRects(lineRects)
            context.addPath(fillPath)
            context.fillPath()
        }
        
        CTFrameDraw(ctFrame!, context)
        
        
        
        for imageData in images {
            if let image = imageData.image.cgImage {
                let imgBounds = imageData.frame
                context.draw(image, in: imgBounds)
            }
        }
        
        for imageModel in imageModels {
            if let image = imageModel.image {
                context.draw(image.cgImage!, in: imageModel.imagePosition)
                continue
            }
            if let url = URL(string: imageModel.parse?.url ?? "" )  {
                ImageDownloader.default.downloadImage(with: url, options: nil, progressBlock: nil) { [weak self] (result) in
                    switch result {
                    case .success(let value):
                        print(value.image)
                        self!.imageModels[self?.indexOfModel(model: imageModel, models: self!.imageModels) ?? 0].image = value.image
                        self?.setNeedsDisplay()
                    case .failure(let error):
                        print(error)
                    }
                }
            }
        }
    }
    
    func indexOfModel(model:ZSImageData, models:[ZSImageData]) ->Int {
        var index = 0
        for data in models {
            if data.parse?.url == model.parse?.url {
                break
            }
            index += 1
        }
        return index
    }
}

extension ZSDisplayView {
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    @objc
    func copyItemFunc() {
        
    }
    
    func showMenuController() {
        if self.becomeFirstResponder() {
            let selectionRect = rectForMenuController()
            let menu = UIMenuController.shared
            let copyItem = UIMenuItem(title: "Copy", action: #selector(copyItemFunc))
            menu.menuItems = [copyItem]
            menu.setTargetRect(selectionRect, in: self)
            menu.setMenuVisible(true, animated: true)
        }
    }
    
    func hideMenuController() {
        if self.resignFirstResponder() {
            let menu = UIMenuController.shared
            menu.setMenuVisible(false, animated: true)
        }
    }
    
    func rectForMenuController()->CGRect {
        guard let firstRect = rects.first else { return CGRect.zero }
        guard let lastRect = rects.last else { return CGRect.zero }
        var menuRect:CGRect = CGRect.zero
        // 尝试在第一行的上方展示
        if firstRect.origin.y < 50 {
            menuRect = CGRect(x: bounds.width/2 - 50, y: lastRect.origin.y + 50, width: 100, height: 30)
        } else {
            menuRect = CGRect(x: bounds.width/2 - 50, y: firstRect.origin.y - 50, width: 100, height: 30)
        }
        return menuRect
    }
    
//    - (void)showMenuController {
//        if ([self becomeFirstResponder]) {
//            CGRect selectionRect = [self rectForMenuController];
//            // 翻转坐标系
//            CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
//            transform = CGAffineTransformScale(transform, 1.f, -1.f);
//            selectionRect = CGRectApplyAffineTransform(selectionRect, transform);
//
//            UIMenuController *theMenu = [UIMenuController sharedMenuController];
//            [theMenu setTargetRect:selectionRect inView:self];
//            [theMenu setMenuVisible:YES animated:YES];
//        }
//    }
//
//    - (void)hideMenuController {
//        if ([self resignFirstResponder]) {
//            UIMenuController *theMenu = [UIMenuController sharedMenuController];
//            [theMenu setMenuVisible:NO animated:YES];
//        }
//    }
}
