//
//  VideoCollectionFooter.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/17/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class VideoCollectionFooter: UICollectionReusableView {
    @IBOutlet private weak var scrollToTopButton: UIButton!
    
    private var scrollToTopButtonAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        let fcGuide = UIFocusGuide()
        fcGuide.preferredFocusEnvironments = [scrollToTopButton]
        addLayoutGuide(fcGuide)
        
        fcGuide.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fcGuide.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        fcGuide.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        fcGuide.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
    }

    @IBAction private func scrollToTop(_ sender: Any) {
        guard let action = scrollToTopButtonAction else { return }
        action()
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return super.shouldUpdateFocus(in: context)
    }
    
    func setScrollToTopButtonAction(handler: (() -> Void)?) {
        scrollToTopButtonAction = handler
    }
}
