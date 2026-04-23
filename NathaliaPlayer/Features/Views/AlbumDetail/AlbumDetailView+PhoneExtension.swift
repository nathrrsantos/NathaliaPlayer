//
//  AlbumDetailView+PhoneExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/23/26.
//

import SwiftUI

// MARK: Phone
extension AlbumDetailView {

    func phoneAlbumHeader(album: AlbumModel) -> some View {
        VStack {
            DSImage(url: album.artworkURL,
                    imageSize: .large,
                    radius: DSRadius.xLarge)

            DSText(text: album.title, style: .title, weight: .bold)

            DSText(text: album.artist, style: .caption)
        }
    }
}
