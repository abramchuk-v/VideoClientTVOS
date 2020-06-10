//
//  CategoriesViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking

protocol CategoriesVCInterface {
    func didSelect(category: VIMCategory)
    func update(for categories: [VIMCategory])
    func handle(error: AppError)
}

class CategoriesViewController<CollectionView: VideoCollectionInterface>: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var containerForVideo: UIView!
    
    private var categories: [VIMCategory] = []
    private let viewModel = CategoriesViewModel()
    private let collecctionVC: CollectionView = CollectionView()
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
        tabBarItem.title = "Categories".uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(cellClass: CategoryCell.self)
        tableView.delegate = self
        tableView.dataSource = self
        
        collecctionVC.delegate = self
        addChildViewControllerWithView(collecctionVC, toView: containerForVideo)
        
        viewModel.getCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.update(for: categories)
            case .failure(let err):
                self?.handle(error: err)
            }
        }
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
        let cell = tableView.dequeue(cellClass: CategoryCell.self)
        cell.config(category: categories[indexPath.row])
        return cell
    }
    
    
}

//MARK: - Main interface.
extension CategoriesViewController: CategoriesVCInterface {
    func didSelect(category: VIMCategory) {
        viewModel.video(for: category) { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.handle(error: err)
            case .success(let videos):
                self?.collecctionVC.update(for: videos)
            }
        }
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
    
    func handle(error: AppError) {
        print(error.localizedDescription)
    }
}

//MARK: - VideoSelectDelegate, Collection delegate.
extension CategoriesViewController: VideoSelectDelegate, VideoDetailsRoute {
    func didSelect(video: VIMVideo) {
        openVideo(video: video)
    }
}


