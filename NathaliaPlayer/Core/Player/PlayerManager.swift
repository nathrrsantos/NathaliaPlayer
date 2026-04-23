//
//  PlayerManager.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import AVFoundation
import Combine

#if !os(watchOS)
import WatchConnectivity
#endif

/// A singleton music player manager that provides comprehensive audio playback functionality.
///
/// `PlayerManager` serves as the central controller for music playback in the application,
/// managing audio tracks, playback state, and user interactions. It uses AVFoundation's
/// AVPlayer for audio playback and conforms to ObservableObject for SwiftUI integration.
///
/// ## Key Features
/// - **Queue Management**: Maintains a queue of tracks with current track tracking
/// - **Playback Control**: Play, pause, stop, seek, and navigation between tracks
/// - **Repeat Modes**: Support for no repeat, repeat all, and repeat one modes
/// - **Real-time Updates**: Publishes playback state changes for UI binding
/// - **Time Observation**: Tracks current playback time and duration
///
/// - Note: This class is designed as a singleton and should be accessed through `PlayerManager.shared`
/// - Important: Automatically handles track transitions and repeat behavior based on current repeat mode
@MainActor
final class PlayerManager: ObservableObject {

    static let shared = PlayerManager()

    private(set) var player: AVPlayer? = nil
    private var timeObserver: Any? = nil
    
    /// Reference to the played songs manager for persistence
    weak var playedSongsManager: PlayedSongsManager?

    // MARK: - Queue
    @Published private(set) var tracks: [TrackModel] = []
    @Published private(set) var currentIndex: Int = 0

    @Published private(set) var currentTrack: TrackModel?
    
    // Expose tracks count for sync
    var tracksCount: Int { tracks.count }

    // MARK: - Playback State
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 1
    @Published var repeatMode: RepeatMode = .off
    
    // MARK: - Queue Setup

    func setQueue(tracks: [TrackModel], startIndex: Int = 0) {
        self.tracks = tracks
        setNewTrack(index: startIndex)
    }

    // MARK: - Playback

    func setNewTrack(index: Int) {
        stop()

        currentIndex = index
        currentTrack = tracks[index]
    }

    func playCurrent() {
        guard let url = currentTrack?.previewURL else { return }
        play(url: url)
        
        // Save the updated state
        Task { @MainActor in
            playedSongsManager?.savePlayedSong(tracks[currentIndex])
        }
    }

    func play(url: URL) {
        stop()

        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)

        observeTime()
        player?.play()
        isPlaying = true
    }

    func togglePlayPause() {
        guard let player else { return }

        if player.timeControlStatus == .playing {
            player.pause()
            isPlaying = false
        } else {
            player.play()
            isPlaying = true
        }
    }

    func stop() {
        player?.pause()
        player = nil
        isPlaying = false
    }

    // MARK: - Navigation

    func next() {
        guard !tracks.isEmpty else { return }

        if currentIndex + 1 < tracks.count {
            currentIndex += 1
        } else {
            if repeatMode == .all {
                currentIndex = 0
            } else {
                stop()
                return
            }
        }

        updateCurrentTrack()
        playCurrent()
    }

    func previous() {
        if currentTime > 3 {
            seek(to: 0)
            return
        }

        if currentIndex > 0 {
            currentIndex -= 1
        } else {
            seek(to: 0)
            return
        }

        updateCurrentTrack()
        playCurrent()
    }

    private func updateCurrentTrack() {
        guard tracks.indices.contains(currentIndex) else { return }
        currentTrack = tracks[currentIndex]
    }

    // MARK: - Seek

    func seek(to value: Double) {
        let time = CMTime(seconds: value * duration, preferredTimescale: 600)
        player?.seek(to: time)
    }

    // MARK: - Repeat

    func toggleRepeatMode() {
        switch repeatMode {
        case .off: repeatMode = .all
        case .all: repeatMode = .one
        case .one: repeatMode = .off
        }
    }

    // MARK: - Time Observer

    private func observeTime() {
        guard let player else { return }

        let interval = CMTime(seconds: 0.5, preferredTimescale: 600)

        timeObserver = player.addPeriodicTimeObserver(
            forInterval: interval,
            queue: .main
        ) { [weak self] time in
            Task {
                guard let self else { return }
                
                await MainActor.run {
                    self.currentTime = time.seconds
                    
                    if let duration = player.currentItem?.duration.seconds,
                       duration.isFinite,
                       duration > 0 {
                        self.duration = duration
                    }
                    
                    if self.currentTime >= self.duration {
                        self.handleTrackFinished()
                    }
                }
            }
        }
    }

    // MARK: - Track Finished

    private func handleTrackFinished() {
        switch repeatMode {

        case .one:
            seek(to: 0)
            player?.play()

        case .all:
            next()

        case .off:
            if currentIndex + 1 < tracks.count {
                next()
            } else {
                stop()
            }
        }
    }
}
