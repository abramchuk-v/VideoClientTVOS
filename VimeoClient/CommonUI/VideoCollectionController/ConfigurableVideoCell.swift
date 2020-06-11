//
//  ConfigurableVideoCell.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/11/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMVideo

protocol ConfigurableVideoCell: UICollectionViewCell {
    func config(for video: VIMVideo)
}
