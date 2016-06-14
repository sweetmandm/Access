//
//  Stepper.swift
//  VODemo
//
//  Created by David Sweetman on 6/4/16.
//  Copyright © 2016 tinfish. All rights reserved.
//

import UIKit

/**
 *  The default UIStepper is not highly accessible. It exposes its private UIButtons as individual
 *  accessible elements, and since they are private there is no way to set their accessibility 
 *  attributes. The UIStepper  is better suited to an adjustable trait, so this makes the stepper a 
 *  single interactive component that can be swiped up & down like any other adjustable control.
 *
 *  You can set its accessibilityLabel and respond to .ValueChanged to update its accessibilityValue.
 */

class Stepper: UIStepper
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    override var value: Double {
        didSet {
            updateAccessibilityAttributes()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    func setup() {
        setupAccessibility()
        updateAccessibilityAttributes()
    }
    
    func setupAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitAdjustable
    }
    
    override func accessibilityIncrement() {
        value += stepValue
        sendActionsForControlEvents(.ValueChanged)
        announceValue()
    }
    
    override func accessibilityDecrement() {
        value -= stepValue
        sendActionsForControlEvents(.ValueChanged)
        announceValue()
    }
    
    func announceValue() {
        if let announcement = self.accessibilityValue where !announcement.isEmpty {
            Access.VO.announce(announcement)
        }
    }
    
    private func updateAccessibilityAttributes() {
        accessibilityValue = String(value)
    }
}