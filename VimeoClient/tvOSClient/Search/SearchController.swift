//
//  SearchController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

class SearchController
    <
    SearchItem: Hashable,
    SearchCell: ConfigurableVideoCell<SearchItem>,
    CollectionVC:VideosCollectionViewController<SearchItem, SearchCell>
    >: UIViewController, UISearchResultsUpdating {
    
    
    @IBOutlet private weak var collectionContainerView: UIView!
    
    private let searchMdoel = VideoSearchModel<SearchItem>()
    private let collectionVC = CollectionVC()
    private var lastSearchKey = ""
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionVC.setSelectionAction { [weak self] in self?.didSelect($0) }
        addChildViewControllerWithView(collectionVC,
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

extension SearchController {
    func startSearch(key: String) {
        collectionVC.update(for: [])
        searchMdoel.getVideos(with: key) { [weak self] (result) in
            switch result {
            case .success(let videos):
                self?.collectionVC.update(for: videos)
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    }
}

//MARK: - Item selection
extension SearchController: VideoDetailsRoute {
    func didSelect(_ item: SearchItem) {
        guard let video = item as? VIMVideo else { return }
        openVideo(video: video)
    }
}
