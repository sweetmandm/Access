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
    
    convenience init(staticSize: CGFloat, fontStyle: Font.FontStyle, configName: String = Font.PrimaryFontConfigurationName) {
        let descriptor = Font.descriptorWith(staticSize: staticSize, fontStyle: fontStyle, configName: configName)
        self.init(descriptor: descriptor, size: descriptor.pointSize)
    }
}

open class Font {
    
    open static let PrimaryFontConfigurationName = "PrimaryFontConfiguration"
    
    open static func configure(_ configuration: FontConfiguration, configName: String = PrimaryFontConfigurationName) {
        Font.fontConfigurations[configName] = configuration
    }
    
    open static func create(_ type: TextType, style: FontStyle, configName: String = PrimaryFontConfigurationName) -> UIFont {
        return UIFont(textType: type, fontStyle: style, configName: configName)
    }
    
    /**
     * SizeMap associates UIContentSizeCategory keys with their default point size.
     */
    public typealias SizeMap = [UIContentSizeCategory: CGFloat]
    
    open static func makeSizeMap(
        extraSmall: CGFloat,
                   small: CGFloat,
                   medium: CGFloat,
                   large: CGFloat,
                   extraLarge: CGFloat,
                   extraExtraLarge:CGFloat,
                   extraExtraExtraLarge:CGFloat,
                   accessibilityMedium: CGFloat,
                   accessibilityLarge: CGFloat,
                   accessibilityExtraLarge: CGFloat,
                   accessibilityExtraExtraLarge: CGFloat,
                   accessibilityExtraExtraExtraLarge: CGFloat
        )
        -> SizeMap
    {
        return [
            .extraSmall: extraSmall,
            .small: small,
            .medium: medium,
            .large: large,
            .extraLarge: extraLarge,
            .extraExtraLarge: extraExtraLarge,
            .extraExtraExtraLarge: extraExtraExtraLarge,
            .accessibilityMedium: accessibilityMedium,
            .accessibilityLarge: accessibilityLarge,
            .accessibilityExtraLarge: accessibilityExtraLarge,
            .accessibilityExtraExtraLarge: accessibilityExtraExtraLarge,
            .accessibilityExtraExtraExtraLarge: accessibilityExtraExtraExtraLarge
        ]
    }
    
    fileprivate static func defaultSizeMap() -> SizeMap {
        return  Font.makeSizeMap(
            extraSmall: 13.0,
            small: 16.0,
            medium: 18.0,
            large: 20.0,
            extraLarge: 22.0,
            extraExtraLarge: 24.0,
            extraExtraExtraLarge: 25.0,
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
    public typealias TextStyleScaleMap = [UIFontTextStyle: CGFloat]
    
    open static func makeTextStyleScale(
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
            .headline: headline,
            .subheadline: subheadline,
            .body: body,
            .caption1: caption1,
            .caption2: caption2,
            .footnote: footnote
        ]
    }
    
    fileprivate static func defaultStyleScale() -> TextStyleScaleMap {
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
    
    open static func makeFontNames(
        light: String? = nil,
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
            .light: light,
            .regular: regular,
            .bold: bold,
            .lightItalic: lightItalic,
            .italic: italic,
            .boldItalic: boldItalic
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
    
    fileprivate static func scaleFactorFor(textType: Font.TextType, configName: String) -> CGFloat {
        return fontConfigurations[configName]?.styleScale[textType.toUIFontTextStyle()] ?? 1.0
    }
    
    public enum FontStyle {
        case light, regular, bold, lightItalic, italic, boldItalic
        
        func symbolicTraits() -> UIFontDescriptorSymbolicTraits? {
            switch self {
            case .bold:
                return .traitBold
            case .italic:
                return .traitItalic
            case .boldItalic:
                return [.traitBold, .traitItalic]
            default:
                return nil
            }
        }
        
        func attributes() -> [String: AnyObject]? {
            switch self {
            case .light,
                 .lightItalic:
                return [UIFontDescriptorFaceAttribute: "Light" as AnyObject]
            default:
                return nil
            }
        }
    }
    
    public enum TextType {
        case headline, subheadline, body, caption1, caption2, footnote
        internal func toUIFontTextStyle() -> UIFontTextStyle {
            switch self {
            case .headline: return UIFontTextStyle.headline
            case .subheadline: return UIFontTextStyle.subheadline
            case .body: return UIFontTextStyle.body
            case .caption1: return UIFontTextStyle.caption1
            case .caption2: return UIFontTextStyle.caption2
            case .footnote: return UIFontTextStyle.footnote
            }
        }
    }
    
    fileprivate static func nameFor(fontStyle: Font.FontStyle, configName: String) -> String? {
        return fontConfigurations[configName]?.fontNames?[fontStyle]
    }
    
    fileprivate static func descriptorWith(textType type: Font.TextType, fontStyle style: Font.FontStyle, configName: String) -> UIFontDescriptor {
        let contentSize = UIApplication.shared.preferredContentSizeCategory
        let scale = scaleFactorFor(textType: type, configName: configName)
        let fontSize = fontConfigurations[configName]?.sizeMap[contentSize] ?? 13.0
        let scaledFontSize = CGFloat(fontSize) * scale
        guard let name = self.nameFor(fontStyle: style, configName: configName) else {
            var descriptor = UIFontDescriptor
                .preferredFontDescriptor(withTextStyle: type.toUIFontTextStyle())
                .withSize(scaledFontSize)
            if let traits = style.symbolicTraits(),
                let newValue = descriptor.withSymbolicTraits(traits)
            {
                descriptor = newValue
            }
            if let attributes = style.attributes() {
                descriptor = descriptor.addingAttributes(attributes)
            }
            
            return descriptor
        }
        return UIFontDescriptor(name: name, size: scaledFontSize)
    }
    
    fileprivate static func descriptorWith(staticSize: CGFloat, fontStyle style: Font.FontStyle, configName: String) -> UIFontDescriptor {
        guard let name = self.nameFor(fontStyle: style, configName: configName) else {
            let systemFont = UIFont.systemFont(ofSize: staticSize)
            var descriptor = UIFontDescriptor(name: systemFont.fontName, size: staticSize)
            if let traits = style.symbolicTraits() {
                descriptor = descriptor.withSymbolicTraits(traits)!
            }
            if let attributes = style.attributes() {
                descriptor = descriptor.addingAttributes(attributes)
            }
            
            return descriptor
        }
        return UIFontDescriptor(name: name, size: staticSize)
    }
}
