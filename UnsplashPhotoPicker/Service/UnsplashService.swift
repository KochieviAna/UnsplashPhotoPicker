//
//  UnsplashService.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation

final class UnsplashService: PhotoFetching, PhotoSearching, PhotoDownloadTracking {
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
        
        guard let downloadURL = URL(string: decoded.url) else {
            throw URLError(.badURL)
        }
        
        return downloadURL
    }
    
}
