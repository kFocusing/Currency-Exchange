//
//  CellReusableExtension.swift
//  Currency-Exchange
//
//  Created on 11.10.2022.
//

import UIKit

protocol ReuseIdentifier { }

protocol CollectionCellRegistable: UICollectionViewCell, ReuseIdentifier { }

protocol CollectionCellDequeueReusable: UICollectionViewCell, ReuseIdentifier { }

extension ReuseIdentifier {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

extension CollectionCellRegistable {
    static func register(in collectionView: UICollectionView) {
        collectionView.register(Self.self,
                                forCellWithReuseIdentifier: self.reuseIdentifier)
    }
    
    static func registerXIB(in collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: self.reuseIdentifier, bundle: nil),
                                forCellWithReuseIdentifier: self.reuseIdentifier)
    }
}

extension CollectionCellDequeueReusable {
    static func dequeueCellWithType(in collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: self.reuseIdentifier, for: indexPath) as! Self
    }
}
