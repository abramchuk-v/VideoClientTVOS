//
//  Route.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking

protocol Route {
    func push(viewController: UIViewController, completion: (() -> Void)?)
}


extension Route where Self: UIViewController {
    #if os(tvOS)
    func push(viewController: UIViewController, completion: (() -> Void)? = nil) {
        present(viewController, animated: true) {
            guard let compl = completion else { return }
            compl()
        }
    }
    #elseif os(iOS)
    func push(viewController: UIViewController, completion: (() -> Void)?) {
        if let navVC = self.navigationController {
            navVC.pushViewController(viewController,
                                     animated: true)
        }
    }
    #endif
}

protocol VideoDetailsRoute: Route {
    func openVideo(_ video: VIMVideo, completion: (() -> Void)?)
    func openVideosCollection(for category: VIMCategory)
}


extension VideoDetailsRoute where Self: UIViewController {
    func openVideo(_ video: VIMVideo, completion: (() -> Void)? = nil) {
        let vc: VideoInfoInterface
        #if os(tvOS)
        vc = VideoInfoViewController(video: video)
        #elseif os(iOS)
        vc = VideoInfoController(video: video)
        #endif
        
        push(viewController: vc, completion: completion)
    }
    
    
    func openVideosCollection(for category: VIMCategory) {
        #if os(iOS)
        let vc =
            VideoCollectionContainer
            <
                VIMCategory,
                VIMVideo,
                VideoCollectionSmallCell,
                VideosCollectionViewController
            >(category: category)
        push(viewController: vc, completion: nil)
        #endif
    }
}


