//
//  AlbumModel.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

struct AlbumModel: Identifiable {
    let id: Int
    let title: String
    let artist: String
    let artworkURL: URL?
    var tracks: [TrackModel]
}
