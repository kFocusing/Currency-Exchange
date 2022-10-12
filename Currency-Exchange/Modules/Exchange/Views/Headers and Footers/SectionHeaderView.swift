//
//  SectionHeaderView.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 12.10.2022.
//

import UIKit

final class SectionHeaderView: UICollectionReusableView, Reusable {

    // MARK: IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    // MARK: Static
    static func loadViewFromNib() -> UIView {
        return UINib(nibName: String(describing: self),
                     bundle: nil).instantiate(withOwner: nil,
                                              options: nil)[0] as! UIView
    }
   
    // MARK: Internal
    func configure(with text: String) {
        titleLabel.text = text
    }
}

