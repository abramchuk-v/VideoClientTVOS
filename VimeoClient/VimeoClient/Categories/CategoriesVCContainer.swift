//
//  CategoriesVCContainer.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/13/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMCategory

class CategoriesVCContainer<
    CategoryItem: Hashable,
    Cell: ConfigurableCategoryCell<CategoryItem>,
    CategoryVC: CategoriesVC<CategoryItem, Cell>
    >: UIViewController {
    
    @IBOutlet private weak var categoryContainerView: UIView!
    private let categoryVC = CategoryVC()
    private let dataModel = CategoriesModel<CategoryItem>()
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        categoryVC.setSelectionAction { [weak self] in self?.didSelect(item: $0)}
        addChildViewControllerWithView(categoryVC,
                                       toView: categoryContainerView)
        
        dataModel.getCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.categoryVC.update(for: categories)
            case .failure(let err):
                self?.handle(error: err)
            }
        }
        
    }
}

extension CategoriesVCContainer: VideoDetailsRoute {
    private func didSelect(item: CategoryItem) {
        guard let category = item as? VIMCategory else { return }
        openVideosCollection(for: category)
    }
    
    private func handle(error: AppError) {
        print(error.localizedDescription)
    }
}
