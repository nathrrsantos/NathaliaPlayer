//
//  TrackPlayerView+PhoneExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Regina Rodrigues dos Santos on 22/04/26.
//

import SwiftUI

// MARK: Phone

extension TrackPlayerView {

    var phoneMenu: some View {
        DSIconCircleButton(icon: "ellipsis",
                           size: .medium,
                           isSystemIcon: true
        ) {
            showMoreOptionsSheet = true
        }
    }

    var phoneLayout: some View {
        ZStack {
            DSColors.primaryBackground.ignoresSafeArea()

            VStack(spacing: DSSpacing.large) {
                header
                Spacer()
                artwork
                Spacer()

                trackInfo
                progressBar
                controls

                Spacer(minLength: DSSpacing.large)
            }
            .padding(DSSpacing.medium)
        }
    }
}
