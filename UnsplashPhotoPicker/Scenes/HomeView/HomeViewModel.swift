//
//  HomeViewModel.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 24.05.25.
//

import Foundation
import SwiftUI
import Observation

@MainActor
@Observable
final class HomeViewModel: ObservableObject {
    private(set) var unsplashService: UnsplashServiceProtocol
    private var serviceWasSet = false
    
    var photos: [Photo] = []
    var currentPage = 1
    var isLoadingPage = false
    var hasMorePages = true
    var loadFailed = false
    var failedPhotoIDs: Set<String> = []
    
    private let perPage = 20
    
    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
    }
    
    var unsplashServiceIsPlaceholder: Bool {
        (unsplashService as? UnsplashService)?.accessKey.isEmpty == true
    }
    
    func setUnsplashService(_ service: UnsplashServiceProtocol) {
        guard !serviceWasSet else { return }
        self.unsplashService = service
        self.serviceWasSet = true
    }
    
    func loadNextPage() {
        guard !isLoadingPage && hasMorePages else { return }
        isLoadingPage = true
        loadFailed = false
        
        Task {
            do {
                let newPhotos = try await unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
                if newPhotos.isEmpty {
                    hasMorePages = false
                } else {
                    photos.append(contentsOf: newPhotos)
                    currentPage += 1
                }
            } catch {
                print("Failed to load page \(currentPage): \(error)")
                loadFailed = true
            }
            isLoadingPage = false
        }
    }
    
    func refreshPhotos() async {
        currentPage = 1
        hasMorePages = true
        isLoadingPage = true
        loadFailed = false
        failedPhotoIDs = []
        
        do {
            let newPhotos = try await unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
            photos = newPhotos
            currentPage += 1
        } catch {
            print("Failed to refresh photos: \(error)")
            loadFailed = true
        }
        
        isLoadingPage = false
    }
    
    func markPhotoAsFailed(_ photoID: String) {
        failedPhotoIDs.insert(photoID)
    }
}
