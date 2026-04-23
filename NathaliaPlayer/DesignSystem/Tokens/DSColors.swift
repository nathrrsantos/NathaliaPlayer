//
//  DSColors.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

enum DSColors {
    // Backgrounds
    static let primaryBackground = Color(.systemBackground)
    static let secondaryBackground = Color.gray.opacity(0.15)
    static let ghostBackground = Color.clear

    // Text
    static let primaryTextOnPrimary = Color.white
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary.opacity(0.7)
    static let accent = Color.primary.opacity(0.7)

    // Image
    static let placeholder = Color.gray.opacity(0.2)

    // States
    static let disabled = Color.gray.opacity(0.4)
}
