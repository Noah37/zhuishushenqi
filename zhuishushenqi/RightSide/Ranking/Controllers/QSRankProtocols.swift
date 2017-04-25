//
//  QSRankProtocols.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

//MARK: Wireframe -
protocol QSRankWireframeProtocol: class {
    weak var viewController: UIViewController? { get set }
    func presentDetails(_ novel:QSRankModel)
    
    static func createModule() -> UIViewController
}

//MARK: Presenter -
protocol QSRankPresenterProtocol: class {
    weak var view: QSRankViewProtocol?{ get set }
    var interactor: QSRankInteractorProtocol{ get set }
    var router: QSRankWireframeProtocol{ get set }
    func viewDidLoad()
    func didClickOpenBtn(indexPath:IndexPath,show:[Bool])
    func didSelectResultRow(indexPath:IndexPath)
}

//MARK: Output -
protocol QSRankInteractorOutputProtocol: class {
    func fetchRankSuccess(ranks:[[QSRankModel]])
    func fetchRankFailed()
    func fetchWithShow(show:[Bool])
}

//MARK: Interactor -
protocol QSRankInteractorProtocol: class {
    var output: QSRankInteractorOutputProtocol! { get set }
    func fetchRanks()
}

//MARK: View -
protocol QSRankViewProtocol: IndicatableView {
    var presenter: QSRankPresenterProtocol?  { get set }
    func showRanks(ranks:[[QSRankModel]])
    func showEmpty()
    func show(show:[Bool])
}

