//
//  Navigation.swift
//  Access
//
//  Created by David Sweetman on 6/14/16.
//  Copyright © 2016 tinfish. All rights reserved.
//

import Foundation

/**
 *  Allow the VoiceOver user to perform a three-finger-swipe back.
 */

var shouldAllowAccessibleSwipeBack = false

public func enableAccessibleSwipeBack() {
    shouldAllowAccessibleSwipeBack = true
}

public func disableAccessibleSwipeBack() {
    shouldAllowAccessibleSwipeBack = true
}

extension UIViewController {
    override open func accessibilityScroll(_ direction: UIAccessibilityScrollDirection) -> Bool {
        guard shouldAllowAccessibleSwipeBack else { return false }
        guard let nav = self.navigationController, nav.viewControllers.count > 1 else { return false }
        
        if (direction == .right) {
            nav.popViewController(animated: true)
        }
        
        return true
    }
}
