//
//  TrackPlayerViewModel.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI
import Combine

/// A view model that manages the state and behavior of the track player interface.
/// 
/// This view model acts as a bridge between the UI and the PlayerManager singleton,
/// providing reactive state updates and user interaction methods for music playback control.
/// It handles playback state, progress tracking, queue management, and repeat modes.
@MainActor
final class TrackPlayerViewModel: ObservableObject {

    /// Shared instance of the player manager
    private let player = PlayerManager.shared
    
    /// Set to store Combine subscriptions for automatic cleanup
    private var cancellables = Set<AnyCancellable>()

    // MARK: - UI State
    
    /// Current playback state (playing/paused)
    @Published var isPlaying = false
    
    /// Playback progress as a value between 0.0 and 1.0
    @Published var progress: Double = 0
    
    /// Currently playing track, if any
    @Published var currentTrack: TrackModel?
    
    /// Current repeat mode setting
    @Published var repeatMode: RepeatMode = .off

    /// Array of all tracks in the current queue
    let tracks: [TrackModel]

    // MARK: - Init

    /// Initializes the view model with a track queue and starting position
    /// 
    /// Sets up the player queue, selects the initial track, and establishes
    /// reactive bindings to keep the UI in sync with the player state.
    /// 
    /// - Parameters:
    ///   - tracks: Array of tracks to be played
    ///   - startIndex: Index of the track to start playing (default: 0)
    init(tracks: [TrackModel], startIndex: Int) {
        player.setQueue(tracks: tracks, startIndex: startIndex)
        player.playCurrent()
        currentTrack = tracks[startIndex]
        
        self.tracks = tracks

        bindPlayer()
    }

    // MARK: - Bind

    /// Establishes reactive bindings between the PlayerManager and UI state
    /// 
    /// This method sets up Combine publishers to automatically update the view model's
    /// published properties when the underlying player state changes, ensuring the UI
    /// stays synchronized with the actual playback state.
    private func bindPlayer() {
        player.$isPlaying
            .assign(to: &$isPlaying)

        player.$currentTrack
            .assign(to: &$currentTrack)

        player.$repeatMode
            .assign(to: &$repeatMode)

        player.$currentTime
            .combineLatest(player.$duration)
            .map { current, duration in
                guard duration > 0 else { return 0 }
                return current / duration
            }
            .assign(to: &$progress)
    }

    // MARK: - Actions

    /// Toggles between play and pause states
    func togglePlay() {
        player.togglePlayPause()
    }

    /// Advances to the next track in the queue
    func next() {
        player.next()
    }

    /// Goes back to the previous track in the queue
    func previous() {
        player.previous()
    }

    /// Seeks to a specific position in the current track
    /// - Parameter value: Position as a percentage (0.0 to 1.0) of the track's duration
    func seek(_ value: Double) {
        player.seek(to: value)
    }

    /// Stops playback completely
    func stop() {
        player.stop()
    }

    /// Selects and starts playing a specific track from the queue
    /// - Parameter index: Index of the track to play in the tracks array
    func selectNewTrack(index: Int) {
        player.setNewTrack(index: index)
        player.playCurrent()
    }

    /// Cycles through repeat modes (off, single, all)
    func toggleRepeat() {
        player.toggleRepeatMode()
    }

    // MARK: - Time

    /// Formatted string representation of the current playback time
    var currentTimeText: String {
        player.currentTime.toTimeString()
    }

    /// Formatted string representation of the track's total duration
    var durationText: String {
        player.duration.toTimeString()
    }
}
