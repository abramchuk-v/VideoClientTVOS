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
//        collecctionVC.set
        tableVC.setSelectionAction { [weak self] in self?.didSelect(category: $0) }
        
        addChildViewControllerWithView(collecctionVC, toView: containerForVideo)
        addChildViewControllerWithView(tableVC, toView: containerForTable)
        
        categoryDataModel.getCategories { [weak self] (result) in
            switch result {
            case .success(let categories):
                self?.tableVC.update(for: categories)
                self?.tableVC.didSelect(category: categories.first!)
            case .failure(let err):
                self?.handle(error: err)
            }
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        super.shouldUpdateFocus(in: context)
        if context.nextFocusedView!.isDescendant(of: tabBarController!.tabBar) {
            tabBarController?.setTabBarVisible(visible: true, duration: 0.1)
        } else {
            tabBarController?.setTabBarVisible(visible: false, duration: 0.1)
        }
        return true
    }
}

//MARK: - Category selection.
extension CategoriesTabContainer {
    func didSelect(category: CategoryItem) {
        guard let cthr = category as? VIMCategory else { return}
        
        collecctionVC.update(for: [])
        videoDataModel.videos(for: cthr) { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.handle(error: err)
            case .success(let videos):
                self?.collecctionVC.update(for: videos)
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


