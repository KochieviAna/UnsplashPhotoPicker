//
//  BookmarksView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

struct BookmarksView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @State private var bookmarkedPhotos: [BookmarkedPhoto] = []
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    var body: some View {
        NavigationView {
            Group {
                if bookmarkedPhotos.isEmpty {
                    Text("Bookmarks Content")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .foregroundStyle(.primaryBlack)
                        .font(.poppinsMedium(size: 20))
                } else {
                    ScrollView {
                        LazyVGrid(columns: columns, spacing: 8) {
                            ForEach(bookmarkedPhotos) { photo in
                                VStack(spacing: 0) {
                                    AsyncImage(url: URL(string: photo.url)) { phase in
                                        switch phase {
                                        case .empty:
                                            Color.primaryGrey.opacity(0.3)
                                                .aspectRatio(1, contentMode: .fit)
                                                .cornerRadius(8)
                                                .redacted(reason: .placeholder)
                                                .shimmering()
                                        case .success(let image):
                                            image
                                                .resizable()
                                                .aspectRatio(1, contentMode: .fill)
                                                .frame(maxWidth: .infinity)
                                                .clipped()
                                                .cornerRadius(8)
                                        case .failure:
                                            Color.primaryGrey.opacity(0.3)
                                                .aspectRatio(1, contentMode: .fit)
                                                .cornerRadius(8)
                                        @unknown default:
                                            EmptyView()
                                        }
                                    }
                                }
                            }
                        }
                        .padding(8)
                    }
                }
            }
        }
        .onAppear {
            if let service = appSettings.photoDownloadTracker as? UnsplashService {
                bookmarkedPhotos = service.bookmarkedPhotos
            }
        }
    }
}

#Preview {
    BookmarksView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
