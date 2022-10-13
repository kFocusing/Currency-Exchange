//
//  CurrencyEnum.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import Foundation

private typealias Localized = Localization.ExchangeScreen.Currency

enum CurrencyEnum: TitleEnumProtocol, CaseIterable {
   
    static func == (lhs: CurrencyEnum, rhs: String) -> Bool {
        return lhs.title == rhs
    }
    
    case euro
    case americanDollar
    case japaneseYen
    
    var title: String {
        switch self {
        case .euro:
            return Localized.eur
        case .americanDollar:
            return Localized.usd
        case .japaneseYen:
            return Localized.jpy
        }
    }
    
}
