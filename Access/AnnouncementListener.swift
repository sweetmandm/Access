//
//  AnnouncementListener.swift
//  Access
//
//  Created by David Sweetman on 4/26/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

public typealias ListenerCompletion = (success: Bool) -> Void

let AnnouncementListener = _AnnouncementListener()

/**
 * A helper to listen for UIAccessibilityAnnouncementNotification completions
 */
class _AnnouncementListener {
    
    var listeners = [String:ListenerCompletion]()
    
    private init() {
        NSNotificationCenter.defaultCenter().addObserver(
            self,
            selector: #selector(AnnouncementListener.announcementFinished(_:)),
            name: UIAccessibilityAnnouncementDidFinishNotification,
            object: nil
        )
    }
    
    func listenForFinishWithCompletion(message: String, completion: ListenerCompletion) {
        listeners[message] = completion
    }
    
    @objc func announcementFinished(notice: NSNotification) {
        if let key = notice.userInfo?[UIAccessibilityAnnouncementKeyStringValue] as? String,
            completion = listeners.removeValueForKey(key)
        {
            let success = notice.userInfo?[UIAccessibilityAnnouncementKeyWasSuccessful] as? Bool ?? false
            completion(success: success)
        }
    }
}
