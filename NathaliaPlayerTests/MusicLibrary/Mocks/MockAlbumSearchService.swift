//
//  MockAlbumSearchService.swift
//  NathaliaPlayer
//
//  Created by Nathalia Regina Rodrigues dos Santos on 22/04/26.
//

import Foundation
@testable import NathaliaPlayer

final class MockAlbumSearchService: SearchMusicServiceProtocol, @unchecked Sendable {
    
    var shouldThrowError = false
    var mockAlbum: AlbumModel?
    var fetchAlbumCallCount = 0
    var lastRequestedAlbumId: Int?
    
    func fetchTracks(search: String, page: Int, limit: Int) async throws -> [TrackModel] {
        // Not used in AlbumDetailViewModel
        return []
    }
    
    func fetchAlbum(id: Int) async throws -> AlbumModel? {
        fetchAlbumCallCount += 1
        lastRequestedAlbumId = id
        
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        
        return mockAlbum
    }
}
