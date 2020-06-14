//
//  CategoriesViewModel.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking
struct CategoriesModel<CategoryItem> {
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
    
}
