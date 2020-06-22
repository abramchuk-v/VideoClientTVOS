//
//  CategoriesVC.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/11/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class CategoriesVC
    <
    Item: Hashable,
    Cell: ConfigurableCategoryCell<Item>
    >: UIViewController, UITableViewDelegate {
    
    enum Section {
        case main
    }
    
    @IBOutlet private(set) weak var tableView: UITableView!
    
    private var categories: [Item] = []
    private var dataSource: UITableViewDiffableDataSource<Section, Item>! = nil
    
    
    private var selectionAction: ((Item) -> Void)?
    
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
    
    func setSelectionAction(handler: @escaping (Item) -> Void) {
        selectionAction = handler
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let category = dataSource.itemIdentifier(for: indexPath) else { return }
        didSelect(category: category)
    }
    
    func indexPathForPreferredFocusedView(in tableView: UITableView) -> IndexPath? {
        return IndexPath(row: 0, section: 0)
    }
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        return [tableView]
    }
}


extension CategoriesVC {
    func didSelect(category: Item) {
        guard let action = selectionAction else { return }
        action(category)
    }

    func update(for categories: [Item]) {
        self.categories = categories
        updateUI()
    }

}

private extension CategoriesVC {
    func configTable() {
        tableView.remembersLastFocusedIndexPath = true
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
