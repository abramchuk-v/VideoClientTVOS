//
//  VimeoTabbarVC.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking
class VimeoTabController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let vc =
            CategoriesTabContainer
            <
                VIMVideo,
                VideoCollectionCell,
                VideosCollectionViewController,
                VIMCategory,
                CategoryCell,
                CategoriesVC
            >()
        
        let searchResultsViewController = SearchController
            <
                VIMVideo,
                VideoCollectionCell,
                VideosCollectionViewController
            >()
        
        let searchController = UISearchController(searchResultsController: searchResultsViewController)
        searchController.searchResultsUpdater = searchResultsViewController
        searchController.hidesNavigationBarDuringPresentation = true

        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
        searchContainerViewController.tabBarItem = UITabBarItem(title: "Search",
                                                                image: UIImage(named: "searchIcon"),
                                                                tag: 0)
        
        viewControllers = [vc, searchContainerViewController]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
