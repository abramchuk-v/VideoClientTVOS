//
//  VideoSearchModel.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking
struct VideoSearchModel {
    func getVideos(with key: String, handler: @escaping (Swift.Result<[VIMVideo], AppError>) -> Void) {
        let request: Request<[VIMVideo]>
        request = Request(path: "/videos", parameters: ["query" : key])
        let _ = VimeoClient.defaultClient.request(request) { (result) in
            switch result {
            case .success(let response):
                handler(.success(response.model))
            case .failure(let err):
                handler(.failure(.request(err: err)))
            }
        }
    }
}
