//
//  CurrencyEnum.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import Foundation

private typealias Localized = Localization.ExchangeScreen.Currency

enum CurrencyEnum: TitleEnumProtocol {
   
    case americanDollar
    case euro
    case japaneseYen
    
    var title: String {
        switch self {
        case .americanDollar:
            return Localized.usd
        case .euro:
            return Localized.eur
        case .japaneseYen:
            return Localized.jpy
        }
    }
    
}
