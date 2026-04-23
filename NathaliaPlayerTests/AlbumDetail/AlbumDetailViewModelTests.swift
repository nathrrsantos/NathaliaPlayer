//
//  AlbumDetailViewModelTests.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import XCTest
@testable import NathaliaPlayer

// MARK: - Tests

@MainActor
final class AlbumDetailViewModelTests: XCTestCase {
    
    let albumMock = MockAlbumModel()
    
    // MARK: - Helper Methods
    
    /// Creates a System Under Test (SUT) with a mock service
    /// - Parameters:
    ///   - collectionId: The collection ID for the album (default: 100)
    ///   - mockAlbum: Optional album to return from the mock service
    ///   - shouldThrowError: Whether the mock service should throw errors (default: false)
    /// - Returns: A tuple containing the view model and the mock service for verification
    func makeSut(
        collectionId: Int = 100,
        mockAlbum: AlbumModel? = nil,
        shouldThrowError: Bool = false
    ) -> (viewModel: AlbumDetailViewModel, mockService: MockAlbumSearchService) {
        let mockService = MockAlbumSearchService()
        mockService.mockAlbum = mockAlbum
        mockService.shouldThrowError = shouldThrowError
        
        let serviceManager = MusicServiceManager(searchService: mockService)
        let viewModel = AlbumDetailViewModel(serviceManager: serviceManager, collectionId: collectionId)
        
        return (viewModel, mockService)
    }
    
    // MARK: - Initialization Tests
        
    func testInitialization() async throws {
        let (viewModel, _) = makeSut()
        
        XCTAssertNil(viewModel.album)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
        
    func testCollectionIdStored() async throws {
        let collectionId = 12345
        let (viewModel, mockService) = makeSut(collectionId: collectionId)
        
        // Fetch to verify the ID is used
        await viewModel.fetch()
        
        XCTAssertEqual(mockService.lastRequestedAlbumId, collectionId)
    }
    
    // MARK: - Fetch Tests
    
    func testFetchAlbumSuccess() async throws {
        let mockAlbum = albumMock.createAlbum(id: 100, trackCount: 10)
        let (viewModel, mockService) = makeSut(collectionId: 100, mockAlbum: mockAlbum)
        
        await viewModel.fetch()
        
        let album: AlbumModel = try XCTUnwrap(viewModel.album)
        XCTAssertEqual(album.id, 100)
        XCTAssertEqual(album.title, "Test Album")
        XCTAssertEqual(album.artist, "Test Artist")
        XCTAssertEqual(album.tracks.count, 10)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockService.fetchAlbumCallCount, 1)
    }
    
    func testFetchAlbumNotFound() async throws {
        let (viewModel, _) = makeSut(collectionId: 999, mockAlbum: nil)
        
        await viewModel.fetch()
        
        XCTAssertNil(viewModel.album)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Album not found")
    }
    
    func testFetchAlbumNetworkError() async throws {
        let (viewModel, _) = makeSut(shouldThrowError: true)
        
        await viewModel.fetch()
        
        XCTAssertNil(viewModel.album)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Failed to load album")
    }
    
    // MARK: - State Management Tests
    
    func testLoadingStateManagement() async throws {
        let (viewModel, _) = makeSut(mockAlbum: albumMock.standardAlbum)
        
        XCTAssertFalse(viewModel.isLoading)
        
        await viewModel.fetch()
        
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testErrorMessageClearsOnRetry() async throws {
        let (viewModel, mockService) = makeSut(shouldThrowError: true)
        
        // First fetch with error
        await viewModel.fetch()
        XCTAssertNotNil(viewModel.errorMessage)
        
        // Retry succeeds
        mockService.shouldThrowError = false
        mockService.mockAlbum = albumMock.standardAlbum
        await viewModel.fetch()
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertNotNil(viewModel.album)
    }
    
    // MARK: - Album Data Tests
    
    func testAlbumWithTracksLoadsCorrectly() async throws {
        let mockAlbum = albumMock.createAlbum(id: 200, trackCount: 15)
        let (viewModel, _) = makeSut(collectionId: 200, mockAlbum: mockAlbum)
        
        await viewModel.fetch()
        
        let album: AlbumModel = try XCTUnwrap(viewModel.album)
        XCTAssertEqual(album.tracks.count, 15)
        XCTAssertEqual(album.tracks[0].title, "Song 1")
        XCTAssertEqual(album.tracks[14].title, "Song 15")
        
        // Verify all tracks belong to the same album
        for track in album.tracks {
            XCTAssertEqual(track.collectionId, 200)
        }
    }
    
    func testAlbumWithEmptyTracksLoadsCorrectly() async throws {
        let (viewModel, _) = makeSut(collectionId: 300, mockAlbum: albumMock.emptyAlbum)
        
        await viewModel.fetch()
        
        let album: AlbumModel = try XCTUnwrap(viewModel.album)
        XCTAssertTrue(album.tracks.isEmpty)
        XCTAssertEqual(album.title, "Empty Album")
    }
    
    // MARK: - Multiple Fetch Tests
    
    func testMultipleFetchesUpdateAlbum() async throws {
        let (viewModel, mockService) = makeSut(
            collectionId: 100,
            mockAlbum: albumMock.createAlbum(id: 100, trackCount: 5)
        )
        
        // First fetch
        await viewModel.fetch()
        
        var album: AlbumModel = try XCTUnwrap(viewModel.album)
        XCTAssertEqual(album.tracks.count, 5)
        
        // Second fetch with different data
        mockService.mockAlbum = albumMock.createAlbum(id: 100, trackCount: 10)
        await viewModel.fetch()
        
        album = try XCTUnwrap(viewModel.album)
        XCTAssertEqual(album.tracks.count, 10)
        XCTAssertEqual(mockService.fetchAlbumCallCount, 2)
    }
    
    // MARK: - Edge Cases
    
    func testFetchWithInvalidCollectionId() async throws {
        let (viewModel, _) = makeSut(collectionId: -1, mockAlbum: nil)
        
        await viewModel.fetch()
        
        XCTAssertNil(viewModel.album)
        XCTAssertEqual(viewModel.errorMessage, "Album not found")
    }
    
    func testFetchWithZeroCollectionId() async throws {
        let (viewModel, mockService) = makeSut(collectionId: 0, mockAlbum: nil)
        
        await viewModel.fetch()
        
        XCTAssertNil(viewModel.album)
        XCTAssertEqual(mockService.lastRequestedAlbumId, 0)
    }
    
    func testAlbumArtworkURLPreserved() async throws {
        let artworkURL = URL(string: "https://example.com/special-artwork.jpg")
        let album = albumMock.createAlbumWithCustomArtwork(id: 400, artworkURL: artworkURL)
        let (viewModel, _) = makeSut(collectionId: 400, mockAlbum: album)
        
        await viewModel.fetch()
        
        let fetchedAlbum: AlbumModel = try XCTUnwrap(viewModel.album)
        XCTAssertEqual(fetchedAlbum.artworkURL, artworkURL)
    }
    
    func testServiceManagerDependency() async throws {
        let mockAlbum = albumMock.createAlbum(id: 500)
        let (viewModel, mockService) = makeSut(collectionId: 500, mockAlbum: mockAlbum)
        
        await viewModel.fetch()
        
        XCTAssertEqual(mockService.fetchAlbumCallCount, 1)
        XCTAssertEqual(mockService.lastRequestedAlbumId, 500)
        XCTAssertEqual(viewModel.album?.id, 500)
    }
}
