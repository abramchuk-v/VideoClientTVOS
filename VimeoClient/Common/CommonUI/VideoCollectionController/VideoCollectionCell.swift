//
//  VideoCollectionCell.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

class VideoCollectionCell: ConfigurableVideoCell<VIMVideo> {
    @IBOutlet private weak var videoThumbnail: UIImageView!
    @IBOutlet private weak var videoLabel: UILabel!
    @IBOutlet private weak var spinnerView: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.clipsToBounds = true
        
        videoThumbnail.layer.cornerRadius = 10.0
        videoThumbnail.clipsToBounds = true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            if self.isFocused {
                self.contentView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            } else {
                self.contentView.transform = .identity
            }
        }, completion: nil)
    }
    
    override func config(for video: VIMVideo) {
        let imageObject = video.pictureCollection?.picture(forWidth: Float(videoThumbnail.frame.size.width))
        videoThumbnail.imageWith(link: imageObject?.link)
        videoLabel.text = video.name
    }
}
