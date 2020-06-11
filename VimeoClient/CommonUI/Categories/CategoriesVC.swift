//
//  CategoriesVC.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/11/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking

protocol CategorySelectionDelegate {
    func didSelect(category: VIMCategory)
}

protocol CategoriesVCInterface: UIViewController {
    init()
    func didSelect(category: VIMCategory)
    func update(for categories: [VIMCategory])
    var selectionDelegate: CategorySelectionDelegate? { get set }
}

class CategoriesVC<Cell: ConfigurableCategoryCell>: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet private weak var tableView: UITableView!
    private var categories: [VIMCategory] = []
    
    var selectionDelegate: CategorySelectionDelegate?
    
    required init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(cellClass: Cell.self)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    //MARK: - UITableViewDelegate.
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = categories[indexPath.row]
        didSelect(category: model)
        
    }
    //MARK: - UITableViewDataSource.
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: Cell.self)
        cell.config(category: categories[indexPath.row])
        return cell
    }
}


extension CategoriesVC: CategoriesVCInterface {
    func didSelect(category: VIMCategory) {
        selectionDelegate?.didSelect(category: category)
    }
    
    func update(for categories: [VIMCategory]) {
        self.categories = categories
        tableView.reloadData()
        
        guard let firstCat = categories.first else { return }
        tableView.selectRow(at: IndexPath(row: 0, section: 0),
                            animated: true,
                            scrollPosition: .none)
        didSelect(category: firstCat)
    }

}
