//
//  DSTypography.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

import SwiftUI

@MainActor
struct DSTypography {

    // MARK: - Font Family

    /// ArticulatCF is a font that is only available to purchase
    /// So in this app I'm using the a system Apple font
    private static let defaultFontName: String? = nil

    // MARK: - Weight

    enum Weight {
        case regular
        case medium
        case semibold
        case bold
    }

    // MARK: - Public API (Design Tokens)

    static func largeTitle(weight: Weight = .regular) -> Font {
        font(.largeTitle, weight: weight)
    }

    static func title(weight: Weight = .regular) -> Font {
        font(.title, weight: weight)
    }

    static func title2(weight: Weight = .regular) -> Font {
        font(.title2, weight: weight)
    }

    static func title3(weight: Weight = .regular) -> Font {
        font(.title3, weight: weight)
    }

    static func headline(weight: Weight = .semibold) -> Font {
        font(.headline, weight: weight)
    }

    static func subheadline(weight: Weight = .regular) -> Font {
        font(.subheadline, weight: weight)
    }

    static func body(weight: Weight = .regular) -> Font {
        font(.body, weight: weight)
    }

    static func callout(weight: Weight = .regular) -> Font {
        font(.callout, weight: weight)
    }

    static func footnote(weight: Weight = .regular) -> Font {
        font(.footnote, weight: weight)
    }

    static func caption(weight: Weight = .regular) -> Font {
        font(.caption, weight: weight)
    }

    static func caption2(weight: Weight = .regular) -> Font {
        font(.caption2, weight: weight)
    }

    // MARK: - Core Builder

    private static func font(
        _ textStyle: Font.TextStyle,
        weight: Weight,
        size: CGFloat? = nil
    ) -> Font {

        let fontSize = size ?? fontSize(for: textStyle)

        // Custom font path
        if let fontName = fontName(for: weight) {
            return Font.custom(fontName, size: fontSize, relativeTo: textStyle)
        }

        // Fallback to system
        return Font.system(
            size: fontSize,
            weight: swiftUIWeight(from: weight)
        )
    }

    // MARK: - Font Name Mapping

    private static func fontName(for weight: Weight) -> String? {
        guard let base = defaultFontName else { return nil }

        switch weight {
        case .regular: return "\(base)-Regular"
        case .medium: return "\(base)-Medium"
        case .semibold: return "\(base)-Semibold"
        case .bold: return "\(base)-Bold"
        }
    }

    // MARK: - Size Logic (Phone vs Tablet)

    private static func fontSize(for textStyle: Font.TextStyle) -> CGFloat {
        let isTablet = UIDevice.current.userInterfaceIdiom == .pad

        switch textStyle {
        case .largeTitle: return isTablet ? 40 : 32
        case .title: return isTablet ? 28 : 20
        case .title2: return isTablet ? 24 : 18
        case .title3: return isTablet ? 20 : 16
        case .headline: return isTablet ? 20 : 16
        case .subheadline: return isTablet ? 18 : 14
        case .body: return isTablet ? 20 : 16
        case .callout: return isTablet ? 18 : 16
        case .footnote: return isTablet ? 14 : 12
        case .caption: return isTablet ? 14 : 12
        case .caption2: return isTablet ? 12 : 11
        default: return 16
        }
    }

    // MARK: - SwiftUI Weight Mapping

    private static func swiftUIWeight(from weight: Weight) -> Font.Weight {
        switch weight {
        case .regular: return .regular
        case .medium: return .medium
        case .semibold: return .semibold
        case .bold: return .bold
        }
    }
}
