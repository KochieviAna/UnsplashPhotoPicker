//
//  UnsplashPhotoPickerApp.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

@main
struct UnsplashPhotoPickerApp: App {
    @StateObject private var appSettings = UnsplashPhotoPickerAppSettings()
    
    var body: some Scene {
        WindowGroup {
            PhotoPickerContentView()
                .environmentObject(appSettings)
                .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
        }
    }
}
