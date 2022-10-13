//
//  ExchangePresenter.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol)
    var dataSource: [CurrencySections] { get }
    func viewDidLoad()
}

final class ExchangePresenter: ExchangeViewPresenterProtocol {
    
    // MARK: Properties
    var dataSource: [CurrencySections] = [.currencyBalance([]),
                                          .currencyExchange([])]
    
    // MARK: Private
    private var router: RouterProtocol?
    private weak var view: ExchangeViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private var currencyBalance: [AmountCurrency] = CurrencyEnum.allCases.compactMap {
        // TODO: Replace to get current balance from api
        AmountCurrency(amount: $0 == CurrencyEnum.euro ? "1000.00" : "0.00",
                       currency: $0.title)
    }
    private var currencyExchange: [ExchangeModel] = []
    private var shouldUpdateLayout = true
    
    // MARK: Life Cycle
    required init(view: ExchangeViewProtocol,
                  networkService: NetworkServiceProtocol,
                  router: RouterProtocol) {
        self.view = view
        self.networkService = networkService
        self.router = router
    }
    
    // MARK: Internal
    func viewDidLoad() {
        getCurrencyExchange()
        updateDataSource()
    }
    
}


private extension ExchangePresenter {
    
    func composeDataSourceSections() -> [CurrencySections] {
        var dataSourceSections = [CurrencySections]()
        
        if !currencyBalance.isEmpty {
            let currencyBalanceSection = CurrencySections.currencyBalance(currencyBalance)
            dataSourceSections.append(currencyBalanceSection)
        }
        
        if !currencyExchange.isEmpty {
            let currencyExchangeSection = CurrencySections.currencyExchange(currencyExchange)
            dataSourceSections.append(currencyExchangeSection)
        }
        
        shouldUpdateLayout = self.dataSource != dataSourceSections
        
        return dataSourceSections
    }
    
    func composeSnapshot() -> NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable> {
        var newSnapshot = NSDiffableDataSourceSnapshot<CurrencySections, AnyHashable>()
        newSnapshot.appendSections(dataSource)
        
        dataSource.forEach { section in
            switch section {
            case .currencyBalance(let array):
                newSnapshot.appendItems(array, toSection: section)
            case .currencyExchange(let array):
                newSnapshot.appendItems(array, toSection: section)
            }
        }
        return newSnapshot
    }
    
    func updateLayoutIfNeeded() {
        if shouldUpdateLayout {
            view?.updateLayout(sections: dataSource)
        }
    }
    
    func updateDataSource(animated: Bool = false) {
        dataSource = composeDataSourceSections()
        updateLayoutIfNeeded()
        DispatchQueue.global().async { [unowned self] in
            view?.setDataSource(snapshot: composeSnapshot(),
                                animated: animated)
        }
    }
    
    func getCurrencyExchange(fromAmount: Double = 100,
                             fromCurrency: String = CurrencyEnum.euro.title,
                             toCurrency: String = CurrencyEnum.americanDollar.title) {
        let endpoint = EndPoint.convertCurrency(fromAmount: fromAmount,
                                                fromCurrency: fromCurrency,
                                                toCurrency: toCurrency)
        networkService.request(endPoint: endpoint,
                               expecting: AmountCurrency.self) { [weak self] result in
            switch result {
            case .success(let result):
                if let result = result {
                    self?.composeCurrencyExchange(from: result)
                }
            case .failure(let error):
                self?.view?.showErrorAlert(with: "Failed to exchange currancy: \(error)")
            }
        }
    }
    
    func composeCurrencyExchange(from amountCurrency: AmountCurrency) {
        let sellModel = ExchangeModel(from: amountCurrency,
                                      and: DealTypeEnum.sell)
        let receiveModel = ExchangeModel(from: amountCurrency,
                                         and: DealTypeEnum.receive)
        currencyExchange = [sellModel, receiveModel]
        updateDataSource(animated: true)
    }
}
