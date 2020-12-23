//
//  ZSRegularVerifyViewController.swift
//  zhuishushenqi
//
//  Created by yung on 2020/12/18.
//  Copyright © 2020 QS. All rights reserved.
//

import UIKit
import SnapKit

class ZSRegularVerifyViewController: BaseViewController {

    private let htmlTextPlaceHolder = "请输入html文本"
    private let resultTextPlaceHolder = "测试结果："
    
    override func viewDidLoad() {
        super.viewDidLoad()

        title = "规则验证"
        view.addSubview(typeSelect)
        view.addSubview(htmlTextTV)
        view.addSubview(regularTF)
        view.addSubview(parseBT)
        view.addSubview(resultLabel)
        typeSelect.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(40)
            make.top.equalToSuperview().offset(kNavgationBarHeight + 20)
        }
        
        htmlTextTV.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.typeSelect.snp_bottomMargin).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        regularTF.snp.makeConstraints { [unowned self] (make) in
            make.top.equalTo(self.htmlTextTV.snp_bottomMargin).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        parseBT.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.regularTF.snp_bottomMargin).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(44)
        }
        resultLabel.snp.makeConstraints { [unowned self](make) in
            make.top.equalTo(self.parseBT.snp_bottomMargin).offset(20)
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
            make.height.equalTo(200)
        }
        htmlTextTV.text = htmlTextPlaceHolder
        resultLabel.loadHTMLString(resultTextPlaceHolder, baseURL: nil)
    }
    
    @objc
    private func parseAction(btn:UIButton) {
        let htmlText = htmlTextTV.text ?? ""
        let regularText = regularTF.text ?? ""
        let typeSelectedIndex = typeSelect.selectedSegmentIndex
        if let document = OCGumboDocument(htmlString: htmlText) {
            let parse = AikanHtmlParser()
            switch typeSelectedIndex {
            case 0:
                let elements = parse.elementArray(with: document, withRegexString: regularText)
                var resultText = ""
                elements.enumerateObjects { (node, idx, stop) in
                    guard let element = node as? OCGumboNode else { return }
                    resultText.append("\(element.html() ?? "")<br/>")
                }
//                let htmlData = NSString(string: resultText).data(using: String.Encoding.unicode.rawValue)
//                let options = [NSAttributedString.DocumentReadingOptionKey.documentType:
//                NSAttributedString.DocumentType.html]
//                let attributedString = try? NSMutableAttributedString(data: htmlData ?? Data(),
//                                                                  options: options,
//                                                                  documentAttributes: nil)
                resultLabel.loadHTMLString(resultText, baseURL: nil)
                break
            case 1:
                let objs = parse.string(withGumboNode: document, withAikanString: regularText, withText: true)
                resultLabel.loadHTMLString("\(objs)", baseURL: nil)
                break
            case 2:
                let attr = ZSReaderDownloader.share.contentReplace(string: htmlText, reg: regularText)
                resultLabel.loadHTMLString("\(attr)", baseURL: nil)

                break
            default:
                break
            }
        }
    }
    
    // MARK: - lazy
    lazy var typeSelect: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["array", "string", "contentReplace"])
        seg.tintColor = UIColor.red
        if #available(iOS 13.0, *) {
            seg.selectedSegmentTintColor = UIColor.white
        } else {
            // Fallback on earlier versions
        }
        seg.selectedSegmentIndex = 1
        return seg
    }()
    
    lazy var htmlTextTV: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 13)
        tv.textColor = UIColor.gray
        tv.layer.cornerRadius = 5
        tv.layer.masksToBounds = true
        tv.delegate = self
        return tv
    }()
    
    lazy var regularTF: UITextField = {
        let tf = UITextField()
        tf.placeholder = "请输入规则"
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 5
        tf.layer.masksToBounds = true
        return tf
    }()
    
    lazy var parseBT: UIButton = {
        let bt = UIButton(type: .custom)
        bt.setTitle("开始测试", for: .normal)
        bt.setTitleColor(UIColor.white, for: .normal)
        bt.backgroundColor = UIColor.red
        bt.layer.cornerRadius = 5
        bt.layer.masksToBounds = true
        bt.addTarget(self, action: #selector(parseAction(btn:)), for: .touchUpInside)
        return bt
    }()
    
    lazy var resultLabel: UIWebView = {
        let lb = UIWebView()
        lb.layer.cornerRadius = 5
        lb.layer.masksToBounds = true
        return lb
    }()

}

extension ZSRegularVerifyViewController:UITextViewDelegate {
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        if textView.text.count == 0 {
            htmlTextTV.text = htmlTextPlaceHolder
        }
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == htmlTextPlaceHolder {
            textView.text = ""
        }
    }
}
