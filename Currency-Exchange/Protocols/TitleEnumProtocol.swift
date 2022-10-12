//
//  TitleEnumProtocol.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

protocol TitleEnumProtocol: CaseIterable {
    static var allTitles: [String] { get }
    var title: String { get }
}

extension TitleEnumProtocol {
    static var allTitles: [String] {
        allCases.map { return $0.title }
    }
}

