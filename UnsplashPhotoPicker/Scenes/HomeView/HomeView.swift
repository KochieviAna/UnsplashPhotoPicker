//
//  HomeView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    
    @State private var photos: [Photo] = []
    @State private var currentPage = 1
    @State private var isLoadingPage = false
    @State private var hasMorePages = true
    @State private var loadFailed = false
    @State private var failedPhotoIDs: Set<String> = []
    
    private let perPage = 20
    private let columns = [GridItem(.flexible())]
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaherView()
            homeGridView
        }
        .onAppear(perform: loadNextPage)
    }
    
    private var homeGridView: some View {
        Group {
            if loadFailed {
                VStack(spacing: 12) {
                    Text("Failed to load photos.")
                        .foregroundColor(.primaryGrey)
                        .font(.poppinsMedium(size: 20))
                    Button(action: {
                        loadNextPage()
                    }) {
                        Text("Retry")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.primaryGrey)
                            .foregroundColor(.white)
                            .font(.poppinsMedium(size: 20))
                    }
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(photos.filter { !failedPhotoIDs.contains($0.id) }) { photo in
                            NavigationLink {
                                ImageDetailsView(height: CGFloat(photo.height))
                            } label: {
                                photoCell(photo)
                                    .onAppear {
                                        if photo == photos.last && hasMorePages && !isLoadingPage {
                                            loadNextPage()
                                        }
                                    }
                            }
                        }
                        
                        if isLoadingPage {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if hasMorePages {
                            Button(action: {
                                loadNextPage()
                            }) {
                                Text("Load More")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.primaryGrey)
                                    .font(.poppinsMedium(size: 20))
                                    .foregroundColor(.white)
                            }
                            .padding()
                        } else {
                            Text("No more photos")
                                .foregroundColor(.primaryGrey)
                                .font(.poppinsMedium(size: 20))
                                .padding()
                        }
                    }
                    .padding(.horizontal, 5)
                }
                .refreshable {
                    await refreshPhotos()
                }
            }
        }
    }
    
    private func photoCell(_ photo: Photo) -> some View {
        ZStack(alignment: .bottomLeading) {
            AsyncImage(url: URL(string: photo.urls.regular)) { phase in
                switch phase {
                case .empty:
                    Color.primaryGrey.opacity(0.3)
                        .frame(height: 200)
                        .redacted(reason: .placeholder)
                        .shimmering()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                    
                case .failure(_):
                    Color.clear
                        .frame(height: 0)
                        .onAppear {
                            failedPhotoIDs.insert(photo.id)
                        }
                    
                @unknown default:
                    EmptyView()
                }
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(photo.user.name)
                    .font(.poppinsBold(size: 16))
            }
            .padding(6)
            .foregroundColor(.white)
            .padding([.leading, .bottom], 8)
        }
    }
    
    private func loadNextPage() {
        guard !isLoadingPage && hasMorePages else { return }
        isLoadingPage = true
        loadFailed = false
        
        Task {
            do {
                let newPhotos = try await appSettings.unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
                if newPhotos.isEmpty {
                    hasMorePages = false
                } else {
                    photos.append(contentsOf: newPhotos)
                    currentPage += 1
                }
            } catch {
                print("Failed to load page \(currentPage): \(error)")
                loadFailed = true
            }
            isLoadingPage = false
        }
    }
    
    private func refreshPhotos() async {
        currentPage = 1
        hasMorePages = true
        isLoadingPage = true
        loadFailed = false
        failedPhotoIDs = []
        
        do {
            let newPhotos = try await appSettings.unsplashService.fetchPhotos(page: currentPage, perPage: perPage)
            photos = newPhotos
            currentPage += 1
        } catch {
            print("Failed to refresh photos: \(error)")
            loadFailed = true
        }
        
        isLoadingPage = false
    }
}

#Preview {
    HomeView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
