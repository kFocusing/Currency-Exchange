//
//  CellReusableExtension.swift
//  Currency-Exchange
//
//  Created by Danylo Klymov on 11.10.2022.
//

import UIKit

protocol Reusable { }

extension Reusable {
    static var reuseIdentifier: String {
        String(describing: Self.self)
    }
}

protocol CollectionCellRegistable: UICollectionViewCell, Reusable { }

protocol CollectionCellDequeueReusable: UICollectionViewCell, Reusable { }

extension CollectionCellRegistable {
    static func register(in collectionView: UICollectionView) {
        collectionView.register(Self.self,
                                forCellWithReuseIdentifier: String(describing: self))
    }
    
    static func registerXIB(in collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: String(describing: self), bundle: nil),
                                forCellWithReuseIdentifier: String(describing: self))
    }
}

extension CollectionCellDequeueReusable {
    static func dequeueCellWithType(in collectionView: UICollectionView, indexPath: IndexPath) -> Self {
        return collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: Self.self),
                                                  for: indexPath) as! Self
    }
}
