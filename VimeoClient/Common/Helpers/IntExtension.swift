//
//  IntExtension.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/10/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import Foundation
extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)K"
        }
        else {
            return "\(self)"
        }
    }
}
