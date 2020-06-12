//
//  CategoriesVC.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/11/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMCategory

protocol CategorySelectionDelegate {
    func didSelect(category: VIMCategory)
}

class CategoriesVC
    <
    Item: Hashable,
    Cell: ConfigurableCell<Item>
    >: UIViewController, UITableViewDelegate {
    
    enum Section {
        case main
    }
    
    @IBOutlet private weak var tableView: UITableView!
    
    private var categories: [Item] = []
    private var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    var selectionDelegate: CategorySelectionDelegate?
    
    required init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configTable()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = dataSource.itemIdentifier(for: indexPath) else { return }
        didSelect(category: category)
        
    }
}


extension CategoriesVC {
    typealias ItemCategory = Item
    func didSelect(category: Item) {
        #warning("don't forget")
        selectionDelegate?.didSelect(category: category as! VIMCategory)
    }

    func update(for categories: [Item]) {
        self.categories = categories
        updateUI()

        guard let firstCat = categories.first else { return }
        tableView.selectRow(at: IndexPath(row: 0, section: 0),
                            animated: true,
                            scrollPosition: .none)
        didSelect(category: firstCat)
    }

}

private extension CategoriesVC {
    func configTable() {
        tableView.register(cellClass: Cell.self)
        tableView.delegate = self
        
        dataSource = UITableViewDiffableDataSource
            <Section, Item>(tableView: tableView)
            { (table, index, item) -> UITableViewCell? in
                let cell = table.dequeue(cellClass: Cell.self, forIndexPath: index)
                cell.config(category: item)
                return cell
        }
        
        updateUI(animated: false)
    }
    
    func currentSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(categories)
        return snapshot
    }
    
    func updateUI(animated: Bool = true) {
        let snapshot = currentSnapShot()
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}
