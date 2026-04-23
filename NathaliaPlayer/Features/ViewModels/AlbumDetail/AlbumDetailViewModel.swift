//
//  AlbumDetailViewModel.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation
import Combine

/// A view model responsible for managing album detail information and loading state.
/// 
/// This view model handles fetching detailed album information from the music service,
/// including error handling and loading state management for the album detail interface.
final class AlbumDetailViewModel: ObservableObject {

    // MARK: - State
    
    /// The currently loaded album details, if available
    @Published var album: AlbumModel?
    
    /// Loading state indicator for UI updates
    @Published var isLoading = false
    
    /// Error message to display when album loading fails
    @Published var errorMessage: String?

    /// Service manager providing access to music-related services
    private let serviceManager: MusicServiceManager
    
    /// The collection ID of the album to fetch
    private let collectionId: Int

    /// Initializes the view model with required dependencies and album identifier
    /// - Parameters:
    ///   - serviceManager: The service manager for music operations
    ///   - collectionId: The unique identifier of the album to fetch
    init(serviceManager: MusicServiceManager, collectionId: Int) {
        self.serviceManager = serviceManager
        self.collectionId = collectionId
    }
    
    /// Fetches album details from the music service
    /// 
    /// This method loads the complete album information using the collection ID
    /// provided during initialization. It handles loading states and errors gracefully,
    /// preventing concurrent requests and providing appropriate error messages to the UI.
    @MainActor
    func fetch() async {
        guard !isLoading else { return }

        isLoading = true
        errorMessage = nil

        do {
            let result = try await serviceManager.searchService.fetchAlbum(id: collectionId)
            
            guard let album = result else {
                errorMessage = "Album not found"
                isLoading = false
                return
            }
            
            self.album = album
            self.isLoading = false
        } catch {
            errorMessage = "Failed to load album"
            isLoading = false
        }
    }
}
