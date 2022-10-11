//
//  ExchangePresenter.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

protocol ExchangeViewProtocol: AnyObject {
    
}

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol,
         router: RouterProtocol)
}

final class ExchangePresenter: ExchangeViewPresenterProtocol {
 
    private weak var view: ExchangeViewProtocol?
    private var router: RouterProtocol?
    
    required init(view: ExchangeViewProtocol,
                  router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
}
