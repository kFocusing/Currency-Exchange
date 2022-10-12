//
//  ExchangeModel.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import UIKit

struct ExchangeModel: Hashable {
    var dealType: DealTypeEnum
    var amountCurrency: AmountCurrency
    
    init(from amountCurrency: AmountCurrency,
         and dealType: DealTypeEnum) {
        self.dealType = dealType
        self.amountCurrency = amountCurrency
    }
}
