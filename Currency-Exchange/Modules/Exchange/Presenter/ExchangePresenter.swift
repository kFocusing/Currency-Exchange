//
//  ExchangePresenter.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen

protocol ExchangeViewPresenterProtocol: AnyObject {
    init(view: ExchangeViewProtocol,
         networkService: NetworkServiceProtocol,
         router: RouterProtocol)
    var dataSource: [CurrencySections] { get }
    func viewDidLoad()
    func getCurrencyExchange(fromAmount: Double?,
                             fromCurrency: String?,
                             toCurrency: String?)
    func convertCurrencyBalance()
    func didEnterAmount(_ amount: Double)
}

final class ExchangePresenter: ExchangeViewPresenterProtocol {
    
    // MARK: Properties
    var dataSource: [CurrencySections] = [.currencyBalance([]),
                                          .currencyExchange([])]
    
    // MARK: Private
    private var router: RouterProtocol?
    private weak var view: ExchangeViewProtocol?
    private let networkService: NetworkServiceProtocol!
    private var currencyBalance: [AmountCurrency] = Currency.allCases.compactMap {
        // TODO: Replace to get current balance from api
        AmountCurrency(amount: $0 == Currency.euro ? 1000.00 : 0.00,
                       currency: $0.title)
    }
    private var currencyExchangeList: [ExchangeModel] = []
    private let commissionFeeMultiplier = 0.0070
    private var exemptionPayingCommission = 5
    private let defaultAmountForConvert: Double = 100
    private var workItem: DispatchWorkItem?
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
        if NetworkMonitor.shared.isConnected {
            getCurrencyExchange()
            updateDataSource()
        } else {
            view?.internetConnectionLost {
                exit(-1)
            }
        }
    }
    
    func convertCurrencyBalance() {
        guard let fromCurrencyExchange = currencyExchangeList.first?.amountCurrency,
              let toCurrencyExchange = currencyExchangeList.last?.amountCurrency else { return }
        
        
        guard let currencyForSell = currencyBalance.first(where: {
            $0.currency == fromCurrencyExchange.currency}),
              currencyForSell.amount >= fromCurrencyExchange.amount else {
            view?.showError(with: Localized.NotEnoughMoneyAlert.title,
                            and: Localized.NotEnoughMoneyAlert.message)
            return
        }
        
        guard fromCurrencyExchange.currency != toCurrencyExchange.currency else {
            view?.showError(with: Localized.SameСurrencies.title,
                            and: Localized.SameСurrencies.message)
            return
        }
        
        guard let currencyForReceiveIndex = currencyBalance.firstIndex(where: {
            $0.currency == toCurrencyExchange.currency}),
              let currencyForSellIndex = currencyBalance.firstIndex(where: {
                  $0.currency == fromCurrencyExchange.currency}) else { return }
        
        configureConvertCurrencyInfo(fromCurrencyExchange: fromCurrencyExchange,
                                     toCurrencyExchange: toCurrencyExchange) {
            self.convertCurrencyBalance(fromCurrencyExchangeAmount: fromCurrencyExchange.amount,
                                        toCurrencyExchangeAmount: toCurrencyExchange.amount,
                                        fromCurrencyBalance: currencyForSellIndex,
                                        toCurrencyBalance: currencyForReceiveIndex)
        }
    }
    
    func getCurrencyExchange(fromAmount: Double? = 100,
                             fromCurrency: String? = Currency.euro.title,
                             toCurrency: String? = Currency.americanDollar.title) {
        guard let amountFromCurrencyExchange = fromAmount ?? currencyExchangeList.first?.amountCurrency.amount,
              let currencyFromCurrencyExchange = fromCurrency ?? currencyExchangeList.first?.amountCurrency.currency ,
              let toCurrencyExchange =  toCurrency ?? currencyExchangeList.last?.amountCurrency.currency else { return }
        
        if !currencyExchangeList.isEmpty {
            currencyExchangeList[DealType.sell.rawValue].amountCurrency.amount = amountFromCurrencyExchange
            currencyExchangeList[DealType.sell.rawValue].amountCurrency.currency = currencyFromCurrencyExchange
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
                self?.view?.showError(with: Localized.ErrorAlert.title,
                                      and: Localized.ErrorAlert.message(error))
            }
        }
    }
    
    func didEnterAmount(_ amount: Double) {
        workItem?.cancel()
        let newWorkItem = DispatchWorkItem { [weak self] in
            self?.getCurrencyExchange(fromAmount: amount,
                                      fromCurrency: nil,
                                      toCurrency: nil)
        }
        workItem = newWorkItem
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.0001,
                                          execute: newWorkItem)
    }
}


