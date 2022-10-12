//
//  CAGradientLayerExtension.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import UIKit

extension CAGradientLayer {
    static func gradientLayer(for beginColor: UIColor = Colors.exchangeBlue.color,
                              and endColor: UIColor =  Colors.exchangeLightBlue.color,
                              in frame: CGRect) -> Self {
        let layer = Self()
        layer.colors = [beginColor.cgColor, endColor.cgColor]
        layer.startPoint = CGPoint(x: 0, y: 1)
        layer.endPoint = CGPoint(x: 1, y: 1)
        layer.frame = frame
        return layer
    }
}
