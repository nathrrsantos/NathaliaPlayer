//
//  MockAlbumModel.swift
//  NathaliaPlayerTests
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import Foundation

/// Mock album data for testing purposes
struct MockAlbumModel {
    
    /// Creates a mock album with a specified number of tracks
    /// - Parameters:
    ///   - id: The album collection ID (default: 100)
    ///   - trackCount: The number of tracks to include (default: 5)
    /// - Returns: An AlbumModel instance with the specified tracks
    func createAlbum(id: Int = 100, trackCount: Int = 5) -> AlbumModel {
        let tracks = MockTrackModel().createMultiTracks(count: trackCount, collectionId: id)
        
        return AlbumModel(
            id: id,
            title: "Test Album",
            artist: "Test Artist",
            artworkURL: URL(string: "https://example.com/album-art.jpg"),
            tracks: tracks
        )
    }
    
    /// Standard album with 5 tracks for common testing scenarios
    var standardAlbum: AlbumModel {
        let tracks = MockTrackModel().createMultiTracks(count: 5)
        return AlbumModel(
            id: 100,
            title: "Test Album",
            artist: "Test Artist",
            artworkURL: URL(string: "https://example.com/album-art.jpg"),
            tracks: tracks
        )
    }
    
    /// Empty album with no tracks for edge case testing
    var emptyAlbum: AlbumModel {
        return AlbumModel(
            id: 300,
            title: "Empty Album",
            artist: "Test Artist",
            artworkURL: URL(string: "https://example.com/art.jpg"),
            tracks: []
        )
    }
    
    /// Album with custom artwork URL for testing URL preservation
    /// - Parameters:
    ///   - id: The album collection ID (default: 400)
    ///   - artworkURL: The custom artwork URL
    /// - Returns: An AlbumModel instance with custom artwork
    func createAlbumWithCustomArtwork(
        id: Int = 400,
        artworkURL: URL? = URL(string: "https://example.com/special-artwork.jpg")
    ) -> AlbumModel {
        let tracks = MockTrackModel().createMultiTracks(count: 3).map { track in
            TrackModel(
                id: track.id,
                title: track.title,
                artist: "Test Artist",
                album: "Custom Artwork Album",
                collectionId: id,
                artworkURL: track.artworkURL,
                previewURL: track.previewURL,
                duration: track.duration,
                genre: track.genre
            )
        }
        
        return AlbumModel(
            id: id,
            title: "Custom Artwork Album",
            artist: "Test Artist",
            artworkURL: artworkURL,
            tracks: tracks
        )
    }
}
