//
//  SearchViewModel.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 24.05.25.
//

import Foundation
import SwiftUI

@MainActor
@Observable
final class SearchViewModel: ObservableObject {
    private var unsplashService: UnsplashServiceProtocol

    var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }

    var photos: [Photo] = []
    var isLoading = false
    var loadFailed = false

    private var currentPage = 1
    private let perPage = 20

    private var searchTask: Task<Void, Never>? = nil

    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
    }

    func loadInitialPhotos() async {
        isLoading = true
        loadFailed = false
        currentPage = 1

        do {
            let results = try await unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
            photos = results
        } catch {
            print("Failed to load initial photos: \(error)")
            loadFailed = true
            photos = []
        }

        isLoading = false
    }

    private func debounceSearch() {
        searchTask?.cancel()
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await performSearch(reset: true)
        }
    }

    func performSearch(reset: Bool = false) async {
        if reset {
            currentPage = 1
        }

        guard !searchText.isEmpty else {
            await loadInitialPhotos()
            return
        }

        isLoading = true
        loadFailed = false

        do {
            let results = try await unsplashService.searchPhotos(query: searchText, page: currentPage, perPage: perPage)
            if reset {
                photos = results
            } else {
                photos += results
            }
        } catch {
            print("Search failed: \(error)")
            loadFailed = true
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentPhoto: Photo) {
        guard !isLoading, !loadFailed else { return }
        if let last = photos.last, last.id == currentPhoto.id {
            currentPage += 1
            Task {
                await performSearch()
            }
        }
    }

    // MARK: - Pinterest-style photo splitting

    var splitColumns: ([Photo], [Photo]) {
        var left: [Photo] = []
        var right: [Photo] = []
        var leftHeight: CGFloat = 0
        var rightHeight: CGFloat = 0

        for photo in photos {
            let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
            let height = 180 * aspectRatio

            if leftHeight <= rightHeight {
                left.append(photo)
                leftHeight += height
            } else {
                right.append(photo)
                rightHeight += height
            }
        }

        return (left, right)
    }

    var unsplashServiceIsPlaceholder: Bool {
        (unsplashService as? UnsplashService)?.accessKey.isEmpty == true
    }

    func setUnsplashService(_ service: UnsplashServiceProtocol) {
        if unsplashServiceIsPlaceholder {
            unsplashService = service
        }
    }
}
