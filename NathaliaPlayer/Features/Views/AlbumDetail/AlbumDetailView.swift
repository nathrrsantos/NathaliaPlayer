//
//  AlbumDetailView.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct AlbumDetailView: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) private var dismiss
    @StateObject var viewModel: AlbumDetailViewModel

    var body: some View {
        ZStack {
            DSColors.primaryBackground.ignoresSafeArea()

            VStack(spacing: DSSpacing.large) {
                header
                content
            }
        }
        .task {
            await viewModel.fetch()
        }
        .navigationBarBackButtonHidden()
    }

    @ViewBuilder
    var content: some View {
        if let album = viewModel.album {
            ScrollView {
                LazyVStack(spacing: DSSpacing.large) {
                    albumView(album: album)
                }
                .padding(.horizontal, DSSpacing.medium)
            }
        } else if viewModel.isLoading {
            ProgressView()
                .frame(maxHeight: .infinity)

        } else if let error = viewModel.errorMessage {
            VStack(spacing: DSSpacing.medium) {
                DSText(text: error, style: .headline)

                DSButton(title: "Try again", style: .ghost) {
                    Task { await viewModel.fetch() }
                }
            }
            .frame(maxHeight: .infinity)
        }

        Spacer()
    }
}

// MARK: UI Components
extension AlbumDetailView {

    func albumView(album: AlbumModel) -> some View {
        VStack(spacing: DSSpacing.large) {
            albumHeader(album: album)
                .padding(.vertical, DSSpacing.xxLarge)

            ForEach(album.tracks) { track in
                TrackRowView(track: track, onMoreOptionsClick: nil)
            }
        }
    }

    @ViewBuilder
    func albumHeader(album: AlbumModel) -> some View {
        if horizontalSizeClass == .regular {
            tabletAlbumHeader(album: album)
        } else {
            phoneAlbumHeader(album: album)
        }
    }

    @ViewBuilder
    func albumInfo(with album: AlbumModel) -> some View {
        DSImage(url: album.artworkURL,
                imageSize: .large,
                radius: DSRadius.xLarge)

        DSText(text: album.title, style: .title)
            .bold()

        DSText(text: album.artist, style: .title2)
    }

    var header: some View {
        HStack {
            DSIconCircleButton(icon: "chevron.left",
                               size: .medium,
                               isSystemIcon: true) {
                dismiss()
            }

            Spacer()
        }
        .padding(.horizontal, DSSpacing.medium)
    }
}
