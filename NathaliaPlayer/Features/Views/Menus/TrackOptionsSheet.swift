//
//  TrackOptionsSheet.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct TrackOptionsSheet: View {

    let track: TrackModel
    let albumOnClick: () -> Void

    var body: some View {
        VStack(spacing: DSSpacing.medium) {
            // MARK: - Header (title + artist)
            VStack(spacing: DSSpacing.xSmall) {
                DSText(text: track.title, style: .title3, weight: .bold)                    

                DSText(text: track.artist, style: .caption)
            }
            .multilineTextAlignment(.center)

            // MARK: - Action
            Button {
                albumOnClick()
            } label: {
                HStack(spacing: DSSpacing.small) {
                    Image(systemName: "music.note.list")                    

                    DSText(text: "View album", style: .title3)

                    Spacer()
                }
                .padding(.vertical, DSSpacing.medium)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, DSSpacing.large)
        .frame(maxWidth: .infinity)
    }
}
