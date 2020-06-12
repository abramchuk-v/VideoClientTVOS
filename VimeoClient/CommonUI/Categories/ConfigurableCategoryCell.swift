//
//  ConfigurableCategoryCell.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/11/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class ConfigurableCell<Item: Hashable>: UITableViewCell {
    func config(category: Item) {}
}
