//
//  Route.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

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
    func openVideo(video: VIMVideo, completion: (() -> Void)?)
}


extension VideoDetailsRoute where Self: UIViewController {
    func openVideo(video: VIMVideo, completion: (() -> Void)? = nil) {
        #if os(tvOS)
        let vc = VideoInfoViewController(video: video)
        push(viewController: vc, completion: completion)
        #endif
    }
}


