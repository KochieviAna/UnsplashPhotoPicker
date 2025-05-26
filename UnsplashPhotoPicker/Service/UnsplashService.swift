//
//  UnsplashService.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation
import SwiftUI

final class UnsplashService: PhotoFetching, PhotoSearching, PhotoDownloadTracking {
    @AppStorage("downloadHistory") private var downloadHistoryData: Data = Data()
    @AppStorage("bookmarkedPhotos") private var bookmarkedPhotosData: Data = Data()
    
    private var downloadHistory: [DownloadHistory] {
        get {
            guard let decoded = try? JSONDecoder().decode([DownloadHistory].self, from: downloadHistoryData) else {
                return []
            }
            return decoded
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            downloadHistoryData = encoded
        }
    }
    
    var bookmarkedPhotos: [BookmarkedPhoto] {
        get {
            guard let decoded = try? JSONDecoder().decode([BookmarkedPhoto].self, from: bookmarkedPhotosData) else {
                return []
            }
            return decoded
        }
        set {
            guard let encoded = try? JSONEncoder().encode(newValue) else { return }
            bookmarkedPhotosData = encoded
        }
    }
    
    private let baseURL = "https://api.unsplash.com"
    let accessKey: String
    
    init(accessKey: String) {
        self.accessKey = accessKey
    }
    
    func fetchPhotos(page: Int = 1, perPage: Int = 10) async throws -> [Photo] {
        guard let url = URL(string: "\(baseURL)/photos?page=\(page)&per_page=\(perPage)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        return try decoder.decode([Photo].self, from: data)
    }
    
    func searchPhotos(query: String, page: Int = 1, perPage: Int = 20) async throws -> [Photo] {
        guard !query.isEmpty else { return [] }
        
        guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/search/photos?query=\(encodedQuery)&page=\(page)&per_page=\(perPage)") else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        struct SearchResponse: Codable {
            let total: Int
            let totalPages: Int
            let results: [Photo]
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let searchResponse = try decoder.decode(SearchResponse.self, from: data)
        return searchResponse.results
    }
    
    func trackDownload(for photo: Photo) async throws -> URL {
        guard let url = URL(string: photo.links.downloadLocation) else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Client-ID \(accessKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              200..<300 ~= httpResponse.statusCode else {
            throw URLError(.badServerResponse)
        }
        
        struct DownloadResponse: Decodable {
            let url: String
        }
        
        let decoded = try JSONDecoder().decode(DownloadResponse.self, from: data)
        
        let historyItem = DownloadHistory(
            id: UUID().uuidString,
            photoId: photo.id,
            date: Date(),
            photoURL: photo.urls.regular,
            photographerName: photo.user.name
        )
        
        var currentHistory = downloadHistory
        currentHistory.insert(historyItem, at: 0)
        downloadHistory = currentHistory
        
        guard let downloadURL = URL(string: decoded.url) else {
            throw URLError(.badURL)
        }
        
        return downloadURL
    }
    
    func getDownloadHistory() -> [DownloadHistory] {
        return downloadHistory
    }
    
    func isPhotoBookmarked(_ photo: Photo) -> Bool {
        bookmarkedPhotos.contains { $0.id == photo.id }
    }
    
    func toggleBookmark(for photo: Photo) {
        var current = bookmarkedPhotos
        if let index = current.firstIndex(where: { $0.id == photo.id }) {
            current.remove(at: index)
        } else {
            let newBookmark = BookmarkedPhoto(
                id: photo.id,
                url: photo.urls.regular,
                photographerName: photo.user.name
            )
            current.insert(newBookmark, at: 0)
        }
        bookmarkedPhotos = current
    }
}
