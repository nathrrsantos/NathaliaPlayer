//
//  DSMoreButton.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct DSButton: View {

    enum Style {
        case primary
        case secondary
        case ghost
    }

    let title: String?
    let icon: String?
    let style: Style
    let color: Color?
    let isDisabled: Bool
    let isSystemIcon: Bool
    let action: () -> Void

    init(
        title: String? = nil,
        icon: String? = nil,
        style: Style = .primary,
        color: Color? = nil,
        isDisabled: Bool = false,
        isSystemIcon: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.color = color
        self.isDisabled = isDisabled
        self.isSystemIcon = isSystemIcon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            content
        }
        .buttonStyle(.plain)
        .padding(.horizontal, DSSpacing.medium)
        .padding(.vertical, DSSpacing.small)
        .background(backgroundColor)
        .foregroundColor(color ?? foregroundColor)
        .clipShape(RoundedRectangle(cornerRadius: DSRadius.small))
    }

    @ViewBuilder
    private var content: some View {
        HStack(spacing: DSSpacing.small) {
            if let icon {
                if isSystemIcon {
                    Image(systemName: icon)
                } else {
                    Image(icon)
                }
            }

            if let title {
                DSText(text: title, style: .title)
            }
        }        
    }

    private var backgroundColor: Color {
        switch style {
        case .primary:
            return isDisabled ? DSColors.disabled : DSColors.primaryBackground
        case .secondary:
            return DSColors.secondaryBackground
        case .ghost:
            return DSColors.ghostBackground
        }
    }

    private var foregroundColor: Color {
        switch style {
        case .primary:
            return DSColors.primaryTextOnPrimary
        case .secondary:
            return DSColors.primaryText
        case .ghost:
            return DSColors.accent
        }
    }
}
