//
//  QSRankDetailProtoocol.swift
//  zhuishushenqi
//
//  Created by caonongyun on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

//MARK: Wireframe -
protocol QSRankDetailWireframeProtocol: class {
    weak var viewController: UIViewController? { get set }
    func presentDetails(_ book: Book)
    
    static func createModule(novel:QSRankModel) -> UIViewController
}

//MARK: Presenter -
protocol QSRankDetailPresenterProtocol: class {
    weak var view: QSRankDetailViewProtocol?{ get set }
    var interactor: QSRankDetailInteractorProtocol{ get set }
    var router: QSRankDetailWireframeProtocol{ get set }
    func viewDidLoad(novel:QSRankModel)
    func didSelectSeg(index:Int)
    func didSelectResultRow(indexPath:IndexPath)
}

//MARK: Output -
protocol QSRankDetailInteractorOutputProtocol: class {
    func fetchRankSuccess(ranks:[[Book]])
    func fetchRankFailed()
}

//MARK: Interactor -
protocol QSRankDetailInteractorProtocol: class {
    var output: QSRankDetailInteractorOutputProtocol! { get set }
    func fetchRanks(novel:QSRankModel,index:Int)
}

//MARK: View -
protocol QSRankDetailViewProtocol: IndicatableView {
    var presenter: QSRankDetailPresenterProtocol?  { get set }
    func showRanks(ranks:[[Book]])
    func showEmpty()
}

