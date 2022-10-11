//
//  UIViewExtension.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

extension UIView {
    
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.masksToBounds = true
            layer.borderWidth = newValue
        }
    }
    
    var borderColor: CGColor {
        get {
            return layer.borderColor ?? UIColor.clear.cgColor
        }
        set {
            layer.masksToBounds = true
            layer.borderColor = newValue
        }
    }
    
    func addDropShadow(offset: CGSize = CGSize(width: 0, height: 3),
                       color: UIColor = Colors.exchangeGray.color,
                       radius: CGFloat = 1,
                       opacity: Float = 1) {
        layer.masksToBounds = false
        layer.shadowOffset = offset
        layer.shadowColor = color.cgColor
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        
        let backgroundCGColor = backgroundColor?.cgColor
        backgroundColor = nil
        layer.backgroundColor = backgroundCGColor
    }

    func makeCornersRounded() {
        layer.cornerRadius = self.bounds.width / 2
    }
    
}
