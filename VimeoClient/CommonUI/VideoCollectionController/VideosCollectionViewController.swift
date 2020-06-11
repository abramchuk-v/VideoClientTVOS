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

protocol VideoCollectionInterface: UIViewController {
    init()
    func update(for videos: [VIMVideo])
    func didSelect(video: VIMVideo)
    var delegate: VideoSelectionDelegate? { get set }
}

extension VideoCollectionInterface {
    func didSelect(video: VIMVideo) {
        delegate?.didSelect(video: video)
    }
}

class VideosCollectionViewController<Cell: ConfigurableVideoCell>: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var videos: [VIMVideo] = []
    var delegate: VideoSelectionDelegate?
    
    required init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(cellClass: Cell.self)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        didSelect(video: video)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellClass: Cell.self, for: indexPath)
        cell.config(for: videos[indexPath.row])
        return cell

    }
}

extension VideosCollectionViewController: VideoCollectionInterface {
    func update(for videos: [VIMVideo]) {
        self.videos = videos
        collectionView.reloadData()
    }
}



