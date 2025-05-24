//
//  HomeViewModel.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 24.05.25.
//

import Foundation
import SwiftUI

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var photos: [Photo] = []
    @Published var currentPage = 1
    @Published var isLoadingPage = false
    @Published var hasMorePages = true
    @Published var loadFailed = false
    @Published var failedPhotoIDs: Set<String> = []
    
    private let perPage = 20
    private let unsplashService: UnsplashServiceProtocol
    
    init(unsplashService: UnsplashServiceProtocol) {
        self.unsplashService = unsplashService
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
