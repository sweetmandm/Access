//
//  AccessibilityInstructions.swift
//  record
//
//  Created by David Sweetman on 11/29/15.
//  Copyright © 2015 org. All rights reserved.
//

import UIKit

public class Access {
    
    private init() {}
    
    public enum AccessibilityEventType {
        case Layout
        case ScreenChange
        func value() -> UIAccessibilityNotifications {
            switch (self) {
            case .Layout: return UIAccessibilityLayoutChangedNotification
            case .ScreenChange: return UIAccessibilityScreenChangedNotification
            }
        }
    }
    
    static public func announce(message: String, delay: UInt64 = 0, completion: ListenerCompletion? = nil) {
        if (UIAccessibilityIsVoiceOverRunning()) {
            dispatch_after(delay, dispatch_get_main_queue()) {
                UIAccessibilityPostNotification(
                    UIAccessibilityAnnouncementNotification,
                    message
                );
                if let c = completion {
                    AnnouncementListener.listenForFinishWithCompletion(message, completion: c)
                }
            }
        } else {
            dispatch_async(dispatch_get_main_queue()) {
                completion?(success: true)
            }
        }
    }
    
    static public func focusElement(element: UIView, event: AccessibilityEventType = .Layout, delay: UInt64 = 0) {
        dispatch_after(delay, dispatch_get_main_queue()) {
            UIAccessibilityPostNotification(event.value(), element)
        }
    }
}
