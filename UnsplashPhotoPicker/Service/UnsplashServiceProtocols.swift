//
//  UnsplashServiceProtocols.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation

protocol PhotoFetching {
    func fetchPhotos(page: Int, perPage: Int) async throws -> [Photo]
}

protocol PhotoSearching {
    func searchPhotos(query: String, page: Int, perPage: Int) async throws -> [Photo]
}

protocol PhotoDownloadTracking {
    func trackDownload(for photo: Photo) async throws -> URL
}
