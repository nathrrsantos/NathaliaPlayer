//
//  TrackPlayerView.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct TrackPlayerView: View {

    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject private var serviceManager: MusicServiceManager
    @StateObject var viewModel: TrackPlayerViewModel
    @State var showMoreOptionsSheet: Bool = false
    @State var selectedAlbumId: Int?

    private var isTablet: Bool {
        horizontalSizeClass == .regular
    }

    init(tracks: [TrackModel], startIndex: Int) {
        _viewModel = StateObject(
            wrappedValue: TrackPlayerViewModel(
                tracks: tracks,
                startIndex: startIndex
            )
        )
    }

    var body: some View {
        ZStack {
            if isTablet {
                tabletLayout
            } else {
                phoneLayout
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showMoreOptionsSheet) {
            bottomsheet
        }
        .navigationDestination(item: $selectedAlbumId) { id in
            AlbumDetailView(
                viewModel: AlbumDetailViewModel(
                    serviceManager: serviceManager,
                    collectionId: id
                )
            )
        }
    }
}

// MARK: UI Components
extension TrackPlayerView {

    @ViewBuilder
    var bottomsheet: some View {
        if let selectedTrack = viewModel.currentTrack {
            TrackOptionsSheet(track: selectedTrack) {
                if viewModel.isPlaying {
                    viewModel.togglePlay()
                }
                showMoreOptionsSheet = false
                selectedAlbumId = selectedTrack.collectionId
            }
            .presentationDetents([.height(150), .medium, .large])
            .presentationCompactAdaptation(.sheet)
        }
    }

    var header: some View {
        HStack {
            DSIconCircleButton(icon: "chevron.left",
                               size: .medium,
                               isSystemIcon: true) {
                viewModel.stop()
                dismiss()
            }

            Spacer()

            if UIDevice.current.userInterfaceIdiom == .pad {
                tabletMenu
            } else {
                phoneMenu
            }
        }
    }

    var artwork: some View {
        DSImage(url: viewModel.currentTrack?.artworkURL,
                imageSize: .xLarge,
                radius: DSRadius.xxLarge)
    }

    var trackInfo: some View {
        VStack(alignment: .leading, spacing: DSSpacing.xSmall) {
            HStack(alignment: .bottom) {
                if let track = viewModel.currentTrack {
                    VStack(alignment: .leading, spacing: DSSpacing.xSmall) {
                        DSText(text: track.title, style: .largeTitle)
                            .bold()

                        DSText(text: track.artist, style: .body)
                    }
                }

                Spacer()

                DSButton(icon: "ic-play-on-repeat",
                         style: .ghost,
                         color: repeatColor) {
                    viewModel.toggleRepeat()
                }
                .frame(width: 24, height: 24)
            }
        }
        .padding(.horizontal, DSSpacing.medium)
    }

    var progressBar: some View {
        VStack(spacing: DSSpacing.xSmall) {
            Slider(
                value: Binding(
                    get: { viewModel.progress },
                    set: { newValue in viewModel.seek(newValue) }
                )
            )
            .tint(DSColors.accent)

            HStack {
                DSText(text: viewModel.currentTimeText, style: .body)

                Spacer()

                DSText(text: viewModel.durationText, style: .body)
            }
        }
        .padding(.horizontal, DSSpacing.medium)
    }

    var controls: some View {
        HStack(spacing: DSSpacing.xLarge) {

            DSButton(icon: "ic-previous-fill", style: .ghost) {
                viewModel.previous()
            }

            let icon = viewModel.isPlaying ? "pause.fill" : "ic-play-fill"
            DSIconCircleButton(icon: icon,
                               size: .large,
                               isSystemIcon: viewModel.isPlaying) {
                viewModel.togglePlay()
            }

            DSButton(icon: "ic-forward-fill", style: .ghost) {
                viewModel.next()
            }
        }
    }

    private var repeatColor: Color {
        switch viewModel.repeatMode {
        case .off:
            return DSColors.secondaryText
        case .all:
            return DSColors.accent
        case .one:
            return .blue
        }
    }
}
