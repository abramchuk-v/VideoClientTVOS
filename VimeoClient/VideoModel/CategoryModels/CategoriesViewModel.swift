//
//  CategoriesViewModel.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking
struct CategoriesViewModel<CategoryItem, VideoItem> {
    private var lastRequest: Response<[CategoryItem]>?
    
    func getCategories(handler: @escaping (Swift.Result<[CategoryItem], AppError>) -> Void) {
        let request: Request<[CategoryItem]>
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
    
    func video(for category: VIMCategory, handler: @escaping (Swift.Result<[VideoItem], AppError>) -> Void) {
        guard let link = category.uri else { return }
        let request: Request<[VideoItem]>
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
