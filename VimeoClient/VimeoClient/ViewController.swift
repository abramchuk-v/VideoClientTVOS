//
//  ViewController.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/5/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking

class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    private var categories: [VIMCategory] = []
    private let viewModel = CategoriesViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(cellClass: CategoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
        viewModel.getCategories { (result) in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.tableView.reloadData()
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }


}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeue(cellClass: CategoryCell.self)
        cell.config(category: categories[indexPath.row])
        return cell
    }
}

