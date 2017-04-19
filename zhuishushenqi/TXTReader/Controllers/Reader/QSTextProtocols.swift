//
//  QSTextProtocols.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/14.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

//MARK: Wireframe -
protocol QSTextWireframeProtocol: class {
    weak var viewController: UIViewController? { get set }
    func presentDetails(_ novel:QSRankModel)
    
    static func createModule(bookDetail:BookDetail) -> UIViewController
}

//MARK: Presenter -
protocol QSTextPresenterProtocol: class {
    weak var view: QSTextViewProtocol?{ get set }
    var interactor: QSTextInteractorProtocol{ get set }
    var router: QSTextWireframeProtocol{ get set }
    func viewDidLoad(bookDetail:BookDetail)
    func didClickContent()
    func didClickChangeSource()
    func didClickCategory()
    func didClickBack()
}

//MARK: Output -
protocol QSTextInteractorOutputProtocol: class {
    func fetchAllChaptersSuccess(chapters:[NSDictionary])
    func fetchAllChaptersFailed()
    func fetchChapterSuccess(chapter:Dictionary<String, Any>,index:Int)
    func fetchChapterFailed()
    func fetchAllResourceSuccess(resource:[ResourceModel])
    func fetchAllResourceFailed()
}

//MARK: Interactor -
protocol QSTextInteractorProtocol: class {
    var output: QSTextInteractorOutputProtocol! { get set }
    func requestAllResource(bookDetail:BookDetail)
    func requestAllChapters(selectedIndex:Int)
    func requestChapter(atIndex chapterIndex:Int)
    func getPage(chapter:Int,pageIndex:Int) -> QSChapter?
    func getLocalPage(chapter:Int,pageIndex:Int)->QSChapter?
    func book(bookDetail:BookDetail?,chapters:[NSDictionary]?,resources:[ResourceModel]?)->QSBook//更换书籍来源则需要更新book.chapters信息,请求某一章节成功后也需要刷新chapters的content及其他信息
    func setChapters(chapterParam:NSDictionary?,index:Int,chapters:[QSChapter])->[QSChapter]
}

//MARK: View -
protocol QSTextViewProtocol: IndicatableView {
    var presenter: QSTextPresenterProtocol?  { get set }
    func showResources(resources:[ResourceModel])
    func showAllChapter(chapters:[NSDictionary])
    func showChapter(chapter:Dictionary<String, Any>,index:Int)
    func showLocalChapter()
    func showEmpty()
}

