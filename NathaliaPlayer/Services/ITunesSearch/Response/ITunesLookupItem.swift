//
//  ITunesLookupItem.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

struct ITunesLookupItem: Decodable {
    let wrapperType: String

    // Album
    let collectionId: Int?
    let collectionName: String?
    let artistName: String?
    let artworkUrl100: String?

    // Track
    let trackId: Int?
    let trackName: String?
    let previewUrl: String?
    let trackTimeMillis: Int?
    let genre: String?
}

extension ITunesLookupItem {

    func toAlbumModel() -> AlbumModel? {
        guard wrapperType == "collection",
              let id = collectionId else {
            return nil
        }

        return AlbumModel(
            id: id,
            title: collectionName ?? "",
            artist: artistName ?? "",
            artworkURL: URL(string: artworkUrl100 ?? ""),
            tracks: []
        )
    }

    func toTrackModel() -> TrackModel? {
        print("TEST - TENTA RETORNAR TRACK")
        guard wrapperType == "track",
              let id = trackId,
              let name = trackName,
              let artist = artistName else {
            return nil
        }

        print("TEST - VAI RETORNAR TRACK")

        return TrackModel(
            id: id,
            title: name,
            artist: artist,
            album: collectionName,
            collectionId: collectionId,
            artworkURL: URL(string: artworkUrl100 ?? ""),
            previewURL: URL(string: previewUrl ?? ""),
            duration: Double(trackTimeMillis ?? 0) / 1000,
            genre: genre
        )
    }
}
