//
//  MusicServiceManager.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation
import Combine

/// A centralized service manager that provides access to all music-related services.
/// 
/// This class acts as a dependency injection container and service locator for the music
/// functionality throughout the app. It maintains references to concrete implementations
/// of music services and can be easily configured for testing by injecting mock services.
/// 
/// The manager is designed to be observable to support reactive UI updates when service
/// configurations might change, though typically it remains stable throughout the app lifecycle.
final class MusicServiceManager: ObservableObject {

    // MARK: - Services
    
    /// Service responsible for searching and fetching music data from external APIs
    let searchService: SearchMusicServiceProtocol

    // MARK: - Init (Dependency Injection ready)
    
    /// Initializes the service manager with concrete service implementations
    /// 
    /// This initializer supports dependency injection, making it easy to provide
    /// different implementations for testing (mocks) or different environments.
    /// 
    /// - Parameter searchService: An implementation of the search service protocol
    init(searchService: SearchMusicServiceProtocol) {
        self.searchService = searchService
    }
}
