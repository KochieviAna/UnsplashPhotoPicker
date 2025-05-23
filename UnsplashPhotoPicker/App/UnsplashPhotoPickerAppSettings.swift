//
//  UnsplashPhotoPickerAppSettings.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

class UnsplashPhotoPickerAppSettings: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
    
    private let accessKey = "_V60u3Frokty_NCzK83YlKGIj1HIfwLzqciub6nlYHA"

    lazy var unsplashService: UnsplashServiceProtocol = {
        UnsplashService(accessKey: accessKey)
    }()
}
