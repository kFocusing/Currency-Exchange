//
//  ExchangeModel.swift
//  Currency-Exchange
//
//  Created on 12.10.2022.
//

import UIKit

struct ExchangeModel: Hashable {
    var dealType: DealType
    var amountCurrency: AmountCurrency
    
    init(from amountCurrency: AmountCurrency,
         and dealType: DealType) {
        self.dealType = dealType
        self.amountCurrency = amountCurrency
    }
}
