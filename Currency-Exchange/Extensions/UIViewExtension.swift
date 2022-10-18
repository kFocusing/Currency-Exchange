//
//  UIViewExtension.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
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
        layer.cornerRadius = self.bounds.width.halfDevide
    }
    
    func translateAnimate(with duration: TimeInterval = 0.65,
                          delay: TimeInterval = .zero,
                          usingSpringWithDamping dampingRatio: CGFloat = 1,
                          initialSpringVelocity velocity: CGFloat = 1,
                          options: UIView.AnimationOptions = [.curveEaseIn],
                          translateByX: CGFloat = 0,
                          translateByY: CGFloat = 0,
                          completion: BoolBlock? = nil) {
        UIView.animate(withDuration: duration,
                       delay: delay,
                       usingSpringWithDamping: dampingRatio,
                       initialSpringVelocity: velocity,
                       options: options,
                       animations: {
            self.transform = self.transform.translatedBy(x: translateByX, y: translateByY)
        },
                       completion: completion)
    }
    
}
