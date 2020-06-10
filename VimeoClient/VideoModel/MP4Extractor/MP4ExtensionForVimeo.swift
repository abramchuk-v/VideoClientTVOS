//
//  MP4ExtensionForVimeo.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/5/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking

extension VIMVideo {
    func mp4Link(handler: @escaping (Swift.Result<[VimeoVideoQuality: URL], AppError>) -> Void) {
        guard let videoLink = URL(string: self.link ?? "") else {
            handler(.failure(.parsing(message: "Invalid link")))
            return
        }
        HCVimeoVideoExtractor.fetchVideoURLFrom(url: videoLink) { (result) in
            switch result {
            case .success(let video):
                handler(.success(video))
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}


