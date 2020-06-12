//
//  SearchController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

protocol SearchControllerInterface {
    func startSearch(key: String)
}

class SearchController
    <
    CollectionView: VideosCollectionViewController<VIMVideo, VideoCollectionCell>
    >: UIViewController, UISearchResultsUpdating {
    
    
    @IBOutlet private weak var collectionContainerView: UIView!
    
    private let searchMdoel = VideoSearchModel()
    private let collecctionVC: CollectionView = CollectionView()
    private var lastSearchKey = ""
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collecctionVC.delegate = self
        addChildViewControllerWithView(collecctionVC,
                                        toView: collectionContainerView)
    }
    
    func startSearchIfNeed(searchKey: String?) {
        guard let text = searchKey,
            text.count > 2,
            lastSearchKey != text else { return }
        lastSearchKey = text
        startSearch(key: text)
    }
    
    // Search Controller result
    func updateSearchResults(for searchController: UISearchController) {
        startSearchIfNeed(searchKey: searchController.searchBar.text)
    }
}

extension SearchController: SearchControllerInterface {
    func startSearch(key: String) {
        collecctionVC.update(for: [])
        searchMdoel.getVideos(with: key) { [weak self] (result) in
            switch result {
            case .success(let videos):
                self?.collecctionVC.update(for: videos)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

extension SearchController: VideoSelectionDelegate, VideoDetailsRoute {
    func didSelect(video: VIMVideo) {
        openVideo(video: video)
    }
}
