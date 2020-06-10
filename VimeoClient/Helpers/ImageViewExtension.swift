//
//  ImageViewExtension.swift
//  VimeoClient
//
//  Created by Uladzislau Abramchuk on 6/9/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit
extension UIImageView {

    func imageWith(link: String?) {
        guard let imageURLString = link else {
            self.image = UIImage(named: "placeholder")
            return
        }
        DispatchQueue.global().async { [weak self] in
            guard let url = URL(string: imageURLString) else { return }
            let data = try? Data(contentsOf: url)
            DispatchQueue.main.async {
                self?.image = data != nil
                    ? UIImage(data: data!)
                    : UIImage(named: "placeholder")
            }
        }
    }
}
