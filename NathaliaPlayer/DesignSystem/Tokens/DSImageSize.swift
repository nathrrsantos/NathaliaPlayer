//
//  DSImageSize.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

enum DSImageSize {
    case xSmall
    case small
    case medium
    case large
    case xLarge

    struct Phone {
        static let xSmall: CGFloat = 16
        static let small: CGFloat = 20
        static let medium: CGFloat = 52
        static let large: CGFloat = 120
        static let xLarge: CGFloat = 264
    }

    struct Tablet {
        static let small: CGFloat = 52
        static let medium: CGFloat = 78
        static let large: CGFloat = 120
        static let xLarge: CGFloat = 286
    }

    func getSize(isTablet: Bool) -> CGFloat {
        switch self {
        case .xSmall: isTablet ? Tablet.small : Phone.xSmall
        case .small: isTablet ? Tablet.small : Phone.small
        case .medium: isTablet ? Tablet.medium : Phone.medium
        case .large: isTablet ? Tablet.large : Phone.large
        case .xLarge: isTablet ? Tablet.xLarge : Phone.xLarge
        }
    }
}
