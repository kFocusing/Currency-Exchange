//
//  CurrencySections.swift
//  Currency-Exchange
//
//  Created on 12.10.2022.
//

import Foundation

private typealias Localized = Localization.ExchangeScreen

enum CurrencySections: TitleEnumProtocol, Hashable {
    
    static func == (lhs: CurrencySections, rhs: CurrencySections) -> Bool {
        switch (lhs, rhs) {
        case (.currencyBalance, .currencyBalance):
            return true
        case (.currencyExchange, .currencyExchange):
            return true
        default:
            return false
        }
    }
    
    case currencyBalance([AmountCurrency])
    case currencyExchange([ExchangeModel])
    
    var title: String {
        switch self {
        case .currencyBalance:
            return Localized.balanceSectionTitle
        case .currencyExchange:
            return Localized.currencyExchangeSectionTitle
        }
    }
    
}
