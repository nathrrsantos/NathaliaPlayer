//
//  MockSearchMusicService.swift
//  NathaliaPlayer
//
//  Created by Nathalia Regina Rodrigues dos Santos on 22/04/26.
//

import Foundation
@testable import NathaliaPlayer

final class MockSearchMusicService: SearchMusicServiceProtocol, @unchecked Sendable {
    
    var shouldThrowError = false
    var mockTracks: [TrackModel] = []
    var mockAlbum: AlbumModel?
    
    var fetchTracksCallCount = 0
    var lastSearchText: String?
    var lastPage: Int?
    var lastLimit: Int?
    
    func fetchTracks(search: String, page: Int, limit: Int) async throws -> [TrackModel] {
        fetchTracksCallCount += 1
        lastSearchText = search
        lastPage = page
        lastLimit = limit
        
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        
        // Simulate pagination
        let start = page * limit
        let end = min(start + limit, mockTracks.count)
        
        guard start < mockTracks.count else {
            return []
        }
        
        return Array(mockTracks[start..<end])
    }
    
    func fetchAlbum(id: Int) async throws -> AlbumModel? {
        if shouldThrowError {
            throw NSError(domain: "TestError", code: -1, userInfo: nil)
        }
        return mockAlbum
    }
}
