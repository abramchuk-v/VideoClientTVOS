//
//  VideoInfoController.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/14/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

class VideoInfoController: UIViewController, VideoInfoInterface {
    
    @IBOutlet private weak var videoBackGroundImageView: UIImageView!
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var videoDescriptionLabel: UILabel!
    @IBOutlet private weak var scrollView: UIScrollView!
    
    private let video: VIMVideo
    
    required init(video: VIMVideo) {
        self.video = video
        super.init(nibName: Self.identifier, bundle: nil)
        self.title = video.name ?? ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        let imageWidth = Float(videoImageView.frame.size.width)
        let pictuerColletion = video.pictureCollection
        let link = pictuerColletion?.picture(forWidth: imageWidth)?.link
        videoImageView.imageWith(link: link)
        videoBackGroundImageView.imageWith(link: link)
        
        videoNameLabel.text = video.name
        videoDescriptionLabel.text = video.videoDescription
        authorNameLabel.text = video.user?.name
        likesCountLabel.text = video.likesCount().roundedWithAbbreviations
        commentsCountLabel.text = video.commentsCount().roundedWithAbbreviations
    }

    func play() {
        
    }
    
    func defaultPlay() {
        
    }

}

extension VideoInfoController: UIScrollViewDelegate {
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
}
