//
//  VimeoTabbarVC.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
class VimeoTabController: UITabBarController {
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        let vc = CategoriesViewController()
        
        let vc2 = UIViewController()
        vc2.tabBarItem.image = UIImage(named: "searchImage")
        
        viewControllers = [vc, vc2]
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
