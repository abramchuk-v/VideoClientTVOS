//
//  FocusableLabel.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/17/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class FocusableLabel: UILabel {

    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedView == self {
            coordinator.addCoordinatedUnfocusingAnimations({ [weak self] (context) in
                self?.transform = .identity
            }, completion: nil)
        } else {
            coordinator.addCoordinatedFocusingAnimations({ [weak self] (context) in
                self?.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                
            },
                                                         completion: nil)
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        return true
    }

}
