//
//  AnnouncementListener.swift
//  Access
//
//  Created by David Sweetman on 4/26/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

public typealias ListenerCompletion = (_ success: Bool) -> Void

let AnnouncementListener = _AnnouncementListener()

/**
 * A helper to listen for UIAccessibilityAnnouncementNotification completions
 */
class _AnnouncementListener {
    
    var listeners = [String:ListenerCompletion]()
    
    fileprivate init() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(AnnouncementListener.announcementFinished(_:)),
            name: NSNotification.Name.UIAccessibilityAnnouncementDidFinish,
            object: nil
        )
    }
    
    func listenForFinishWithCompletion(_ message: String, completion: @escaping ListenerCompletion) {
        listeners[message] = completion
    }
    
    @objc func announcementFinished(_ notice: Notification) {
        if let key = (notice as NSNotification).userInfo?[UIAccessibilityAnnouncementKeyStringValue] as? String,
            let completion = listeners.removeValue(forKey: key)
        {
            let success = (notice as NSNotification).userInfo?[UIAccessibilityAnnouncementKeyWasSuccessful] as? Bool ?? false
            completion(success)
        }
    }
}
