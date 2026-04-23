//
//  TrackPlayerViewModelTests.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import XCTest
import Foundation
@testable import NathaliaPlayer

@MainActor
final class TrackPlayerViewModelTests: XCTestCase {
    
    // MARK: - Initialization Tests

    func makeSut(startIndex: Int = 0) -> TrackPlayerViewModel {
        let tracks = MockTrackModel().createMultiTracks(count: 3)
        return TrackPlayerViewModel(tracks: tracks, startIndex: startIndex)
    }
    
    func testInitialization() async throws {
        let viewModel = makeSut()
        
        XCTAssertEqual(viewModel.tracks.count, 3)
        XCTAssertEqual(viewModel.currentTrack?.id, 1)
        XCTAssertEqual(viewModel.currentTrack?.title, "Song 1")
    }
    
    func testInitializationWithFirstTrack() async throws {
        let viewModel = makeSut()
        
        XCTAssertEqual(viewModel.currentTrack?.id, 1)
        XCTAssertEqual(viewModel.currentTrack?.title, "Song 1")
    }
    
    // MARK: - Playback State Tests
    
    func testInitialPlaybackState() async throws {
        let viewModel = makeSut()
        
        // Note: The actual playing state depends on PlayerManager
        // These tests verify the binding works
        XCTAssertEqual(viewModel.progress, 0)
    }
    
    func testInitialRepeatMode() async throws {
        let viewModel = makeSut()
        
        XCTAssertEqual(viewModel.repeatMode, .off)
    }
    
    // MARK: - Track Selection Tests
    
    func testSelectNewTrack() async throws {
        let viewModel = makeSut()
        
        viewModel.selectNewTrack(index: 2)
        
        // Give some time for the player to update
        try await Task.sleep(for: .milliseconds(100))
        
        XCTAssertEqual(viewModel.currentTrack?.id, 3)
        XCTAssertEqual(viewModel.currentTrack?.title, "Song 3")
    }
    
    // MARK: - Time Formatting Tests
    
    func testCurrentTimeFormatting() async throws {
        let viewModel = makeSut()
        
        // The time formatting depends on the player's current state
        let timeText = viewModel.currentTimeText
        
        XCTAssertFalse(timeText.isEmpty)
        XCTAssertTrue(timeText.contains(":"))
    }
    
    func testDurationFormatting() async throws {        
        let viewModel = makeSut()
        let durationText = viewModel.durationText
        
        XCTAssertFalse(durationText.isEmpty)
        XCTAssertTrue(durationText.contains(":"))
    }
    
    // MARK: - Action Tests
    
    func testTogglePlay() async throws {
        let viewModel = makeSut()
        
        viewModel.togglePlay()
        
        // Verify the method executes without errors        
        XCTAssertTrue(PlayerManager.shared.isPlaying)
    }
    
    func testNextAction() async throws {
        let viewModel = makeSut()
        
        viewModel.next()
        
        // Give some time for the player to update
        try await Task.sleep(for: .milliseconds(100))
        
        // Verify the method executes without errors
        XCTAssertEqual(PlayerManager.shared.currentIndex, 1)
    }
    
    func testPreviousAction() async throws {
        let viewModel = makeSut(startIndex: 1)
        
        viewModel.previous()
        
        // Give some time for the player to update
        try await Task.sleep(for: .milliseconds(100))
        
        // Verify the method executes without errors
        XCTAssertEqual(PlayerManager.shared.currentIndex, 0)
    }
    
    func testSeekAction() async throws {
        let viewModel = makeSut()
        
        viewModel.seek(0.5)
        
        // Verify the method executes without errors
    }
    
    func testStopAction() async throws {
        let viewModel = makeSut()
        
        viewModel.stop()
        
        // Verify the method executes without errors
        XCTAssertNil(PlayerManager.shared.player)
        XCTAssertFalse(PlayerManager.shared.isPlaying)
    }
    
    func testToggleRepeat() async throws {
        let viewModel = makeSut()
        
        // Initial state should be .off
        XCTAssertEqual(viewModel.repeatMode, .off)
        
        viewModel.toggleRepeat()
        try await Task.sleep(for: .milliseconds(50))
        
        // Should cycle to .all
        XCTAssertEqual(viewModel.repeatMode, .all)
        
        viewModel.toggleRepeat()
        try await Task.sleep(for: .milliseconds(50))
        
        // Should cycle to .one
        XCTAssertEqual(viewModel.repeatMode, .one)
        
        viewModel.toggleRepeat()
        try await Task.sleep(for: .milliseconds(50))
        
        // Should cycle back to .off
        XCTAssertEqual(viewModel.repeatMode, .off)
    }
    
    // MARK: - Track List Tests
    
    func testTracksProperty() async throws {
        let viewModel = makeSut()
        
        XCTAssertEqual(viewModel.tracks.count, 3)
        XCTAssertEqual(viewModel.tracks[0].title, "Song 1")
        XCTAssertEqual(viewModel.tracks[1].title, "Song 2")
        XCTAssertEqual(viewModel.tracks[2].title, "Song 3")
    }
}
