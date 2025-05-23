//
//  UnsplashPhotoPickerAppSettings.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

class UnsplashPhotoPickerAppSettings: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false
}
