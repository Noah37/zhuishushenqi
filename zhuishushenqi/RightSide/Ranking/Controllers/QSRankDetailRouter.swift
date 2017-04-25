//
//  QSRankDetailRouter.swift
//  zhuishushenqi
//
//  Created by Nory Cao on 2017/4/13.
//  Copyright © 2017年 QS. All rights reserved.
//

import Foundation
import UIKit

class QSRankDetailRouter: QSRankDetailWireframeProtocol {
    weak var viewController: UIViewController?
    
    static func createModule(novel:QSRankModel) -> UIViewController {
        // Change to get view from storyboard if not using progammatic UI
        let view = QSRankDetailViewController(nibName: nil, bundle: nil)
        view.model = novel
        let interactor = QSRankDetailInteractor()
        let router = QSRankDetailRouter()
        let presenter = QSRankDetailPresenter(interface: view, interactor: interactor, router: router)
        
        view.presenter = presenter
        interactor.output = presenter
        router.viewController = view
        
        return view
    }
    
    func presentDetails(_ book: Book) {
        viewController?.navigationController?.pushViewController(QSBookDetailRouter.createModule(id: book._id ?? ""), animated: true)
    }
}
