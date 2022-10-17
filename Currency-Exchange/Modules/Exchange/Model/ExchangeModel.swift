//
//  ExchangeModel.swift
//  Currency-Exchange
//
//  Created on 12.10.2022.
//

import UIKit

final class ExchangeModel: Hashable {
    
    let uuid = UUID()

    var dealType: DealType
    var amountCurrency: AmountCurrency
    
    init(from amountCurrency: AmountCurrency,
         and dealType: DealType) {
        self.dealType = dealType
        self.amountCurrency = amountCurrency
    }
    
    func update(from exchangeModel: ExchangeModel) {
        self.dealType = exchangeModel.dealType
        self.amountCurrency = exchangeModel.amountCurrency
    }
}

extension ExchangeModel {
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: ExchangeModel, rhs: ExchangeModel) -> Bool {
        lhs.uuid == rhs.uuid
    }
}
