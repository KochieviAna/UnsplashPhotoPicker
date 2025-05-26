//
//  UnsplashPhotoPickerAppSettings.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

final class UnsplashPhotoPickerAppSettings: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false

    private let accessKey = "_V60u3Frokty_NCzK83YlKGIj1HIfwLzqciub6nlYHA"

    private lazy var service: UnsplashService = {
        UnsplashService(accessKey: accessKey)
    }()

    var photoFetcher: PhotoFetching { service }
    var photoSearcher: PhotoSearching { service }
    var photoDownloadTracker: PhotoDownloadTracking { service }
}
