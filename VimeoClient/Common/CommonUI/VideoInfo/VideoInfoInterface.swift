//
//  VideoInfoInterface.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/14/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
import VimeoNetworking.VIMVideo
protocol VideoInfoInterface: UIViewController {
    init(video: VIMVideo)
    func play()
    func defaultPlay()
}
