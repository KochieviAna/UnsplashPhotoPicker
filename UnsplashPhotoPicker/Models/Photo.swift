//
//  Photo.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation

struct Photo: Codable, Identifiable, Equatable {
    let id: String
    let width: Int
    let height: Int
    let user: User
    let urls: URLs
    let links: Links

    struct User: Codable, Equatable {
        let username: String
        let name: String
    }

    struct URLs: Codable, Equatable {
        let raw: String
        let full: String
        let regular: String
        let small: String
        let thumb: String
    }
    
    struct Links: Codable, Equatable {
        let downloadLocation: String
    }
}
