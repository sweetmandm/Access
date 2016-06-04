//
//  UIView+AccessFocus.swift
//  Access
//
//  Created by David Sweetman on 3/13/16.
//  Copyright © 2016 org. All rights reserved.
//

import UIKit
import ObjectiveC

public typealias AccessibilityFocusAction = (() -> Void)

private class OnFocusWrapper {
    var onFocus: AccessibilityFocusAction
    init(onFocus: AccessibilityFocusAction) { self.onFocus = onFocus }
}

var AssociatedOnFocus: UInt8 = 0
var AssociatedDidLoseFocus: UInt8 = 0

public extension UIView {
    
    public var onAccessibilityFocus: AccessibilityFocusAction? {
        get {
            guard UIAccessibilityIsVoiceOverRunning() else { return nil }
            let wrapper = objc_getAssociatedObject(self, &AssociatedOnFocus) as? OnFocusWrapper
            return wrapper?.onFocus
        }
        set {
            guard UIAccessibilityIsVoiceOverRunning() else { return }
            guard let value = newValue else { return }
            objc_setAssociatedObject(self,
                                     &AssociatedOnFocus,
                                     OnFocusWrapper(onFocus: value),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    public var onAccessibilityDidLoseFocus: AccessibilityFocusAction? {
        get {
            guard UIAccessibilityIsVoiceOverRunning() else { return nil }
            let wrapper = objc_getAssociatedObject(self, &AssociatedDidLoseFocus) as? OnFocusWrapper
            return wrapper?.onFocus
        }
        set {
            guard UIAccessibilityIsVoiceOverRunning() else { return }
            guard let value = newValue else { return }
            objc_setAssociatedObject(self,
                                     &AssociatedDidLoseFocus,
                                     OnFocusWrapper(onFocus: value),
                                     objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    
    override public func accessibilityElementDidBecomeFocused() {
        self.onAccessibilityFocus?()
    }
    
    override public func accessibilityElementDidLoseFocus() {
        self.onAccessibilityDidLoseFocus?()
    }
    
}