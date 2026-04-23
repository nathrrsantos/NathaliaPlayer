//
//  PlayedSongsManagerTests.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import XCTest
import SwiftData
@testable import NathaliaPlayer

@MainActor
final class PlayedSongsManagerTests: XCTestCase {
    
    var container: ModelContainer!
    var playedSongsManager: PlayedSongsManager!
    
    override func setUp() async throws {
        try await super.setUp()
        
        // Create an in-memory container for testing
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: PersistedTrackModel.self, configurations: configuration)
        playedSongsManager = PlayedSongsManager(container: container)
    }
    
    override func tearDown() async throws {
        container = nil
        playedSongsManager = nil
        try await super.tearDown()
    }
    
    func testSaveAndLoadPlayedSongs() async throws {
        // Given
        let tracks = createMockTracks(count: 3)
        let currentIndex = 1
        
        // When
        playedSongsManager.savePlayedSongs(tracks, currentIndex: currentIndex)
        let result = playedSongsManager.loadPlayedSongs()
        
        // Then
        XCTAssertEqual(result.tracks.count, 3)
        XCTAssertEqual(result.currentIndex, currentIndex)
        XCTAssertEqual(result.tracks[0].id, tracks[0].id)
        XCTAssertEqual(result.tracks[1].id, tracks[1].id)
        XCTAssertEqual(result.tracks[2].id, tracks[2].id)
    }
    
    func testHasStoredPlayedSongs() async throws {
        // Given - initially empty
        XCTAssertFalse(playedSongsManager.hasStoredPlayedSongs())
        
        // When
        let tracks = createMockTracks(count: 1)
        playedSongsManager.savePlayedSongs(tracks)
        
        // Then
        XCTAssertTrue(playedSongsManager.hasStoredPlayedSongs())
    }
    
    func testUpdateLastPlayed() async throws {
        // Given
        let tracks = createMockTracks(count: 2)
        playedSongsManager.savePlayedSongs(tracks)
        
        // When
        let trackToUpdate = tracks[1]
        playedSongsManager.updateLastPlayed(track: trackToUpdate)
        
        // Then
        let result = playedSongsManager.loadPlayedSongs()
        XCTAssertEqual(result.currentIndex, 1) // Should now be the most recent
    }
    
    func testEmptyDatabase() async throws {
        // Given - empty database
        let result = playedSongsManager.loadPlayedSongs()
        
        // Then
        XCTAssertTrue(result.tracks.isEmpty)
        XCTAssertEqual(result.currentIndex, 0)
    }
    
    // MARK: - Helper Methods
    
    private func createMockTracks(count: Int) -> [TrackModel] {
        return (1...count).map { index in
            TrackModel(
                id: index,
                title: "Track \(index)",
                artist: "Artist \(index)",
                album: "Album \(index)",
                collectionId: index * 100,
                artworkURL: URL(string: "https://example.com/artwork\(index).jpg"),
                previewURL: URL(string: "https://example.com/preview\(index).mp3"),
                duration: 180.0 + Double(index),
                genre: "Pop"
            )
        }
    }
}