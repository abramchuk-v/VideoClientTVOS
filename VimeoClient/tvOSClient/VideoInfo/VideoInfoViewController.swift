//
//  VideoInfoViewController.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

class VideoInfoViewController: UIViewController, VideoInfoInterface {
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionTextView: UITextView!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var viewsCountLabel: UILabel!
    @IBOutlet private weak var likesCountLabel: UILabel!
    @IBOutlet private weak var commentsCountLabel: UILabel!
    @IBOutlet private weak var visualEffectView: UIVisualEffectView!
    @IBOutlet private weak var viewsCountStack: UIStackView!
    
    private let video: VIMVideo
    
    required init(video: VIMVideo) {
        self.video = video
        super.init(nibName: Self.identifier, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionTextView.panGestureRecognizer.allowedTouchTypes = [NSNumber(value: UITouch.TouchType.indirect.rawValue)]
        descriptionTextView.isUserInteractionEnabled = true;
        visualEffectView.layer.cornerRadius = 15.0
        visualEffectView.clipsToBounds = true
        
        let imageWidth = Float(videoImageView.frame.size.width)
        let pictuerColletion = video.pictureCollection
        let link = pictuerColletion?.picture(forWidth: imageWidth)?.link
        videoImageView.imageWith(link: link)
        
        titleLabel.text = video.name
        descriptionTextView.text = video.videoDescription
        authorLabel.text = video.user?.name
        likesCountLabel.text = video.likesCount().roundedWithAbbreviations
        commentsCountLabel.text = video.commentsCount().roundedWithAbbreviations
        
        if let viewsCount = video.numPlays?.stringValue {
            viewsCountLabel.text = viewsCount
        } else {
            viewsCountStack.isHidden = true
        }
    }
    
    @IBAction func playAction(_ sender: Any) {
        play()
    }
    
    @IBAction func defaultPlayAction(_ sender: Any) {
        defaultPlay()
    }
    
    func play() {
        
    }
    
    func defaultPlay() {
        
    }
}
