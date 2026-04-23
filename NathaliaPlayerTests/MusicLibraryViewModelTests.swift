//
//  MusicLibraryViewModelTests.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/22/26.
//

import XCTest
import Foundation
@testable import NathaliaPlayer

// MARK: - Tests

@MainActor
final class MusicLibraryViewModelTests: XCTestCase {
    
    // MARK: - Test Data
    
    func makeSut(
        tracksCount: Int = 10,
        shouldThrowError: Bool = false
    ) -> (viewModel: MusicLibraryViewModel, mockService: MockSearchMusicService) {
        let mockService = MockSearchMusicService()
        mockService.mockTracks = tracksCount > 0 ? MockTrackModel().createMultiTracks(count: tracksCount) : []
        mockService.shouldThrowError = shouldThrowError
        
        let serviceManager = MusicServiceManager(searchService: mockService)
        
        return (MusicLibraryViewModel(serviceManager: serviceManager), mockService)
    }
    
    func createMockTracks(count: Int) -> [TrackModel] {
        MockTrackModel().createMultiTracks(count: count)
    }
    
    // MARK: - Initialization Tests
    
    func testInitialization() async throws {
        let (viewModel, _) = makeSut(tracksCount: 0)
        
        XCTAssertTrue(viewModel.tracks.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    // MARK: - Search Tests
    
    func testSearchSongsSuccess() async throws {
        let (viewModel, mockService) = makeSut()
        
        await viewModel.searchSongs(by: "test search")
        
        XCTAssertEqual(viewModel.tracks.count, 10)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(mockService.fetchTracksCallCount, 1)
        XCTAssertEqual(mockService.lastSearchText, "test search")
    }
    
    func testSearchSongsWithDefaultQuery() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 5)
        
        await viewModel.searchSongs()
        
        XCTAssertEqual(viewModel.tracks.count, 5)
        XCTAssertEqual(mockService.lastSearchText, "top hits")
    }
    
    func testSearchSongsError() async throws {
        let (viewModel, _) = makeSut(tracksCount: 0, shouldThrowError: true)
        
        await viewModel.searchSongs(by: "test")
        
        XCTAssertTrue(viewModel.tracks.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertEqual(viewModel.errorMessage, "Error while loading more songs")
    }
    
    func testSearchSongsClearsPreviousResults() async throws {
        let (viewModel, mockService) = makeSut()
        
        await viewModel.searchSongs(by: "first search")
        XCTAssertEqual(viewModel.tracks.count, 10)
        
        mockService.mockTracks = createMockTracks(count: 5)
        await viewModel.searchSongs(by: "second search")
        
        XCTAssertEqual(viewModel.tracks.count, 5)
        XCTAssertEqual(mockService.fetchTracksCallCount, 2)
    }
    
    // MARK: - Pagination Tests
    
    func testLoadMoreAppendsNewTracks() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 100)
        
        await viewModel.searchSongs(by: "test")
        XCTAssertEqual(viewModel.tracks.count, 50)
        
        await viewModel.loadMore()
        XCTAssertEqual(viewModel.tracks.count, 100)
        XCTAssertEqual(mockService.fetchTracksCallCount, 2)
        XCTAssertEqual(mockService.lastPage, 1)
    }
    
    func testLoadMoreStopsWhenNoMoreResults() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 40)
        
        await viewModel.searchSongs(by: "test")
        XCTAssertEqual(viewModel.tracks.count, 40)
        
        await viewModel.loadMore()
        XCTAssertEqual(viewModel.tracks.count, 40)
        XCTAssertEqual(mockService.fetchTracksCallCount, 1)
    }
    
    func testLoadMoreDoesNotTriggerWhenAlreadyLoading() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 100)
        
        let task1 = Task { @MainActor in await viewModel.searchSongs(by: "test") }
        let task2 = Task { @MainActor in await viewModel.loadMore() }
        await task1.value
        await task2.value
        
        XCTAssertGreaterThanOrEqual(mockService.fetchTracksCallCount, 1)
    }
    
    // MARK: - Duplicate Prevention Tests
    
    func testLoadMoreFiltersDuplicates() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 60)
        
        await viewModel.searchSongs(by: "test")
        let initialCount = viewModel.tracks.count
        
        await viewModel.loadMore()
        
        XCTAssertGreaterThanOrEqual(viewModel.tracks.count, initialCount)
    }
    
    // MARK: - State Management Tests
    
    func testLoadingStateManagement() async throws {
        let (viewModel, _) = makeSut()
        
        XCTAssertFalse(viewModel.isLoading)
        
        Task {
            await viewModel.searchSongs(by: "test")
        }
        
        try await Task.sleep(for: .milliseconds(10))
        
        await viewModel.searchSongs(by: "test")
        XCTAssertFalse(viewModel.isLoading)
    }
    
    func testErrorMessageClearsOnSuccess() async throws {
        let (viewModel, mockService) = makeSut(tracksCount: 0, shouldThrowError: true)
        
        await viewModel.searchSongs(by: "test")
        XCTAssertNotNil(viewModel.errorMessage)
        
        mockService.shouldThrowError = false
        mockService.mockTracks = createMockTracks(count: 5)
        await viewModel.searchSongs(by: "test")
        
        XCTAssertNil(viewModel.errorMessage)
        XCTAssertEqual(viewModel.tracks.count, 5)
    }
    
    // MARK: - Edge Cases
    
    func testEmptySearchResults() async throws {
        let (viewModel, _) = makeSut(tracksCount: 0)
        
        await viewModel.searchSongs(by: "nonexistent")
        
        XCTAssertTrue(viewModel.tracks.isEmpty)
        XCTAssertFalse(viewModel.isLoading)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    func testPaginationWithExactLimitBoundary() async throws {
        let (viewModel, _) = makeSut(tracksCount: 50)
        
        await viewModel.searchSongs(by: "test")
        
        XCTAssertEqual(viewModel.tracks.count, 50)
        
        await viewModel.loadMore()
        XCTAssertEqual(viewModel.tracks.count, 50)
    }
}
