# NathaliaPlayer

NathaliaPlayer is a SwiftUI music player for iPhone and iPad. The app focuses on music discovery, album browsing, preview playback, and restoring the most recently played track history with SwiftData.

## Overview

- UI framework: SwiftUI
- Architectural style: MVVM with a small service layer
- Audio engine: `AVPlayer` through a shared `PlayerManager`
- Persistence: SwiftData
- Supported platforms in this repository: iPhone and iPad

## Architecture

The project is organized around feature modules, shared infrastructure, and a lightweight design system.

### Main flow

1. `NathaliaPlayerApp` creates the SwiftData `ModelContainer` and injects it into the app scene.
2. `ContentView` composes the app dependencies:
   - `URLSessionNetworkClient`
   - `ITunesSearchService`
   - `MusicServiceManager`
   - `PlayedSongsManager`
3. `MusicLibraryView` is the main entry screen. It restores persisted songs on launch, or loads a default search when there is no stored playback history.
4. Feature view models coordinate user actions and state updates:
   - `MusicLibraryViewModel` handles search, pagination, loading, and errors
   - `AlbumDetailViewModel` fetches album details
   - `TrackPlayerViewModel` binds the UI to playback state
5. `PlayerManager` is the shared playback engine responsible for queue management, progress updates, repeat mode, and track changes.

### Layer breakdown

#### App and composition

- `NathaliaPlayer/NathaliaPlayerApp.swift`
- `NathaliaPlayer/Features/Views/ContentView.swift`

This layer wires the container, root view, and shared dependencies.

#### Features

- `Features/MusicLibrary`
- `Features/Tracks`
- `Features/Player`
- `Features/AlbumDetail`
- `Features/Menus`

Each screen owns a focused view model and uses shared services instead of calling networking or persistence directly from the UI.

#### Services and networking

- `Services/ITunesSearch/ITunesSearchService.swift`
- `Core/Network`

The app uses protocol-based service access so view models depend on abstractions. The current concrete implementation talks to the iTunes Search API and maps DTOs into app models.

#### Playback core

- `Core/Player/PlayerManager.swift`

Playback responsibilities are centralized in `PlayerManager`, which exposes observable playback state to the player screen.

#### Persistence

- `Core/PersistentData/PersistedTrackModel.swift`
- `Core/PersistentData/PlayedSongsManager.swift`

SwiftData is isolated in a dedicated manager so storage details stay out of the feature views and view models.

## Design System

The app includes a small internal design system to keep spacing, typography, color, and reusable controls consistent across screens.

### Tokens

- `DSColors`: semantic colors for background, text, placeholders, accent, and disabled states
- `DSSpacing`: shared spacing scale from `xSmall` to `xxLarge`
- `DSRadius`: corner radius tokens
- `DSButtonSize`: icon/button sizing
- `DSImageSize`: image sizing rules
- `DSTypography`: font styles and device-aware sizing for phone vs. tablet

### Components

- `DSText`
- `DSButton`
- `DSIconCircleButton`
- `DSImage`
- `DSRowContainer`

These components help the feature layer stay visually consistent and avoid repeating styling details in every screen.

### Adaptive layout approach

Several screens have separate phone and tablet extensions, such as:

- `TrackPlayerView+PhoneExtension.swift`
- `TrackPlayerView+TabletExtension.swift`
- `AlbumDetailView+PhoneExtension.swift`
- `AlbumDetailView+TabletExtension.swift`
- `TrackRowView+PhoneExtension.swift`
- `TrackRowView+TabletExtension.swift`

This keeps a shared screen concept while allowing the iPad experience to diverge where needed.

## SwiftData

SwiftData is used for local playback restoration, not for full offline music catalog storage.

### What is stored

`PersistedTrackModel` stores the fields needed to rebuild a previously played track, including:

- track identity
- title and artist
- album and collection id
- artwork URL
- preview URL
- duration and genre
- last played date
- play order

### How it is used

- `NathaliaPlayerApp` creates a `ModelContainer` for `PersistedTrackModel`
- `PlayedSongsManager` reads and writes records through the main `ModelContext`
- When playback starts, `PlayerManager` asks `PlayedSongsManager` to persist the current track
- On launch, `MusicLibraryViewModel` restores saved tracks and rehydrates the queue before falling back to a fresh search

### Current persistence scope

- The app restores played songs locally
- The app tracks the last played item
- The app does not implement a broader library database, favorites system, or offline download storage

## Supported and Unsupported Platforms

### Implemented

- iPhone
- iPad

### Not implemented

- Apple Watch support is not implemented
- CarPlay support is not implemented

To make that explicit: this repository does not include a watchOS app target, Watch-specific UI flow, CarPlay scene configuration, or CarPlay templates. The conditional `WatchConnectivity` import in the player layer does not mean Apple Watch support is present in the product today.

## Testing

The repository includes:

- unit tests for view models and persistence helpers in `NathaliaPlayerTests`
- UI test targets in `NathaliaPlayerUITests`
