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

public class Stepper: UIStepper
{
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    override public var value: Double {
        didSet {
            updateAccessibilityAttributes()
        }
    }
    
    private func setup() {
        setupAccessibility()
        updateAccessibilityAttributes()
    }
    
    private func updateAccessibilityAttributes() {
        accessibilityValue = String(value)
    }
    
    private func setupAccessibility() {
        self.isAccessibilityElement = true
        self.accessibilityTraits = UIAccessibilityTraitAdjustable
    }
    
    private func announceValue() {
        if let announcement = self.accessibilityValue where !announcement.isEmpty {
            Access.VO.announce(announcement)
        }
    }
    
    override public func accessibilityIncrement() {
        value += stepValue
        sendActionsForControlEvents(.ValueChanged)
        announceValue()
    }
    
    override public func accessibilityDecrement() {
        value -= stepValue
        sendActionsForControlEvents(.ValueChanged)
        announceValue()
    }
}