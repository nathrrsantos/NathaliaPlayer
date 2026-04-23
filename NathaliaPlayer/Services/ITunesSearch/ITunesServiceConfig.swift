//
//  ITunesServiceConfig.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

struct ITunesServiceConfig: APIService {
    var baseURL: URL {
        URL(string: "https://itunes.apple.com")!
    }

    var defaultHeaders: [String: String] {
        [:]
    }
}
