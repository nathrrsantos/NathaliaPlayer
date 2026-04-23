//
//  MockTrackModel.swift
//  NathaliaPlayerTests
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import Foundation

/// Mock track data for testing purposes
struct MockTrackModel {
    
    /// Creates an array of mock tracks for testing
    /// - Parameter count: The number of mock tracks to create (default: 3)
    /// - Returns: An array of TrackModel instances
    func createMultiTracks(count: Int = 3, collectionId: Int? = nil) -> [TrackModel] {
        return (1...count).map { index in
            TrackModel(
                id: index,
                title: "Song \(index)",
                artist: "Artist \(index)",
                album: "Album \(index)",
                collectionId: collectionId ?? index * 100,
                artworkURL: URL(string: "https://example.com/art\(index).jpg"),
                previewURL: URL(string: "https://example.com/preview\(index).mp3"),
                duration: TimeInterval(180 + index * 20),
                genre: genres[index % genres.count]
            )
        }
    }
    
    private var trackPop: TrackModel {
        return TrackModel(
            id: 1,
            title: "Song 1",
            artist: "Artist 1",
            album: "Album 1",
            collectionId: 100,
            artworkURL: URL(string: "https://example.com/art1.jpg"),
            previewURL: URL(string: "https://example.com/preview1.mp3"),
            duration: 180,
            genre: "Pop"
        )
    }
    
    private var trackRock: TrackModel {
        return TrackModel(
            id: 2,
            title: "Song 2",
            artist: "Artist 2",
            album: "Album 2",
            collectionId: 200,
            artworkURL: URL(string: "https://example.com/art2.jpg"),
            previewURL: URL(string: "https://example.com/preview2.mp3"),
            duration: 200,
            genre: "Rock"
        )
    }
    
    private var trackJazz: TrackModel {
        return TrackModel(
            id: 3,
            title: "Song 3",
            artist: "Artist 3",
            album: "Album 3",
            collectionId: 300,
            artworkURL: URL(string: "https://example.com/art3.jpg"),
            previewURL: URL(string: "https://example.com/preview3.mp3"),
            duration: 220,
            genre: "Jazz"
        )
    }
    
    // MARK: - Private Helpers
    
    private let genres = ["Pop", "Rock", "Jazz", "Classical", "Electronic", "Hip-Hop"]
}
