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
    var shouldShowError = false
    var searchText: String = "" {
        didSet {
            debounceSearch()
        }
    }
    
    var photos: [Photo] = []
    var isLoading = false
    var loadFailed = false
    var hasMorePages = true
    
    private var currentPage = 1
    private let perPage = 20
    private var searchTask: Task<Void, Never>? = nil
    
    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
    }
    
    func loadInitialPhotos() async {
        isLoading = true
        loadFailed = false
        hasMorePages = true
        currentPage = 1
        
        do {
            let results = try await unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
            photos = results
            currentPage += 1
            hasMorePages = !results.isEmpty
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
            
            if searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                await loadInitialPhotos()
            } else {
                await performSearch(reset: true)
            }
        }
    }
    
    func performSearch(reset: Bool = false) async {
        if reset {
            currentPage = 1
            hasMorePages = true
            shouldShowError = false
        }

        guard !searchText.isEmpty, !isLoading, hasMorePages else { return }

        isLoading = true
        loadFailed = false

        do {
            let results = try await unsplashService.searchPhotos(query: searchText, page: currentPage, perPage: perPage)
            if reset {
                photos = results
            } else {
                photos += results
            }

            if results.isEmpty {
                hasMorePages = false
            } else {
                currentPage += 1
            }

        } catch {
            print("Search failed: \(error)")
            loadFailed = true

            Task {
                try? await Task.sleep(nanoseconds: 2_000_000_000)
                if loadFailed && photos.isEmpty {
                    shouldShowError = true
                }
            }
        }

        isLoading = false
    }

    func loadMoreIfNeeded(currentPhoto: Photo) {
        guard !isLoading, hasMorePages, !loadFailed else { return }
        if let last = photos.last, last.id == currentPhoto.id {
            Task {
                await performSearch()
            }
        }
    }
    
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
