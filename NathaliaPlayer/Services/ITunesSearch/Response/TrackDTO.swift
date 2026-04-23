//
//  TrackDTO.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

struct TrackDTO: Decodable {
    let trackId: Int?
    let trackName: String?
    let artistName: String?
    let collectionName: String?
    let collectionId: Int?
    let previewUrl: String?
    let artworkUrl100: String?
    let releaseDate: String?
    let trackTimeMillis: Int?

    let primaryGenreName: String?
}

extension TrackDTO {
    func toDomain() -> TrackModel? {
        guard
            let id = trackId,
            let title = trackName,
            let artist = artistName
        else {
            return nil
        }

        return TrackModel(
            id: id,
            title: title,
            artist: artist,
            album: collectionName,
            collectionId: collectionId,
            artworkURL: URL(string: artworkUrl100 ?? ""),
            previewURL: URL(string: previewUrl ?? ""),
            duration: trackTimeMillis.map { TimeInterval($0) / 1000 },
            genre: primaryGenreName
        )
    }
}
