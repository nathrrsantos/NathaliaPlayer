//
//  DSImage.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation
import SwiftUI

import SwiftUI

struct DSImage: View {

    @Environment(\.horizontalSizeClass) var horizontalSizeClass

    let url: URL?
    let imageSize: DSImageSize
    let radius: CGFloat

    private var size: CGFloat {
        imageSize.getSize(isTablet: horizontalSizeClass == .regular)
    }

    var body: some View {
        AsyncImage(url: url) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            DSColors.placeholder
        }
        .frame(width: size, height: size)
        .clipShape(RoundedRectangle(cornerRadius: radius))
    }
}
