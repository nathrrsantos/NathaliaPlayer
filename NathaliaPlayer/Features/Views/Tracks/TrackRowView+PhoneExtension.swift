//
//  TrackRowView+PhoneExtension.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/23/26.
//

import SwiftUI

// MARK: Phone

extension TrackRowView {

    func moreOptionsPhone(onClick: @escaping () -> Void) -> some View {
        DSButton(icon: "ellipsis",
                 style: .ghost,
                 isSystemIcon: true,
                 action: onClick)
            .buttonStyle(.plain)
            .contentShape(Rectangle())
            .frame(width: 60, height: 44)
    }
}
