//
//  AccessibilityInstructions.swift
//  Access
//
//  Created by David Sweetman on 11/29/15.
//  Copyright © 2016. All rights reserved.
//

import UIKit

open class VO {
    
    fileprivate init() {}
    
    public enum AccessibilityEventType {
        case layout
        case screenChange
        func value() -> UIAccessibilityNotifications {
            switch (self) {
            case .layout: return UIAccessibilityLayoutChangedNotification
            case .screenChange: return UIAccessibilityScreenChangedNotification
            }
        }
    }
    
    static func handleVoiceoverDisabled(_ completion: ListenerCompletion?) {
        guard let completion = completion else { return }
        DispatchQueue.main.async {
            completion(true)
        }
    }
    
    static open func announce(_ message: String, delay: UInt64 = 0, completion: ListenerCompletion? = nil) {
        guard UIAccessibilityIsVoiceOverRunning() else {
            handleVoiceoverDisabled(completion)
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: delay)) {
            UIAccessibilityPostNotification(
                UIAccessibilityAnnouncementNotification,
                message
            );
            if let c = completion {
                AnnouncementListener.listenForFinishWithCompletion(message, completion: c)
            }
        }
    }
    
    static open func focusElement(_ element: UIView, event: AccessibilityEventType = .layout, delay: UInt64 = 0) {
        DispatchQueue.main.asyncAfter(deadline: DispatchTime(uptimeNanoseconds: delay)) {
            UIAccessibilityPostNotification(event.value(), element)
        }
    }
}
