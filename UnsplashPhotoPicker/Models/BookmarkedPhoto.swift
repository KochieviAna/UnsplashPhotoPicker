//
//  BookmarkedPhoto.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 26.05.25.
//

import Foundation

struct BookmarkedPhoto: Codable, Identifiable, Equatable {
    let id: String
    let url: String
    let photographerName: String
}
