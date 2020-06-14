//
//  VideoCollectionContainer.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/14/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMCategory

class VideoCollectionContainer
    <
    CategoryItem: Hashable,
    VideoItem: Hashable,
    VideoCell: ConfigurableVideoCell<VideoItem>,
    VideoVC: VideosCollectionViewController<VideoItem, VideoCell>
    >: UIViewController {
    
    @IBOutlet private weak var videoCollectionContainer: UIView!
    private let dataModel = VideoModel<VideoItem>()
    private let videoVC = VideoVC()
    private let category: CategoryItem
    
    init(category: CategoryItem) {
        self.category = category
        super.init(nibName: Self.identifier, bundle: nil)
        self.title = "Videos"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        videoVC.setSelectionAction { [weak self] in self?.didSelect(item: $0) }
        addChildViewControllerWithView(videoVC, toView: videoCollectionContainer)
        
        guard let cthr = category as? VIMCategory else { return}
        dataModel.videos(for: cthr) { [weak self] (result) in
            switch result {
            case .failure(let err):
                self?.handle(error: err)
            case .success(let videos):
                self?.videoVC.update(for: videos)
            }
        }
    }
}

extension VideoCollectionContainer: VideoDetailsRoute {
    private func didSelect(item: VideoItem) {
        guard let video = item as? VIMVideo else { return }
        openVideo(video)
    }
    
    private func handle(error: AppError) {
        print(error.localizedDescription)
    }
}
