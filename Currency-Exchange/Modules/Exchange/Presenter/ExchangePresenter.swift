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
    func getCurrencyDataCount() -> Int
    func getCurrency(at index: Int) -> CurrencyEnum
    func getDealType(at index: Int) -> DealTypeEnum
    
}

final class ExchangePresenter: ExchangeViewPresenterProtocol {
    
    // MARK: Properties
    private var router: RouterProtocol?
    private weak var view: ExchangeViewProtocol?
    private let currencyDataSource: [CurrencyEnum] = [.americanDollar,
                                                      .euro,
                                                      .japaneseYen]
    private let dealTypeDataSource: [DealTypeEnum] = [.sell,
                                                      .receive]
    
    // MARK: Life Cycle
    required init(view: ExchangeViewProtocol,
                  router: RouterProtocol) {
        self.view = view
        self.router = router
    }
    
    // MARK: Internal
    func getCurrencyDataCount() -> Int {
        return currencyDataSource.count
    }
    
    func getCurrency(at index: Int) -> CurrencyEnum {
        return currencyDataSource[index]
    }
    
    func getDealType(at index: Int) -> DealTypeEnum {
        return dealTypeDataSource[index]
    }
}
