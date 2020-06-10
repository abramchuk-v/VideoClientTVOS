//
//  TableViewGenericCellsExtension.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/5/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
public extension UIViewController {
    static var identifier: String {
        let name = String(describing: self)
        if let className = name.split(separator: "<").first {
            return String(className)
        }
        return String(describing: self)
    }
}

public extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func fixInView(_ container: UIView!) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.frame = container.frame
        container.addSubview(self)
        
        topAnchor.constraint(equalTo: container.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: container.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: container.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: container.trailingAnchor).isActive = true
    }
    
}

public extension UITableView {

    func register<T: UITableViewCell>(cellClass: T.Type) {
        register(UINib(nibName: cellClass.identifier, bundle: nil),
        forCellReuseIdentifier: cellClass.identifier)
    }

    func dequeue<T: UITableViewCell>(cellClass: T.Type) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.identifier) as? T else {
                fatalError(
                    "Error: cell with id: \(cellClass.identifier) is not \(T.self)")
        }
        return cell
    }

    func dequeue<T: UITableViewCell>(cellClass: T.Type, forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: cellClass.identifier, for: indexPath) as? T else {
                fatalError(
                    "Error: cell with id: \(cellClass.identifier) for indexPath: \(indexPath) is not \(T.self)")
        }
        return cell
    }

}

extension UICollectionView {
    func registerClass<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) {
        register(T.self, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.identifier)
    }

    func registerNib<T: UICollectionReusableView>(_: T.Type, forSupplementaryViewOfKind kind: String) {
        register(UINib(nibName: T.identifier, bundle: nil),
                 forSupplementaryViewOfKind: kind,
                 withReuseIdentifier: T.identifier)
    }

    func register<T: UICollectionViewCell>(_: T.Type) {
        let bundle = Bundle(for: T.self)
        let nib = UINib(nibName: T.identifier, bundle: bundle)
        register(nib, forCellWithReuseIdentifier: T.identifier)
    }

    func dequeueReusableCell<T: UICollectionViewCell>(cellClass: T.Type, for indexPath: IndexPath) -> T {
//        register(T.self)
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue cell with identifier: \(T.identifier)")
        }
        return cell
    }

    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(ofKind kind: String, for indexPath: IndexPath) -> T {
//        register(T.self, forSupplementaryViewOfKind: kind)
        guard let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: T.identifier, for: indexPath) as? T else {
            fatalError("Could not dequeue reusable supplementaryView with identifier: \(T.identifier)")
        }
        return cell
    }
}
