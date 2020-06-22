//
//  CategoriesViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking

class CategoriesTabContainer<
    VideoItem: Hashable,
    VideoCell: ConfigurableVideoCell<VideoItem>,
    VideoVC: VideosCollectionViewController<VideoItem, VideoCell>,
    CategoryItem: Hashable,
    CategoryCell: ConfigurableCategoryCell<CategoryItem>,
    CategoryVC: CategoriesVC<CategoryItem, CategoryCell>
    >: UIViewController {
    
    @IBOutlet private weak var containerForVideo: UIView!
    @IBOutlet private weak var containerForTable: UIView!
    
    private var categories: [CategoryItem] = []
    private let categoryDataModel = CategoriesModel<CategoryItem>()
    private let videoDataModel = VideoModel<VideoItem>()
    
    private let tableVC = CategoryVC()
    private let collecctionVC = VideoVC()
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
        tabBarItem.title = "Categories".uppercased()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collecctionVC.setSelectionAction { [weak self] in self?.didSelect($0) }
        tableVC.setSelectionAction { [weak self] in self?.didSelect(category: $0) }
        
        addChildViewControllerWithView(collecctionVC, toView: containerForVideo)
        addChildViewControllerWithView(tableVC, toView: containerForTable)
        
        tabBarObservedScrollView = collecctionVC.collectionView
        
        categoryDataModel.getCategories { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .success(let categories):
                strongSelf.tableVC.update(for: categories)
                strongSelf.tableVC.didSelect(category: categories.first!)
            
                (strongSelf.tabBarController as? VimeoTabController)?
                    .changeFocus(to: strongSelf.containerForVideo)
            case .failure(let err):
                strongSelf.handle(error: err)
            }
        }
    }
}

//MARK: - Category selection.
extension CategoriesTabContainer {
    func didSelect(category: CategoryItem) {
        guard let cthr = category as? VIMCategory else { return}
        
        collecctionVC.update(for: [])
        videoDataModel.videos(for: cthr) { [weak self] (result) in
            guard let strongSelf = self else { return }
            switch result {
            case .failure(let err):
                strongSelf.handle(error: err)
            case .success(let videos):
                strongSelf.collecctionVC.update(for: videos)
            }
        }
    }
    
    func handle(error: AppError) {
        print(error.localizedDescription)
    }
}

//MARK: - Video selection and routing.
extension CategoriesTabContainer: VideoDetailsRoute {
    func didSelect(_ item: VideoItem) {
        guard let video = item as? VIMVideo else { return }
        openVideo(video)
    }
}


