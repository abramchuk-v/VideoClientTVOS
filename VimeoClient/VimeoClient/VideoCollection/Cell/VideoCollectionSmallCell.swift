//
//  VideoCollectionSmallCell.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/14/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

class VideoCollectionSmallCell: ConfigurableVideoCell<VIMVideo> {
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var videoNameLabel: UILabel!
    @IBOutlet private weak var videoAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 5.0
        contentView.backgroundColor = UIColor(displayP3Red: 251/255,
                                              green: 251/255,
                                              blue: 244/255,
                                              alpha: 1.0)
        
        videoImageView.layer.cornerRadius = 5.0
        videoImageView.clipsToBounds = true
    }
    
    override var isSelected: Bool {
        willSet { selected(newValue) }
    }

    
    override func config(for video: VIMVideo) {
        let imageObject = video.pictureCollection?.picture(forWidth: Float(videoImageView.frame.size.width))
        videoImageView.imageWith(link: imageObject?.link)
        videoNameLabel.text = video.name
        videoAuthorLabel.text = video.user?.name ?? ""
    }
    
    private func selected(_ isSelected: Bool) {
        if !isSelected { return }
        UIView.animate(withDuration: 0.2,
                       animations: { [weak self] in
                        self?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }) { [weak self] (_) in
            UIView.animate(withDuration: 0.2) { [weak self] in
                self?.transform = .identity
            }
        }
    }
}
