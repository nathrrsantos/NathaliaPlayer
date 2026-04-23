//
//  DSIconCircleButton.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct DSIconCircleButton: View {

    let icon: String
    let size: DSButtonSize
    let isSystemIcon: Bool
    let action: () -> Void

    init(icon: String,
         size: DSButtonSize,
         isSystemIcon: Bool = false,
         action: @escaping () -> Void) {
        self.icon = icon
        self.size = size
        self.isSystemIcon = isSystemIcon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            image
                .frame(width: size.rawValue, height: size.rawValue)
                .foregroundColor(DSColors.primaryText)
                .padding(DSSpacing.small)
                .background(DSColors.secondaryBackground)
                .clipShape(Circle())
        }
    }

    private var image: Image {
        if isSystemIcon {
            Image(systemName: icon)
        } else {
            Image(icon)
        }
    }
}
