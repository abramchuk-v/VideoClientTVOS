//
//  FocusableTextView.swift
//  tvOSClient
//
//  Created by Uladzislau Abramchuk on 6/17/20.
//  Copyright © 2020 Uladzislau Abramchuk. All rights reserved.
//

import UIKit

class FocusableTextView: UITextView {

    override var canBecomeFocused: Bool {
        return true
    }
    
    override func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        
        if context.previouslyFocusedView == self {
            coordinator.addCoordinatedUnfocusingAnimations({ [weak self] (context) in
                self?.transform = .identity
                self?.backgroundColor = .clear
            }, completion: nil)
        } else {
            coordinator.addCoordinatedFocusingAnimations({ [weak self] (context) in
                self?.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
                self?.backgroundColor = .white
                
            },
                                                         completion: nil)
        }
    }
    
    override func shouldUpdateFocus(in context: UIFocusUpdateContext) -> Bool {
        if context.nextFocusedView === self { return true }
        
        let contentHeight = contentSize.height
        let contentY = contentOffset.y
        let textViewHeight = bounds.size.height
        
        if contentHeight < textViewHeight { return true }
        
        if contentY == 0 && context.focusHeading == .up { return true }
        
        if contentY + textViewHeight >= contentHeight && context.focusHeading == .down { return true }
        
        return false
    }

}
