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
    private var focusView: UIView?
    func changeFocus(to view: UIView) {
        focusView = view
        setNeedsFocusUpdate()
        updateFocusIfNeeded()
        focusView = nil
    }
    
    #if os(tvOS)
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
    #endif
    
    override var preferredFocusEnvironments: [UIFocusEnvironment] {
        if let fcsView = focusView {
            return [fcsView]
        }
        return super.preferredFocusEnvironments
    }
    
    #if os(iOS)
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let vc =
            CategoriesVCContainer
            <
                VIMCategory,
                CategoryCell,
                CategoriesVC
            >()
        
        
        let navVC = UINavigationController(rootViewController: vc)
        navVC.tabBarItem.title = "Categories".uppercased()
        vc.navigationItem.title = "Categories".uppercased()
        
        let searchResultsViewController = UIViewController()
        
//        let searchController = UISearchController(searchResultsController: searchResultsViewController)
//        searchController.searchResultsUpdater = searchResultsViewController as! UISearchResultsUpdating
//        searchController.hidesNavigationBarDuringPresentation = true

//        let searchContainerViewController = UISearchContainerViewController(searchController: searchController)
//        searchContainerViewController.tabBarItem = UITabBarItem(title: "Search",
//                                                                image: UIImage(named: "searchIcon"),
//                                                                tag: 0)
        searchResultsViewController.tabBarItem = UITabBarItem(title: "Search",
                                                              image: UIImage(named: "searchIcon"),
                                                              tag: 0)
        
        viewControllers = [navVC, searchResultsViewController]
    }
    
    #endif
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
