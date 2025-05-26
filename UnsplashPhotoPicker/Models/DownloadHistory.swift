//
//  DownloadHistory.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 26.05.25.
//

import Foundation

struct DownloadHistory: Codable, Identifiable {
    let id: String
    let photoId: String
    let date: Date
    let photoURL: String
    let photographerName: String
}
