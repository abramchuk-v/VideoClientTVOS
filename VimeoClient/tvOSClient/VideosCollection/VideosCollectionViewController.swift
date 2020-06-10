//
//  VideosCollectionViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

protocol VideoSelectDelegate {
    func didSelect(video: VIMVideo)
}

protocol VideoCollectionInterface {
    func update(for videos: [VIMVideo])
    func didSelect(video: VIMVideo)
}

class VideosCollectionViewController: UIViewController {

    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var videos: [VIMVideo] = []
    var delegate: VideoSelectDelegate?
    
    init() {
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(VideoCollectionCell.self)
    }
}

extension VideosCollectionViewController: VideoCollectionInterface {
    func update(for videos: [VIMVideo]) {
        self.videos = videos
        collectionView.reloadData()
    }
    
    func didSelect(video: VIMVideo) {
        delegate?.didSelect(video: video)
    }
}

extension VideosCollectionViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let video = videos[indexPath.row]
        didSelect(video: video)
    }
}

extension VideosCollectionViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        videos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(cellClass: VideoCollectionCell.self, for: indexPath)
        cell.config(for: videos[indexPath.row])
        return cell

    }
}



