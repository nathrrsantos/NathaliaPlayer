//
//  TrackRowView+TabletExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/23/26.
//

import SwiftUI

extension TrackRowView {

    @ViewBuilder
    func moreOptionsTablet(onClick: @escaping () -> Void) -> some View {
        Menu {
            ViewAlbumOption {
                onClick()
            }
        } label: {
            DSButton(icon: "ellipsis",
                     style: .ghost,
                     isSystemIcon: true,
                     action: {})
                .buttonStyle(.plain)
                .contentShape(Rectangle())
                .frame(width: 60, height: 44)
        }
    }
}
