//
//  Image.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol Image: CaseIterable {
    static var allImages: [UIImage?] { get }
    var icon: UIImage? { get }
}

extension Image {
    static var allImages: [UIImage?] {
        allCases.map { return $0.icon ?? nil }
    }
}
