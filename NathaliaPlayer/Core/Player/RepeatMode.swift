//
//  RepeatMode.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import Foundation

/// Enumeration representing different repeat modes for music playback.
///
/// This enum defines the possible repeat behaviors that can be applied to a music queue,
/// affecting how tracks are played when the queue reaches its end or when a single track finishes.
enum RepeatMode: String, CaseIterable, Codable {
    /// No repeat - playback stops when queue ends
    case off = "off"
    
    /// Repeat all - restart queue from beginning when it ends
    case all = "all"
    
    /// Repeat one - continuously repeat the current track
    case one = "one"
    
    /// Human-readable description of the repeat mode
    var description: String {
        switch self {
        case .off:
            return "Off"
        case .all:
            return "Repeat All"
        case .one:
            return "Repeat One"
        }
    }
    
    /// SF Symbol icon name for the repeat mode
    var iconName: String {
        switch self {
        case .off:
            return "repeat"
        case .all:
            return "repeat.1"
        case .one:
            return "repeat.1"
        }
    }
}
