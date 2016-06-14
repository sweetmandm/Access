Access
======

Access is intended to make the iOS accessibility APIs a little nicer to use.

## Access.VO

VoiceOver is the text-to-speech tool on iOS that makes the operating system accessible for users with visual impairments.

The Access helper for VoiceOver (`Access.VO`) wraps some of the VoiceOver interface with functions that improve their readability and usefulness.

**Access.VO.announce**

Speak a message out loud using VoiceOver:

```
Access.VO.announce("If VoiceOver is active, this message will be read out loud.")
```

Speak a message and execute code when reading is finished:

```
Access.VO.announce("The closure will execute after this message is read.") { success in
    /**
     * If Voiceover is not active, this closure executes immediately.
     * If VoiceOver is active, this closure executes when the message has finished
     * or has been interrupted. `success` indicates that the VoiceOver completed
     * reading the whole message and it was not interrupted.
     */
    Access.VO.announce("The first announcement has completed.")
}
```

**Access.VO.focusElement**

If VoiceOver is active, this will immediately move VoiceOver focus to the element.
```
Access.VO.focusElement(myButton)
```

## Access.Font

The dynamic font helper (`Access.Font`) takes care of a lot of the boilerplate for using Font Descriptors. It allows you to use custom font families while benefiting from the dynamic font sizing that some users with visual impairments rely on to make the screen readable.

Font configuration is comprised of three main pieces:

1. Font Names. These associate font strings to styles, e.g. `bold: "DamascusBold"`.

2. Font Sizes. These associate a 'base' point size with each `UIContentSizeCategory`. The `UIContentSizeCategory` is the value that is adjusted when the user modifies `Settings > General > Accessibility > Larger Text`.

3. Style Scales. These associate the semantic text type (Headline, Body, Footnote, etc.) with a scalar value. The 'base' point size is multiplied by this value to determine the onscreen point size.

You use `Accesss.Font` by performing initial setup, and afterward using the convenience font initializer `UIFont(textType:fontStyle:)`

If the defaults defined in Access.Font are acceptable and you want to use the system font, you can skip the configuration step and just use th UIFont convenience initializer.

If you want to create multiple font configurations, you can call `Access.Font.configure()` multiple times, providing a new `configName` each time. When you want to use a specific configuration, specify it in the convenience initializer: `UIFont(textType:fontStyle:configName:)`

Example font configuration, overriding all default values:
```
    Access.Font.configure(
        Font.FontConfiguration(
            sizeMap: Font.makeSizeMap(
                extraSmall: 13.0,
                small: 16.0,
                medium: 18.0,
                large: 20.0,
                extraLarge: 22.0,
                extraExtraLarge: 24.0,
                accessibilityMedium: 26.0,
                accessibilityLarge: 28.0,
                accessibilityExtraLarge: 30.0,
                accessibilityExtraExtraLarge: 32.0,
                accessibilityExtraExtraExtraLarge: 35.0
            ),
            styleScale: Font.makeTextStyleScale(
                headline: 1.2,
                subheadline: 1.1,
                body: 1.0,
                callout: 0.9,
                caption1:0.9,
                caption2: 0.75,
                footnote: 0.6
            ),
            fontNames: Font.makeFontNames(
                light: "Avenir-Book",
                regular: "Avenir-Medium",
                bold: "Avenir-Black",
                lightItalic: "Avenir-BookOblique",
                italic: "Avenir-MediumOblique",
                boldItalic: "Avenir-BlackOblique"
            )
        )
    )
```

To create a second configuration, you can specify a configName:
```
     Access.Font.configure(
         Font.FontConfiguration(
             ...
         ),
         configName: "MyOtherFontConfiguration"
     )
```
Then reference the new config name in the UIFont convenience initializer:
```
let font = UIFont(textType: .Body, fontStyle: .Bold, configName: "MyOtherFontConfiguration")
 
```

## UIView+AccessFocus

Sometimes it's useful to get a callback when an element receives focus or loses focus. The supported way to get focus messages is to create a view subclass and override `accessibilityElementDidBecomeFocused()` and `accessibilityElementDidLoseFocus()`. However, it can be inconvenient to subclass a view just to override this function.

The `UIView+AccessFocus` extension adds two properties to `UIView` using associated objects: `onAccessibilityFocus` and `onAccessibilityDidLoseFocus`. They are closures that will be executed when the element gains and loses focus. If VoiceOver is not running, get/set on these properties will return early with no side-effects.

Example:
```
let button = UIButton(type: .System)

button.onAccessibilityFocus = {
    print("The button gained focus")
}

button.onAccessibilityDidLoseFocus = {
    print("The button lost focus")
}
```

## Access.Stepper

The `UIStepper` UIKit component is not highly accessible. Since its buttons are private, there's not a good way to update their accessibility attributes, which would be helpful to provide VoiceOver users with extra context for what the stepper value represets.

I think `Access.Stepper` represents an accessibility improvement over the UIStepper since the stepper is very well-suited to the adopt UIAccessibilityTraitAdjustable and can be represented as a single interactive component.

Example:
```
func setupStepper() {
    let stepper = Access.Stepper()
    view.addSubview(stepper)
    stepper.accessibilityLabel = "My Step-able Item"
    stepper.addTarget(self, action: #selector(didStep), forControlEvents: .ValueChanged)
    updateStepperValue()
}

@IBAction func didStep(sender: AnyObject) {
    updateCustomStepperValue()
}

func updateStepperValue() {
    // The Stepper will use its 'value' property as the default accessibilityValue.
    // If you need to provide extra context, you can adjust it:
    customStepper.accessibilityValue ="\(Int(value)) Items" 
}
```
