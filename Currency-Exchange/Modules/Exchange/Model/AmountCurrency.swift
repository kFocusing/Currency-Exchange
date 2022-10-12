//
//  AmountCurrency.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import Foundation

struct AmountCurrency: Codable, Hashable {
    let amount, currency: String
}
