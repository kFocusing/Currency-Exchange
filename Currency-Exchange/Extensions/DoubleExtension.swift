//
//  DoubleExtension.swift
//  Currency-Exchange
//
//  Created on 18.10.2022.
//

import Foundation

extension Double {
    var inMoneyFormat: String {
        return String(format: "%0.2f",
                      arguments: [self])
    }
}


