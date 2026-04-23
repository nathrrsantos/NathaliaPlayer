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
enum RepeatMode {
    /// No repeat - playback stops when queue ends
    case off
    
    /// Repeat all - restart queue from beginning when it ends
    case all
    
    /// Repeat one - continuously repeat the current track
    case one
}
