//
//  Track.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

/// A model representing a music track with all its essential properties.
/// 
/// This structure contains all the information needed to display and play a music track,
/// including metadata like title, artist, album information, and URLs for artwork and audio preview.
/// 
/// The model conforms to `Identifiable` for use in SwiftUI lists and `Hashable` for use in sets
/// and as dictionary keys, enabling efficient duplicate detection and collection operations.
struct TrackModel: Identifiable, Hashable {
    /// Unique identifier for the track
    let id: Int
    
    /// The track's title/name
    let title: String
    
    /// The artist or band name
    let artist: String
    
    /// The album name (optional, as singles might not have an album)
    let album: String?
    
    /// The unique identifier of the album/collection this track belongs to
    let collectionId: Int?
    
    /// URL for the track's artwork/cover image
    let artworkURL: URL?
    
    /// URL for a preview/sample of the track audio
    let previewURL: URL?
    
    /// Duration of the track in seconds
    let duration: TimeInterval?
    
    /// Musical genre classification
    let genre: String?
}
