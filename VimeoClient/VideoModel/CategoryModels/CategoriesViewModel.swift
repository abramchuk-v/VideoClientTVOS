//
//  CategoriesViewModel.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking
struct CategoriesViewModel {
    private var lastRequest: Response<[VIMCategory]>?
    
    func getCategories(handler: @escaping (Swift.Result<[VIMCategory], AppError>) -> Void) {
        let request: Request<[VIMCategory]>
        request = Request(path: "/categories")
        let _ = VimeoClient.defaultClient.request(request) { (result) in
            switch result {
            case .success(let response):
                handler(.success(response.model))
            case .failure(let err):
                handler(.failure(.request(err: err)))
            }
        }
    }
    
    func video(for category: VIMCategory, handler: @escaping (Swift.Result<[VIMVideo], AppError>) -> Void) {
        guard let link = category.uri else { return }
        let request: Request<[VIMVideo]>
        request = Request(path: "\(link)/videos")
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
