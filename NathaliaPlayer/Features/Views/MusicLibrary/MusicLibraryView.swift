//
//  MusicLibraryView.swift
//  NathaliaPlayer
//
//  Created by Nathalia Rodrigues on 4/18/26.
//

import SwiftUI

struct MusicLibraryView: View {

    @EnvironmentObject private var serviceManager: MusicServiceManager
    @EnvironmentObject private var playedSongsManager: PlayedSongsManager
    @StateObject private var viewModel: MusicLibraryViewModel
    @State private var searchText: String = ""
    @State private var selectedTrack: TrackModel?
    @State private var selectedAlbumId: Int?

    init(viewModel: MusicLibraryViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Songs")
                .task {
                    PlayerManager.shared.playedSongsManager = playedSongsManager
                    
                    if viewModel.tracks.isEmpty {
                        let loaded = await viewModel.loadInitialSongs(with: playedSongsManager)
                        
                        if !loaded {
                            await viewModel.searchSongs()
                        }
                    }
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.tracks.isEmpty {            
            ProgressView()
                .frame(maxHeight: .infinity)
        } else if let error = viewModel.errorMessage {
            VStack(spacing: DSSpacing.medium) {
                Text(error)
                Button("Try again") {
                    Task { await viewModel.searchSongs() }
                }
            }
        } else {
            listView
                .searchable(text: $searchText,
                            placement: .navigationBarDrawer,
                            prompt: "Search")
                .onSubmit(of: .search) {
                    Task {
                        await viewModel.searchSongs(by: searchText)
                    }
                }
        }
    }

    private var listView: some View {
        List {
            ForEach(Array(viewModel.tracks.enumerated()), id: \.offset) { index, track in
                trackRow(with: track, and: index)
            }

            listLoading
        }
        .listStyle(.plain)
        .refreshable {
            await viewModel.searchSongs()
        }
        .sheet(item: $selectedTrack) { track in
            bottomsheet(with: track)
        }
        .navigationDestination(item: $selectedAlbumId) { id in
            AlbumDetailView(
                viewModel: AlbumDetailViewModel(
                    serviceManager: serviceManager,
                    collectionId: id
                )
            )
        }
    }

    private func trackRow(with track: TrackModel, and index: Int) -> some View {
        ZStack(alignment: .leading) {
            NavigationLink(destination: TrackPlayerView(tracks: viewModel.tracks, startIndex: index)) {
                EmptyView()
            }
            .opacity(0)

            TrackRowView(track: track) {
                onMoreOptionsClick(track: track)
            }
        }
        .listRowSeparator(.hidden)
        .listRowInsets(EdgeInsets(top: DSSpacing.small,
                                  leading: DSSpacing.large,
                                  bottom: 0,
                                  trailing: 0))
        .onAppear {
            if track.id == viewModel.tracks.last?.id {
                Task {
                    await viewModel.loadMore()
                }
            }
        }
    }

    // Show loading when the view model is searching for more tracks - pagination
    @ViewBuilder
    private var listLoading: some View {
        if viewModel.isLoading {
            HStack {
                Spacer()
                ProgressView()
                Spacer()
            }
        }
    }

    private func bottomsheet(with track: TrackModel) -> some View {
        TrackOptionsSheet(track: track) {
            selectedTrack = nil
            selectedAlbumId = track.collectionId
        }
        .presentationDetents([.height(150), .medium])
        .presentationDragIndicator(.visible)
    }

    private func onMoreOptionsClick(track: TrackModel) {
        if UIDevice.current.userInterfaceIdiom == .pad {
            selectedAlbumId = track.collectionId
        } else {
            selectedTrack = track
        }
    }
}
