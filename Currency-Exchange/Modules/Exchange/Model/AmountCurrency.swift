//
//  AmountCurrency.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import Foundation

struct AmountCurrency: Codable, Hashable {
    var amount: Double
    var currency: String
}

extension AmountCurrency {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let amountString = try container.decode(String.self, forKey: .amount)
        amount = Double(amountString) ?? 0
        currency = try container.decode(String.self, forKey: .currency)
    }
}
