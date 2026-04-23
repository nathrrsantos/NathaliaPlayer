//
//  ITunesSearchService.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

/// A concrete implementation of `SearchMusicServiceProtocol` that provides music search functionality using the iTunes Search API.
///
/// `ITunesSearchService` handles communication with Apple's iTunes Search API to fetch music tracks and album information.
/// It uses a network client to perform HTTP requests and transforms the API responses into domain models.
///
/// ## Key Features
/// - **Track Search**: Search for music tracks by term with pagination support
/// - **Album Lookup**: Fetch detailed album information including track listings by album ID
///
/// ## API Integration
/// This service interacts with the following iTunes Search API endpoints:
/// - `/search`: For searching music tracks with various filters
/// - `/lookup`: For fetching specific album details and track listings
final class ITunesSearchService: SearchMusicServiceProtocol {

    private let client: URLSessionNetworkClient

    init(client: URLSessionNetworkClient) {
        self.client = client
    }

    func fetchTracks(search: String, page: Int, limit: Int) async throws -> [TrackModel] {
        let endpoint = Endpoint(path: "/search",
                                method: .get,
                                headers: [:],
                                queryItems: [
                                    URLQueryItem(name: "term", value: search),
                                    URLQueryItem(name: "media", value: "music"),
                                    URLQueryItem(name: "entity", value: "song"),
                                    URLQueryItem(name: "limit", value: "\(limit)"),
                                    URLQueryItem(name: "offset", value: "\(page * limit)")],
                                body: nil)

        let response: ItunesTrackResponse = try await client.request(endpoint)
        return response.results.compactMap { $0.toDomain() }
    }

    func fetchAlbum(id: Int) async throws -> AlbumModel? {
        let endpoint = Endpoint(
            path: "/lookup",
            method: .get,
            headers: [:],
            queryItems: [
                URLQueryItem(name: "id", value: "\(id)"),
                URLQueryItem(name: "entity", value: "song")
            ],
            body: nil
        )

        let response: ITunesLookupResponse = try await client.request(endpoint)

        var album = response.results.compactMap { $0.toAlbumModel() }.first
        let tracks = response.results
            .filter { $0.wrapperType == "track" }
            .compactMap { $0.toTrackModel() }

        album?.tracks = tracks

        return album
    }
}
