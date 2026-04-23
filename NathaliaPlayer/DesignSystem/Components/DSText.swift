//
//  DSText.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct DSText: View {

    enum Style {
        case largeTitle
        case headline
        case subheadline
        case title
        case title2
        case title3
        case body
        case caption
        case caption2
        case callout
        case footnote
    }

    let text: String
    let style: Style
    let weight: DSTypography.Weight

    init(text: String, style: Style, weight: DSTypography.Weight = .regular) {
        self.text = text
        self.style = style
        self.weight = weight
    }

    var body: some View {
        Text(text)            
            .font(font)
            .foregroundColor(color)
            .lineLimit(1)
    }

    private var font: Font {
        switch style {
        case .largeTitle: return DSTypography.largeTitle(weight: weight)
        case .headline: return DSTypography.headline(weight: weight)
        case .title: return DSTypography.title(weight: weight)
        case .title2: return DSTypography.title2(weight: weight)
        case .title3: return DSTypography.title3(weight: weight)
        case .subheadline: return DSTypography.subheadline(weight: weight)
        case .body: return DSTypography.body(weight: weight)
        case .caption: return DSTypography.caption(weight: weight)
        case .caption2: return DSTypography.caption2(weight: weight)
        case .callout: return DSTypography.callout(weight: weight)
        case .footnote: return DSTypography.footnote(weight: weight)
        }
    }

    private var color: Color {
        switch style {
        case .largeTitle,
             .title,
             .title2,
             .title3,
             .headline,
             .caption:
            return DSColors.primaryText
        case .subheadline,
             .body,
             .callout,
             .footnote,
             .caption2:
            return DSColors.secondaryText
        }
    }
}
