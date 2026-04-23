//
//  PlayedSongsManager.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import Foundation
import SwiftData

/// A manager class responsible for persisting and retrieving played songs using SwiftData.
///
/// This class provides functionality to save the current play queue when tracks are played
/// and retrieve previously played tracks when the app launches. It acts as a bridge between
/// the PlayerManager and SwiftData storage.
@MainActor
final class PlayedSongsManager: ObservableObject {
    
    private let modelContainer: ModelContainer
    private let modelContext: ModelContext
    
    /// Maximum number of played songs to keep in storage
    private let maxStoredSongs = 100
    
    /// Initializes the played songs manager with SwiftData container
    /// - Parameter container: The ModelContainer for SwiftData storage
    init(container: ModelContainer) {
        self.modelContainer = container
        self.modelContext = container.mainContext
    }
    
    /// Saves the current play queue to persistent storage
    /// - Parameters:
    ///   - tracks: Array of tracks currently in the play queue
    ///   - currentIndex: The index of the currently playing track
    func savePlayedSong(_ tracks: TrackModel) {
        // Clear existing played songs to avoid duplicates
        clearAllPlayedSongs()
        
        // Save the new queue with proper ordering
        for (index, track) in tracks.enumerated() {
            let persistedTrack = PersistedTrackModel(from: track, playOrder: index)
            
            // Mark the current track with recent timestamp
            if index == currentIndex {
                persistedTrack.lastPlayedDate = Date()
            }
            
            modelContext.insert(persistedTrack)
        }
        
        do {
            try modelContext.save()
        } catch {
            print("Failed to save played songs: \(error)")
        }
    }
    
    /// Loads previously played songs from persistent storage
    /// - Returns: A tuple containing the tracks array and the last current index
    func loadPlayedSongs() -> (tracks: [TrackModel], currentIndex: Int) {
        let fetchDescriptor = FetchDescriptor<PersistedTrackModel>(
            sortBy: [SortDescriptor(\.playOrder)]
        )
        
        do {
            let persistedTracks = try modelContext.fetch(fetchDescriptor)
            let tracks = persistedTracks.map { $0.toTrackModel() }
            
            // Find the last played track index (most recent lastPlayedDate)
            let currentIndex = findLastPlayedIndex(from: persistedTracks)
            
            return (tracks: tracks, currentIndex: currentIndex)
        } catch {
            print("Failed to load played songs: \(error)")
            return (tracks: [], currentIndex: 0)
        }
    }
    
    /// Checks if there are any played songs stored
    /// - Returns: True if played songs exist in storage, false otherwise
    func hasStoredPlayedSongs() -> Bool {
        let fetchDescriptor = FetchDescriptor<PersistedTrackModel>()
        fetchDescriptor.fetchLimit = 1
        
        do {
            let count = try modelContext.fetchCount(fetchDescriptor)
            return count > 0
        } catch {
            print("Failed to check for stored played songs: \(error)")
            return false
        }
    }
    
    /// Updates the last played timestamp for a specific track
    /// - Parameter track: The track that was just played
    func updateLastPlayed(track: TrackModel) {
        let predicate = #Predicate<PersistedTrackModel> { persistedTrack in
            persistedTrack.id == track.id
        }
        
        let fetchDescriptor = FetchDescriptor<PersistedTrackModel>(predicate: predicate)
        
        do {
            let results = try modelContext.fetch(fetchDescriptor)
            if let persistedTrack = results.first {
                persistedTrack.lastPlayedDate = Date()
                try modelContext.save()
            }
        } catch {
            print("Failed to update last played timestamp: \(error)")
        }
    }
    
    /// Clears all played songs from storage
    private func clearAllPlayedSongs() {
        let fetchDescriptor = FetchDescriptor<PersistedTrackModel>()
        
        do {
            let allTracks = try modelContext.fetch(fetchDescriptor)
            for track in allTracks {
                modelContext.delete(track)
            }
        } catch {
            print("Failed to clear played songs: \(error)")
        }
    }
    
    /// Finds the index of the last played track
    /// - Parameter persistedTracks: Array of persisted tracks sorted by play order
    /// - Returns: The index of the track with the most recent lastPlayedDate
    private func findLastPlayedIndex(from persistedTracks: [PersistedTrackModel]) -> Int {
        guard !persistedTracks.isEmpty else { return 0 }
        
        let mostRecentTrack = persistedTracks.max { track1, track2 in
            track1.lastPlayedDate < track2.lastPlayedDate
        }
        
        return mostRecentTrack?.playOrder ?? 0
    }
    
    /// Limits the number of stored songs to prevent database bloat
    private func limitStoredSongs() {
        let fetchDescriptor = FetchDescriptor<PersistedTrackModel>(
            sortBy: [SortDescriptor(\.lastPlayedDate, order: .reverse)]
        )
        
        do {
            let allTracks = try modelContext.fetch(fetchDescriptor)
            
            if allTracks.count > maxStoredSongs {
                let tracksToDelete = Array(allTracks.dropFirst(maxStoredSongs))
                
                for track in tracksToDelete {
                    modelContext.delete(track)
                }
                
                try modelContext.save()
            }
        } catch {
            print("Failed to limit stored songs: \(error)")
        }
    }
}
