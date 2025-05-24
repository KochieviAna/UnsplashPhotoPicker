//
//  UnsplashServiceProtocol.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation

protocol UnsplashServiceProtocol {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo]
    
    func searchPhotos(query: String, page: Int, perPage: Int) async throws -> [Photo]
}
