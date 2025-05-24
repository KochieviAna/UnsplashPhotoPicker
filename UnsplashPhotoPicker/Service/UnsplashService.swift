//
//  UnsplashService.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import Foundation

final class UnsplashService: UnsplashServiceProtocol {
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
}
