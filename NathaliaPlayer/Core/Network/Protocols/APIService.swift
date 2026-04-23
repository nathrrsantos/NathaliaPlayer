//
//  APIService.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import Foundation

protocol APIService: Sendable {
    var baseURL: URL { get }
    var defaultHeaders: [String: String] { get }
}
