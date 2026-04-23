//
//  TrackPlayerView+TabletExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Regina Rodrigues dos Santos on 22/04/26.
//

import SwiftUI

extension TrackPlayerView {

    private var listWidth: CGFloat {
        UIScreen.main.bounds.width * 0.25
    }

    @ViewBuilder
    var tabletMenu: some View {
        Menu {
            ViewAlbumOption {
                selectedAlbumId = viewModel.currentTrack?.collectionId
            }
        } label: {
            DSIconCircleButton(icon: "ellipsis",
                               size: .medium,
                               isSystemIcon: true,
                               action: {}
            )
        }
    }

    var tabletLayout: some View {
        HStack(spacing: DSSpacing.large) {
            VStack(spacing: DSSpacing.large) {
                header

                Spacer()

                artwork

                Spacer()
                
                trackInfo
                progressBar
                controls
            }
            .frame(maxWidth: .infinity)

            listView
                .frame(width: listWidth)
        }
        .padding(DSSpacing.large)
    }

    var listView: some View {
        VStack(alignment: .leading, spacing: DSSpacing.medium) {

            Image(systemName: "music.note.list")
                .foregroundColor(DSColors.primaryText)

            ScrollView {
                LazyVStack(spacing: DSSpacing.medium) {
                    ForEach(Array(viewModel.tracks.enumerated()), id: \.offset) { index, track in
                        TrackRowView(track: track, onMoreOptionsClick: nil)
                            .onTapGesture {
                                viewModel.selectNewTrack(index: index)
                            }
                    }
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: DSRadius.large)
                .fill(DSColors.secondaryBackground)
        )
    }
}