private extension ExchangePresenter {
    func composeDataSourceSections() -> [CurrencySections] {
        var dataSourceSections = [CurrencySections]()
        
        if !currencyBalance.isEmpty {
            let currencyBalanceSection = CurrencySections.currencyBalance(currencyBalance)
            dataSourceSections.append(currencyBalanceSection)
        }
        
        if !currencyExchangeList.isEmpty {
            let currencyExchangeSection = CurrencySections.currencyExchange(currencyExchangeList)
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
        let amountCurrencyFrom = AmountCurrency(amount: currencyExchangeList.first?.amountCurrency.amount ?? defaultAmountForConvert,
                                                currency: currencyExchangeList.first?.amountCurrency.currency ?? Currency.euro.title)
        
        let receiveModel = ExchangeModel(from: amountCurrency,
                                         and: .receive)
        
        if currencyExchangeList.isEmpty {
            let sellModel = ExchangeModel(from: amountCurrencyFrom,
                                          and: .sell)
            
            currencyExchangeList = [sellModel, receiveModel]
            updateDataSource(animated: true)
        } else if let receiveModelIndex = currencyExchangeList.firstIndex(where: {
            $0.dealType == .receive
        }) {
            currencyExchangeList[receiveModelIndex].update(from: receiveModel)
            view?.reloadItems([currencyExchangeList[receiveModelIndex]])
        }
    }
    
    func convertCurrencyBalance(fromCurrencyExchangeAmount: Double,
                                toCurrencyExchangeAmount: Double,
                                fromCurrencyBalance: Int,
                                toCurrencyBalance: Int) {
        
        var commissionFee: Double = 0
        if exemptionPayingCommission < 0 {
            commissionFee = calculateСommissionFee(amount: fromCurrencyExchangeAmount)
        }
        
        if currencyBalance[fromCurrencyBalance].amount - (fromCurrencyExchangeAmount + commissionFee) < 0 {
            view?.showError(with: Localized.NotEnoughMoneyAlert.title,
                            and: Localized.NotEnoughMoneyAlert.message)
        } else {
            currencyBalance[fromCurrencyBalance].amount -= fromCurrencyExchangeAmount + commissionFee
            currencyBalance[toCurrencyBalance].amount += toCurrencyExchangeAmount
            
            updateDataSource(animated: true)
        }
    }
    
    func configureConvertCurrencyInfo(fromCurrencyExchange: AmountCurrency,
                                      toCurrencyExchange: AmountCurrency,
                                      completion: @escaping EmptyBlock) {
        let alertTitle: String
        let alertMessage: String
        
        if exemptionPayingCommissionIsActive() {
            alertTitle = Localized.CurrencyConvertedAlert.title
            alertMessage = Localized.CurrencyConvertedAlert.messageWithOutFee(
                "\(fromCurrencyExchange.amount.inMoneyFormat) \(fromCurrencyExchange.currency)",
                "\(toCurrencyExchange.amount.inMoneyFormat) \(toCurrencyExchange.currency)",
                "\(exemptionPayingCommission)")
        } else {
            alertTitle = Localized.CurrencyConvertedAlert.title
            alertMessage = Localized.CurrencyConvertedAlert.messageWithFee(
                "\(fromCurrencyExchange.amount.inMoneyFormat) \(fromCurrencyExchange.currency)",
                "\(toCurrencyExchange.amount.inMoneyFormat) \(toCurrencyExchange.currency)",
                "\(calculateСommissionFee(amount: fromCurrencyExchange.amount))",
                "\(fromCurrencyExchange.currency)")
        }
        
        view?.showCurrencyConvertedMessage(with: alertTitle,
                                           and: alertMessage,
                                           completion: {
            self.decrimentExemptionPayingCommission()
            completion()
        })
    }
    
    func exemptionPayingCommissionIsActive() -> Bool {
        if exemptionPayingCommission >= 0 {
            return true
        }
        return false
    }
    
    func decrimentExemptionPayingCommission() {
        exemptionPayingCommission -= 1
    }
    
    func calculateСommissionFee(amount: Double) -> Double {
        return round(amount * commissionFeeMultiplier * 100) / 100.0
    }
}
