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

    private func makeSut() throws -> (manager: PlayedSongsManager, container: ModelContainer) {
        let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: PersistedTrackModel.self, configurations: configuration)
        let manager = PlayedSongsManager(container: container)
        return (manager, container)
    }

    func testSaveAndLoadPlayedSongs() async throws {
        let (playedSongsManager, _) = try makeSut()
        let tracks = createMockTracks(count: 3)
        let currentIndex = 0

        playedSongsManager.savePlayedSong(tracks[0])
        playedSongsManager.savePlayedSong(tracks[1])
        playedSongsManager.savePlayedSong(tracks[2])

        let result = playedSongsManager.loadPlayedSongs()

        XCTAssertEqual(result.tracks.count, 3)
        XCTAssertEqual(result.currentIndex, currentIndex)
        XCTAssertEqual(result.tracks[0].id, tracks[0].id)
        XCTAssertEqual(result.tracks[1].id, tracks[1].id)
        XCTAssertEqual(result.tracks[2].id, tracks[2].id)
    }

    func testHasStoredPlayedSongs() async throws {
        let (playedSongsManager, _) = try makeSut()

        XCTAssertFalse(playedSongsManager.hasStoredPlayedSongs())

        let tracks = createMockTracks(count: 1)
        playedSongsManager.savePlayedSong(tracks[0])

        XCTAssertTrue(playedSongsManager.hasStoredPlayedSongs())
    }

    func testEmptyDatabase() async throws {
        let (playedSongsManager, _) = try makeSut()

        let result = playedSongsManager.loadPlayedSongs()

        XCTAssertTrue(result.tracks.isEmpty)
        XCTAssertEqual(result.currentIndex, 0)
    }

    // MARK: - Helper Methods

    private func createMockTracks(count: Int) -> [TrackModel] {
        (1...count).map { index in
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
