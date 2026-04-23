//
//  AlbumDetailView+TabletExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/23/26.
//

import SwiftUI

// MARK: Tablet
extension AlbumDetailView {

    func tabletAlbumHeader(album: AlbumModel) -> some View {
        HStack(alignment: .top, spacing: DSSpacing.large) {
            DSImage(url: album.artworkURL,
                    imageSize: .large,
                    radius: DSRadius.xLarge)

            VStack(alignment: .leading) {
                DSText(text: album.title, style: .title, weight: .bold)
                    .bold()

                DSText(text: album.artist, style: .title2)
            }

            Spacer()
        }
    }
}
