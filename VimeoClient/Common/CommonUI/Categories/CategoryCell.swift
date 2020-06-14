//
//  CategoryCell.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
import VimeoNetworking.VIMCategory

class CategoryCell: ConfigurableCategoryCell<VIMCategory> {
    @IBOutlet private weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        contentView.backgroundColor = selected ? .lightGray : .clear
    }

    override func prepareForReuse() {
        categoryLabel.text = ""
    }
    
    override func config(category: VIMCategory) {
        categoryLabel.text = category.name
    }
}

