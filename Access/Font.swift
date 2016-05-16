//
//  Font.swift
//  makers
//
//  Created by David Sweetman on 4/7/16.
//  Copyright © 2016 makers. All rights reserved.
//

import UIKit

class Font {
    private init() {}
    
    /**
     * SizeMap associates UIContentSizeCategory keys with their default point size.
     */
    typealias SizeMap = [String: CGFloat]
    
    static func makeSizeMap(
        extraSmall extraSmall: CGFloat,
        small: CGFloat,
        medium: CGFloat,
        large: CGFloat,
        extraLarge: CGFloat,
        extraExtraLarge:CGFloat,
        accessibilityMedium: CGFloat,
        accessibilityLarge: CGFloat,
        accessibilityExtraLarge: CGFloat,
        accessibilityExtraExtraLarge: CGFloat,
        accessibilityExtraExtraExtraLarge: CGFloat
    )
        -> SizeMap
    {
        return [
            UIContentSizeCategoryExtraSmall: extraSmall,
            UIContentSizeCategorySmall: small,
            UIContentSizeCategoryMedium: medium,
            UIContentSizeCategoryLarge: large,
            UIContentSizeCategoryExtraLarge: extraLarge,
            UIContentSizeCategoryExtraExtraLarge: extraExtraLarge,
            UIContentSizeCategoryAccessibilityMedium: accessibilityMedium,
            UIContentSizeCategoryAccessibilityLarge: accessibilityLarge,
            UIContentSizeCategoryAccessibilityExtraLarge: accessibilityExtraLarge,
            UIContentSizeCategoryAccessibilityExtraExtraLarge: accessibilityExtraExtraLarge,
            UIContentSizeCategoryAccessibilityExtraExtraExtraLarge: accessibilityExtraExtraExtraLarge
        ]
    }
    
    private static func defaultSizeMap() -> SizeMap {
        return  Font.makeSizeMap(
            extraSmall: 12.0,
            small: 13.0,
            medium: 14.0,
            large: 15.0,
            extraLarge: 16.0,
            extraExtraLarge: 17.0,
            accessibilityMedium: 17.0,
            accessibilityLarge: 18.0,
            accessibilityExtraLarge: 19.0,
            accessibilityExtraExtraLarge: 20.0,
            accessibilityExtraExtraExtraLarge: 21.0
        )
    }
    
    /**
     * TextStyleScale associates UIFontTextStyle keys with their default scale factors.
     */
    typealias TextStyleScaleMap = [String: CGFloat]
    
    static func makeTextStyleScale(
        title1 title1: CGFloat,
        title2: CGFloat,
        title3: CGFloat,
        headline: CGFloat,
        subheadline: CGFloat,
        body: CGFloat,
        callout: CGFloat,
        caption1: CGFloat,
        caption2: CGFloat,
        footnote: CGFloat
    )
        -> TextStyleScaleMap
    {
        return [
            UIFontTextStyleTitle1: title1,
            UIFontTextStyleTitle2: title2,
            UIFontTextStyleTitle3: title3,
            UIFontTextStyleHeadline: headline,
            UIFontTextStyleSubheadline: subheadline,
            UIFontTextStyleBody: body,
            UIFontTextStyleCaption1: caption1,
            UIFontTextStyleCaption2: caption2,
            UIFontTextStyleFootnote: footnote
        ]
    }
    
    private static func defaultStyleScale() -> TextStyleScaleMap {
        return Font.makeTextStyleScale(
            title1: 1.2,
            title2: 1.15,
            title3: 1.1,
            headline: 1.2,
            subheadline: 1.1,
            body: 1.0,
            callout: 0.9,
            caption1:0.9,
            caption2: 0.75,
            footnote: 0.6
        )
    }
    
    typealias FontConfiguration = (
        sizeMap: SizeMap,
        styleScale: TextStyleScaleMap
    )
    
    static var fontConfiguration = (
        sizeMap: Font.defaultSizeMap(),
        styleScale: Font.defaultStyleScale()
    )
    
    private static func scaleFactorForTextType(type: Font.TextType) -> CGFloat {
        return fontConfiguration.styleScale[type.toString()] ?? 1.0
    }
    

    enum FontStyle {
        case Light, Regular, Bold
    }
    
    enum TextType {
        case Headline, Subheadline, Body, Caption1, Caption2, Footnote
        internal func toString() -> String {
            switch self {
            case .Headline: return UIFontTextStyleHeadline
            case .Subheadline: return UIFontTextStyleSubheadline
            case .Body: return UIFontTextStyleBody
            case .Caption1: return UIFontTextStyleCaption1
            case .Caption2: return UIFontTextStyleCaption2
            case .Footnote: return UIFontTextStyleFootnote
            }
        }
    }
    
    static func fontType(style: FontStyle, type: TextType) -> UIFont {
        let descriptor = descriptorWith(style, type)
        return UIFont(descriptor: descriptor, size: descriptor.pointSize)
    }
    
    private static var fontNamesForType: [Font.FontStyle: String]?
    
    static func initializeWith(fontNames: [Font.FontStyle: String]) {
        fontNamesForType = fontNames
    }
    
    private static func nameForStyle(type: Font.FontStyle) -> String? {
        return fontNamesForType?[type]
    }
    
    private static func descriptorWith(style: Font.FontStyle, _ type: Font.TextType) -> UIFontDescriptor {
        let contentSize = UIApplication.sharedApplication().preferredContentSizeCategory
        let scale = scaleFactorForTextType(type)
        let fontSize = fontConfiguration.sizeMap[contentSize] ?? 13
        let scaledFontSize = CGFloat(fontSize) * scale
        guard let name = self.nameForStyle(style) else {
            return UIFontDescriptor
                .preferredFontDescriptorWithTextStyle(type.toString())
                .fontDescriptorWithSize(scaledFontSize)
        }
        return UIFontDescriptor(name: name, size: scaledFontSize)
    }
}
