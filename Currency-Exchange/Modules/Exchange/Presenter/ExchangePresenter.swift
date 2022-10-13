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
    func getCurrencyExchange(fromAmount: Double?,
                             fromCurrency: String?,
                             toCurrency: String?)
    func convertCurrencyBalanceIfPossible() 
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
        AmountCurrency(amount: $0 == CurrencyEnum.euro ? 1000.00 : 0.00,
                       currency: $0.title)
    }
    private var currencyExchange: [ExchangeModel] = []
    private var currentCurrency: CurrencyEnum = .euro
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
    
    func convertCurrencyBalanceIfPossible() {
        guard let fromCurrencyExchange = currencyExchange.first?.amountCurrency,
              let toCurrencyExchange = currencyExchange.last?.amountCurrency else { return }
              
        
        guard var currencyForSell = currencyBalance.first(where: {
            $0.currency == fromCurrencyExchange.currency}),
                currencyForSell.amount >= fromCurrencyExchange.amount else {
            // TODO: Show no balance alert
            return
        }
        
        if var currencyForReceive = currencyBalance.first(where: {
            $0.currency == toCurrencyExchange.currency}) {
            
            convertCurrencyBalance(fromCurrencyExchange: fromCurrencyExchange,
                                   toCurrencyExchange: toCurrencyExchange,
                                   fromCurrencyBalance: &currencyForSell,
                                   toCurrencyBalance: &currencyForReceive)
        } else {
            // TODO: Add possibility to add new currency
        }
    }
    
    func getCurrencyExchange(fromAmount: Double? = 100,
                             fromCurrency: String? = CurrencyEnum.euro.title,
                             toCurrency: String? = CurrencyEnum.americanDollar.title) {
        guard let amountFromCurrencyExchange = fromAmount ?? currencyExchange.first?.amountCurrency.amount,
              let currencyFromCurrencyExchange = fromCurrency ?? currencyExchange.first?.amountCurrency.currency ,
              let toCurrencyExchange =  toCurrency ?? currencyExchange.last?.amountCurrency.currency else { return }
        
        if !currencyExchange.isEmpty {
            currencyExchange[0].amountCurrency.amount = amountFromCurrencyExchange
            currencyExchange[0].amountCurrency.currency = currencyFromCurrencyExchange
        }
        
        let endpoint = EndPoint.convertCurrency(fromAmount: fromAmount ?? amountFromCurrencyExchange,
                                                fromCurrency: fromCurrency ?? currencyFromCurrencyExchange,
                                                toCurrency: toCurrencyExchange)
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
    
    func composeCurrencyExchange(from amountCurrency: AmountCurrency) {
        // TODO: move 100 to constant
        let amountCurrencyFrom = AmountCurrency(amount: currencyExchange.first?.amountCurrency.amount ?? 100,
                                                currency: currencyExchange.first?.amountCurrency.currency ?? CurrencyEnum.euro.title)
        let sellModel = ExchangeModel(from: amountCurrencyFrom,
                                      and: DealTypeEnum.sell)
        let receiveModel = ExchangeModel(from: amountCurrency,
                                         and: DealTypeEnum.receive)
        currencyExchange = [sellModel, receiveModel]
        updateDataSource(animated: true)
    }
    
    func convertCurrencyBalance(fromCurrencyExchange: AmountCurrency,
                                toCurrencyExchange: AmountCurrency,
                                fromCurrencyBalance: inout AmountCurrency,
                                toCurrencyBalance: inout AmountCurrency) {
        fromCurrencyBalance = fromCurrencyExchange
        toCurrencyBalance = toCurrencyExchange
    }
}
