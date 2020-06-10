//
//  ErrorStructure.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/5/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation

enum AppError: Error {
    case parsing(message: String)
    case response(message: String)
    case mp4
    case request(err: Error)
}


