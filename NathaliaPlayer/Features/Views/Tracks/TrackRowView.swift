//
//  TrackRowView.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct TrackRowView: View {

    let track: TrackModel    
    let onMoreOptionsClick: (() -> Void)?

    var body: some View {
        HStack(spacing: DSSpacing.medium) {
            DSImage(url: track.artworkURL,
                    imageSize: .medium,
                    radius: DSRadius.medium)

            VStack(alignment: .leading, spacing: DSSpacing.xSmall) {
                DSText(text: track.title, style: .headline)

                DSText(text: track.artist, style: .subheadline)                
            }
            .frame(maxWidth: .infinity, alignment: .leading)

            if let onMoreOptionsClick {
                Spacer()
                
                if UIDevice.current.userInterfaceIdiom == .pad {
                    moreOptionsTablet(onClick: onMoreOptionsClick)
                } else {
                    moreOptionsPhone(onClick: onMoreOptionsClick)
                }
            }
        }
        .padding(.vertical, DSSpacing.xSmall)
    }
}
