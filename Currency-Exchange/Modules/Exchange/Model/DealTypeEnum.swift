//
//  DealTypeEnum.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen.CurrencyExchange

enum DealTypeEnum: BaseEnumProtocol {
    
    case sell
    case receive
    
    var title: String {
        switch self {
        case .sell:
            return Localized.sell
        case .receive:
            return Localized.receive
        }
    }
    
    var icon: UIImage? {
        switch self {
        case .sell:
            return UIImage(systemName: "arrow.up")
        case .receive:
            return UIImage(systemName: "arrow.down")
        }
    }
    
    var color: UIColor {
        switch self {
        case .sell:
            return Colors.exchangeRed.color
        case .receive:
            return Colors.exchangeGeen.color
        }
    }
}
