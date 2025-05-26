//
//  ImageDetailsViewModel.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 26.05.25.
//

import Foundation
import SwiftUI
import Photos

@MainActor
@Observable
final class ImageDetailsViewModel {
    var imageScale: CGFloat = 1.0
    var showSaveSuccess = false
    var showSaveErrorAlert = false
    var saveErrorMessage = ""
    var isBookmarked = false
    
    private let photoDownloadTracker: PhotoDownloadTracking
    
    init(photoDownloadTracker: PhotoDownloadTracking) {
        self.photoDownloadTracker = photoDownloadTracker
    }
    
    func toggleBookmark() {
        isBookmarked.toggle()
    }
    
    func resetImageScaleWithAnimation() {
        withAnimation(.spring()) {
            imageScale = 1.0
        }
    }
    
    func updateImageScale(to value: CGFloat) {
        imageScale = min(max(value, 1.0), 4.0)
    }
    
    func downloadImageToPhotoLibrary(for photo: Photo) {
        Task {
            do {
                let downloadURL = try await photoDownloadTracker.trackDownload(for: photo)
                let (data, _) = try await URLSession.shared.data(from: downloadURL)
                guard let image = UIImage(data: data) else {
                    throw NSError(domain: "Invalid image data", code: -1)
                }
                
                let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                guard status == .authorized || status == .limited else {
                    throw NSError(domain: "Photo Library access denied", code: -1)
                }
                
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                
                withAnimation { showSaveSuccess = true }
                
                try await Task.sleep(nanoseconds: 2_500_000_000)
                withAnimation { showSaveSuccess = false }
                
            } catch {
                saveErrorMessage = error.localizedDescription
                showSaveErrorAlert = true
            }
        }
    }
}
