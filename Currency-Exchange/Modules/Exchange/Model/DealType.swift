//
//  DealType.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

private typealias Localized = Localization.ExchangeScreen.CurrencyExchange

enum DealType: Int, TitleAndImage {
    
    case sell = 0
    case receive = 1
    
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
            return ImageAssets.arrowUp.image
        case .receive:
            return ImageAssets.arrowDown.image
        }
    }
    
    var color: UIColor {
        switch self {
        case .sell:
            return Colors.exchangeRed.color
        case .receive:
            return Colors.exchangeGreen.color
        }
    }
}
