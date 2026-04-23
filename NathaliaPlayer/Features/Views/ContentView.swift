//
//  ContentView.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @Environment(\.modelContext) private var modelContext
    @ObservedObject private var viewModel: MusicLibraryViewModel
    @ObservedObject private var serviceManager: MusicServiceManager
    @StateObject private var playedSongsManager: PlayedSongsManager
    
    init() {
        let client = URLSessionNetworkClient(apiService: ITunesServiceConfig())
        let service = ITunesSearchService(client: client)
        let serviceManager = MusicServiceManager(searchService: service)
        
        self.serviceManager = serviceManager
        self.viewModel = MusicLibraryViewModel(serviceManager: serviceManager)
        
        // Initialize PlayedSongsManager - this will be properly set in onAppear
        self._playedSongsManager = StateObject(wrappedValue: PlayedSongsManager(
            container: try! ModelContainer(for: PersistedTrackModel.self)
        ))
    }

    var body: some View {
        MusicLibraryView(viewModel: viewModel)
            .environmentObject(serviceManager)
            .environmentObject(playedSongsManager)            
    }
}

#Preview {
    ContentView()
}
