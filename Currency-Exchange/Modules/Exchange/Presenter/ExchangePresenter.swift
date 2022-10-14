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
    func convertCurrencyBalanceIfPossible()
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
    private var currencyBalance: [AmountCurrency] = CurrencyEnum.allCases.compactMap {
        // TODO: Replace to get current balance from api
        AmountCurrency(amount: $0 == CurrencyEnum.euro ? 1000.00 : 0.00,
                       currency: $0.title)
    }
    private var currencyExchange: [ExchangeModel] = []
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
    
    func convertCurrencyBalanceIfPossible() {
        guard let fromCurrencyExchange = currencyExchange.first?.amountCurrency,
              let toCurrencyExchange = currencyExchange.last?.amountCurrency else { return }
        
        
        guard let currencyForSell = currencyBalance.first(where: {
            $0.currency == fromCurrencyExchange.currency}),
              currencyForSell.amount >= fromCurrencyExchange.amount else {
            configureNotEnoughMoneyAlert()
            return
        }
        
        guard fromCurrencyExchange.currency != toCurrencyExchange.currency else {
            view?.configureAlert(with: [(Localized.AlertActions.done,
                                         UIAlertAction.Style.default,
                                         { return })],
                                 alertTitle: Localized.SameСurrencies.title,
                                 alertMessage: Localized.SameСurrencies.message)
            return
        }
        
        guard let currencyForReceiveIndex = currencyBalance.firstIndex(where: {
            $0.currency == toCurrencyExchange.currency}),
              let currencyForSellIndex = currencyBalance.firstIndex(where: {
                  $0.currency == fromCurrencyExchange.currency}) else { return }
        
        showInfoAlert(fromCurrencyExchange: fromCurrencyExchange,
                      toCurrencyExchange: toCurrencyExchange)
        
        convertCurrencyBalance(fromCurrencyExchangeAmount: fromCurrencyExchange.amount,
                               toCurrencyExchangeAmount: toCurrencyExchange.amount,
                               fromCurrencyBalance: currencyForSellIndex,
                               toCurrencyBalance: currencyForReceiveIndex)
    }
    
    func getCurrencyExchange(fromAmount: Double? = 100,
                             fromCurrency: String? = CurrencyEnum.euro.title,
                             toCurrency: String? = CurrencyEnum.americanDollar.title) {
        guard let amountFromCurrencyExchange = fromAmount ?? currencyExchange.first?.amountCurrency.amount,
              let currencyFromCurrencyExchange = fromCurrency ?? currencyExchange.first?.amountCurrency.currency ,
              let toCurrencyExchange =  toCurrency ?? currencyExchange.last?.amountCurrency.currency else { return }
        
        if !currencyExchange.isEmpty {
            currencyExchange[DealTypeEnum.sell.rawValue].amountCurrency.amount = amountFromCurrencyExchange
            currencyExchange[DealTypeEnum.sell.rawValue].amountCurrency.currency = currencyFromCurrencyExchange
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
                self?.view?.configureAlert(with: [(Localized.AlertActions.done,
                                                   UIAlertAction.Style.default,
                                                   { return })],
                                           alertTitle: Localized.ErrorAlert.title,
                                           alertMessage: Localized.ErrorAlert.message(error))
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
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.5,
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
        let amountCurrencyFrom = AmountCurrency(amount: currencyExchange.first?.amountCurrency.amount ?? defaultAmountForConvert,
                                                currency: currencyExchange.first?.amountCurrency.currency ?? CurrencyEnum.euro.title)
        let sellModel = ExchangeModel(from: amountCurrencyFrom,
                                      and: DealTypeEnum.sell)
        let receiveModel = ExchangeModel(from: amountCurrency,
                                         and: DealTypeEnum.receive)
        currencyExchange = [sellModel, receiveModel]
        updateDataSource(animated: true)
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
            configureNotEnoughMoneyAlert()
        } else {
            currencyBalance[fromCurrencyBalance].amount -= fromCurrencyExchangeAmount + commissionFee
            currencyBalance[toCurrencyBalance].amount += toCurrencyExchangeAmount
            
            updateDataSource(animated: true)
        }
    }
    
    func showInfoAlert(fromCurrencyExchange: AmountCurrency,
                       toCurrencyExchange: AmountCurrency) {
        
        if exemptionPayingCommissionIsActive() {
            view?.configureAlert(with: [(Localized.AlertActions.done,
                                         UIAlertAction.Style.default,
                                         { return})],
                                 alertTitle: Localized.CurrencyConvertedAlert.title,
                                 alertMessage: Localized.CurrencyConvertedAlert.messageWithOutFee(
                                    "\(fromCurrencyExchange.amount) \(fromCurrencyExchange.currency)",
                                    "\(toCurrencyExchange.amount) \(toCurrencyExchange.currency)",
                                    "\(exemptionPayingCommission)"))
        } else {
            view?.configureAlert(with: [(Localized.AlertActions.done,
                                         UIAlertAction.Style.default,
                                         { return})],
                                 alertTitle: Localized.CurrencyConvertedAlert.title,
                                 alertMessage: Localized.CurrencyConvertedAlert.messageWithFee(
                                    "\(fromCurrencyExchange.amount) \(fromCurrencyExchange.currency)",
                                    "\(toCurrencyExchange.amount) \(toCurrencyExchange.currency)",
                                    "\(calculateСommissionFee(amount: fromCurrencyExchange.amount))",
                                    "\(fromCurrencyExchange.currency)"))
        }
    }
    
    func exemptionPayingCommissionIsActive() -> Bool {
        exemptionPayingCommission -= 1
        if exemptionPayingCommission >= 0 {
            return true
        }
        return false
    }
    
    func calculateСommissionFee(amount: Double) -> Double {
        return round(amount * commissionFeeMultiplier * 100) / 100.0
    }
    
    func configureNotEnoughMoneyAlert() {
        view?.configureAlert(with: [(Localized.AlertActions.done,
                                     UIAlertAction.Style.default,
                                     { return })],
                             alertTitle: Localized.NotEnoughMoneyAlert.title,
                             alertMessage: Localized.NotEnoughMoneyAlert.message)
    }
}
