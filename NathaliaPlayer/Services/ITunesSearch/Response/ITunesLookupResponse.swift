//
//  ITunesLookupResponse.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

struct ITunesLookupResponse: Decodable {
    let resultCount: Int
    let results: [ITunesLookupItem]
}
