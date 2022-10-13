//
//  CGFloatExtension.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

extension CGFloat {
    
    static var screenWidth: CGFloat {
        return UIScreen.main.bounds.width
    }
    
    static var screenHeight: CGFloat {
        return UIScreen.main.bounds.height
    }
    
    static var safeAreaInsetTop: CGFloat {
        return UIApplication.shared.windows.first{$0.isKeyWindow }?.safeAreaInsets.top ?? 0
    }
    
    var halfDevide: CGFloat {
        get {
            return self / 2
        }
    }
    
}
