//
//  ViewAlbumOption.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/23/26.
//

import SwiftUI

struct ViewAlbumOption: View {

    let onClick: () -> Void

    var body: some View {
        Button {
            onClick()
        } label: {
            HStack(spacing: DSSpacing.small) {
                DSText(text: "View album", style: .title3)
                
                Spacer()

                Image(systemName: "chevron.right")                
            }
            .padding(.vertical, DSSpacing.medium)
        }
    }
}
