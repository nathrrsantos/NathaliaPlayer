//
//  DSRowContainer.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct DSRowContainer<Content: View>: View {

    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        HStack(spacing: DSSpacing.medium) {
            content
        }
        .padding(.vertical, DSSpacing.xSmall)
    }
}
