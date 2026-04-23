//
//  MusicLibraryViewModel.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation
import Combine

/// A view model responsible for managing the music library's state and interactions.
/// 
/// This view model handles music search functionality, track loading with pagination,
/// and error state management for the music library interface.
final class MusicLibraryViewModel: ObservableObject {

    // MARK: - State
    
    /// Array of tracks currently loaded in the library
    @Published var tracks: [TrackModel] = []
    
    /// Loading state indicator for UI updates
    @Published var isLoading = false
    
    /// Error message to display to the user when something goes wrong
    @Published var errorMessage: String?

    // MARK: - Pagination
    
    /// Current page number for pagination (starts from 0)
    private var currentPage = 0
    
    /// Number of items to fetch per page
    private let limit = 50
    
    /// Flag indicating if there are more items to load
    private var hasMore = true
    
    /// Current search query text
    private var searchText = ""

    // MARK: - Dependencies
    
    /// Service manager providing access to music-related services
    private let serviceManager: MusicServiceManager

    /// Initializes the view model with required dependencies
    /// - Parameter serviceManager: The service manager for music operations
    init(serviceManager: MusicServiceManager) {
        self.serviceManager = serviceManager
    }
    
    /// Loads initial songs when the app starts
    /// If there are saved played songs, load them; otherwise, load default songs
    @MainActor
    func loadInitialSongs(with manager: PlayedSongsManager) async -> Bool {
        if manager.hasStoredPlayedSongs() {
            defer {
                hasMore = false
                isLoading = false
            }
            
            isLoading = true
            // Load previously played songs
            let (tracks, currentIndex) = manager.loadPlayedSongs()
            if !tracks.isEmpty {
                self.tracks = tracks
                PlayerManager.shared.setQueue(tracks: tracks, startIndex: currentIndex)
                return true
            }
        }
        
        return false
    }

    // MARK: - Public Actions

    /// Searches for songs based on the provided text query
    /// 
    /// This method resets the current state and initiates a fresh search.
    /// It clears existing tracks, resets pagination, and starts loading the first page.
    /// 
    /// - Parameter text: The search query text. Defaults to "top hits" if not specified.
    @MainActor
    func searchSongs(by text: String = "top hits") async {
        currentPage = 0
        hasMore = true
        tracks = []
        searchText = text
        await loadMore()
    }

    /// Loads more tracks for the current search query
    /// 
    /// This method handles pagination by fetching the next page of results.
    /// It prevents duplicate loading operations and stops when no more results are available.
    /// Only unique tracks are added to avoid duplicates in the collection.
    @MainActor
    func loadMore() async {
        guard !isLoading, hasMore else { return }
        isLoading = true
        errorMessage = nil

        do {
            let newTracks = try await serviceManager.searchService.fetchTracks(search: searchText,
                                                                               page: currentPage,
                                                                               limit: limit)
            
            let uniqueTracks = newTracks.filter { !tracks.contains($0) }
            tracks.append(contentsOf: uniqueTracks)

            if newTracks.count < limit {
                hasMore = false
            } else {
                currentPage += 1
            }
        } catch {
            errorMessage = "Error while loading more songs"
        }

        isLoading = false
    }
}
