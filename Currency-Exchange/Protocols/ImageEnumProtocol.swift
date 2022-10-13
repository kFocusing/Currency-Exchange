//
//  ImageEnumProtocol.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol ImageEnumProtocol: CaseIterable {
    static var allImages: [UIImage?] { get }
    var icon: UIImage? { get }
}

extension ImageEnumProtocol {
    static var allImages: [UIImage?] {
        allCases.map { return $0.icon ?? nil }
    }
}
