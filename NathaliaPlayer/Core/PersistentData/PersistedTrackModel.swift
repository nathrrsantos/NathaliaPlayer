//
//  PersistedTrackModel.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import Foundation
import SwiftData

/// A SwiftData model for persisting played tracks to local storage.
///
/// This model represents a track that has been played and should be persisted
/// for future app launches. It mirrors the TrackModel structure but is designed
/// for database storage with SwiftData.
@Model
final class PersistedTrackModel {
    /// Unique identifier for the track
    var id: Int
    
    /// The track's title/name
    var title: String
    
    /// The artist or band name
    var artist: String
    
    /// The album name (optional, as singles might not have an album)
    var album: String?
    
    /// The unique identifier of the album/collection this track belongs to
    var collectionId: Int?
    
    /// URL string for the track's artwork/cover image
    var artworkURLString: String?
    
    /// URL string for a preview/sample of the track audio
    var previewURLString: String?
    
    /// Duration of the track in seconds
    var duration: TimeInterval?
    
    /// Musical genre classification
    var genre: String?
    
    /// Timestamp when this track was last played
    var lastPlayedDate: Date
    
    /// Order of the track in the play queue (for maintaining queue order)
    var playOrder: Int
    
    /// Initializes a new persisted track model
    /// - Parameters:
    ///   - id: Unique track identifier
    ///   - title: Track title
    ///   - artist: Artist name
    ///   - album: Album name (optional)
    ///   - collectionId: Collection/album identifier (optional)
    ///   - artworkURLString: Artwork URL as string (optional)
    ///   - previewURLString: Preview URL as string (optional)
    ///   - duration: Track duration in seconds (optional)
    ///   - genre: Musical genre (optional)
    ///   - lastPlayedDate: When the track was last played
    ///   - playOrder: Order in the play queue
    init(
        id: Int,
        title: String,
        artist: String,
        album: String? = nil,
        collectionId: Int? = nil,
        artworkURLString: String? = nil,
        previewURLString: String? = nil,
        duration: TimeInterval? = nil,
        genre: String? = nil,
        lastPlayedDate: Date = Date(),
        playOrder: Int = 0
    ) {
        self.id = id
        self.title = title
        self.artist = artist
        self.album = album
        self.collectionId = collectionId
        self.artworkURLString = artworkURLString
        self.previewURLString = previewURLString
        self.duration = duration
        self.genre = genre
        self.lastPlayedDate = lastPlayedDate
        self.playOrder = playOrder
    }
    
    /// Convenience initializer from TrackModel
    /// - Parameters:
    ///   - trackModel: The TrackModel to convert
    ///   - playOrder: Order in the play queue
    convenience init(from trackModel: TrackModel, playOrder: Int = 0) {
        self.init(
            id: trackModel.id,
            title: trackModel.title,
            artist: trackModel.artist,
            album: trackModel.album,
            collectionId: trackModel.collectionId,
            artworkURLString: trackModel.artworkURL?.absoluteString,
            previewURLString: trackModel.previewURL?.absoluteString,
            duration: trackModel.duration,
            genre: trackModel.genre,
            playOrder: playOrder
        )
    }
}

// MARK: - TrackModel Conversion
extension PersistedTrackModel {
    /// Converts this persisted model back to a TrackModel
    /// - Returns: A TrackModel instance with the same data
    func toTrackModel() -> TrackModel {
        return TrackModel(
            id: id,
            title: title,
            artist: artist,
            album: album,
            collectionId: collectionId,
            artworkURL: artworkURLString.flatMap { URL(string: $0) },
            previewURL: previewURLString.flatMap { URL(string: $0) },
            duration: duration,
            genre: genre
        )
    }
}
