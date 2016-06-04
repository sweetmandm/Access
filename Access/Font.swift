//
//  Font.swift
//  Access
//
//  Created by David Sweetman on 4/7/16.
//  Copyright © 2016. All rights reserved.
//

import UIKit

/**
 * This helper is designed to make it easier to use custom fonts with dynamic text.
 */

public extension UIFont {
    convenience init(textType: Font.TextType, fontStyle: Font.FontStyle, configName: String = Font.PrimaryFontConfigurationName) {
        let descriptor = Font.descriptorWith(textType: textType, fontStyle: fontStyle, configName: configName)
        self.init(descriptor: descriptor, size: descriptor.pointSize)
    }
}

public class Font {
    
    public static let PrimaryFontConfigurationName = "PrimaryFontConfiguration"
    
    public static func configure(configuration: FontConfiguration, configName: String = PrimaryFontConfigurationName) {
        Font.fontConfigurations[configName] = configuration
    }
    
    public static func create(type: TextType, style: FontStyle, configName: String = PrimaryFontConfigurationName) -> UIFont {
        return UIFont(textType: type, fontStyle: style, configName: configName)
    }
    
    /**
     * SizeMap associates UIContentSizeCategory keys with their default point size.
     */
    public typealias SizeMap = [String: CGFloat]
    
    public static func makeSizeMap(
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
        )
    }
    
    /**
     * TextStyleScale associates UIFontTextStyle keys with their default scale factors.
     */
    public typealias TextStyleScaleMap = [String: CGFloat]
    
    public static func makeTextStyleScale(
        headline headline: CGFloat,
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
            headline: 1.2,
            subheadline: 1.1,
            body: 1.0,
            callout: 0.9,
            caption1:0.9,
            caption2: 0.75,
            footnote: 0.6
        )
    }
    
    public static func makeFontNames(
        light light: String? = nil,
              regular: String? = nil,
              bold: String? = nil,
              lightItalic: String? = nil,
              italic: String? = nil,
              boldItalic: String? = nil
        )
        -> [Font.FontStyle: String]
    {
        var names: [Font.FontStyle: String] = [:]
        let namesWithNils: [Font.FontStyle: String?] = [
            .Light: light,
            .Regular: regular,
            .Bold: bold,
            .LightItalic: lightItalic,
            .Italic: italic,
            .BoldItalic: boldItalic
        ]
        namesWithNils.forEach { (key, value) in
            if let value = value { names[key] = value }
        }
        return names
    }
    
    public struct FontConfiguration {
        var sizeMap: SizeMap
        var styleScale: TextStyleScaleMap
        var fontNames: [Font.FontStyle: String]?
        
        public init(sizeMap: SizeMap = Font.defaultSizeMap(),
             styleScale: TextStyleScaleMap = Font.defaultStyleScale(),
             fontNames: [Font.FontStyle: String]? = nil)
        {
            self.sizeMap = sizeMap
            self.styleScale = styleScale
            self.fontNames = fontNames
        }
    }
    
    static var fontConfigurations = [
        PrimaryFontConfigurationName: FontConfiguration(
            sizeMap: Font.defaultSizeMap(),
            styleScale: Font.defaultStyleScale(),
            fontNames: nil
        )
    ]
    
    private static func scaleFactorForTextType(type: Font.TextType, configName: String) -> CGFloat {
        return fontConfigurations[configName]?.styleScale[type.toString()] ?? 1.0
    }
    
    public enum FontStyle {
        case Light, Regular, Bold, LightItalic, Italic, BoldItalic
    }
    
    public enum TextType {
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
    
    private static func nameForStyle(type: Font.FontStyle, configName: String) -> String? {
        return fontConfigurations[configName]?.fontNames?[type]
    }
    
    private static func descriptorWith(textType type: Font.TextType, fontStyle style: Font.FontStyle, configName: String) -> UIFontDescriptor {
        let contentSize = UIApplication.sharedApplication().preferredContentSizeCategory
        let scale = scaleFactorForTextType(type, configName: configName)
        let fontSize = fontConfigurations[configName]?.sizeMap[contentSize] ?? 13
        let scaledFontSize = CGFloat(fontSize) * scale
        guard let name = self.nameForStyle(style, configName: configName) else {
            return UIFontDescriptor
                .preferredFontDescriptorWithTextStyle(type.toString())
                .fontDescriptorWithSize(scaledFontSize)
        }
        return UIFontDescriptor(name: name, size: scaledFontSize)
    }
    
}
