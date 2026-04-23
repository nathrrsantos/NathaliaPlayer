//
//  SearchMusicServiceProtocol.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

protocol SearchMusicServiceProtocol: Sendable {
    func fetchTracks(search: String, page: Int, limit: Int) async throws -> [TrackModel]
    func fetchAlbum(id: Int) async throws -> AlbumModel?
}
