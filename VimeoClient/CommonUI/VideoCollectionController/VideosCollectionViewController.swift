//
//  VideosCollectionViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

protocol VideoSelectionDelegate {
    func didSelect(video: VIMVideo)
}



class VideosCollectionViewController
    <
    Item: Hashable,
    Cell: ConfigurableVideoCell<Item>
    >: UIViewController, UICollectionViewDelegate {

    enum Section {
        case main
    }
    
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var videos: [Item] = []
    private var dataSource: UICollectionViewDiffableDataSource<Section, Item>! = nil
    var delegate: VideoSelectionDelegate?
    
    required init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configCollection()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let video = dataSource.itemIdentifier(for: indexPath) else { return }
        didSelect(video: video)
    }
}

private extension VideosCollectionViewController {
    func configCollection() {
        collectionView.delegate = self
        collectionView.register(cellClass: Cell.self)
        
        dataSource = UICollectionViewDiffableDataSource
            <Section, Item>(collectionView: collectionView)
            { (collection, index, item) -> UICollectionViewCell? in
                let cell = collection.dequeueReusableCell(cellClass: Cell.self, for: index)
                cell.config(for: item)
                return cell
        }
        
        updateUI(animated: false)
    }
    
    func currentSnapShot() -> NSDiffableDataSourceSnapshot<Section, Item> {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item>()
        snapshot.appendSections([.main])
        snapshot.appendItems(videos)
        return snapshot
    }
    
    func updateUI(animated: Bool = true) {
        let snapshot = currentSnapShot()
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension VideosCollectionViewController {
    func update(for videos: [Item]) {
        self.videos = videos
        updateUI()
    }
    
    func didSelect(video: Item) {
        #warning("don't forget")
        delegate?.didSelect(video: video as! VIMVideo)
    }
}
