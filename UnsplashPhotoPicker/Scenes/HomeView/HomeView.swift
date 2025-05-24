//
//  HomeView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @StateObject private var viewModel: HomeViewModel
    
    private let columns = [GridItem(.flexible())]
    
    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel(unsplashService: UnsplashService(accessKey: "")))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HomeHeaherView()
            homeGridView
        }
        .onAppear {
            if viewModel.unsplashServiceIsPlaceholder {
                viewModel.setUnsplashService(appSettings.unsplashService)
                viewModel.loadNextPage()
            }
        }
    }
    
    private var homeGridView: some View {
        Group {
            if viewModel.loadFailed {
                VStack(spacing: 12) {
                    Text("Failed to load photos.")
                        .foregroundColor(.primaryGrey)
                        .font(.poppinsMedium(size: 20))
                    
                    Button("Retry") {
                        viewModel.loadNextPage()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.primaryGrey)
                    .foregroundColor(.white)
                    .font(.poppinsMedium(size: 20))
                    .padding(.horizontal)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 2) {
                        ForEach(viewModel.photos.filter { !viewModel.failedPhotoIDs.contains($0.id) }) { photo in
                            photoCell(photo)
                                .onAppear {
                                    if photo == viewModel.photos.last && viewModel.hasMorePages && !viewModel.isLoadingPage {
                                        viewModel.loadNextPage()
                                    }
                                }
                        }
                        
                        if viewModel.isLoadingPage {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                                .padding()
                        } else if viewModel.hasMorePages {
                            Button("Load More") {
                                viewModel.loadNextPage()
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.primaryGrey)
                            .foregroundColor(.white)
                            .font(.poppinsMedium(size: 20))
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
                    await viewModel.refreshPhotos()
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
                            viewModel.markPhotoAsFailed(photo.id)
                        }
                @unknown default:
                    EmptyView()
                }
            }
            .clipped()
            
            VStack(alignment: .leading, spacing: 2) {
                Text(photo.user.name)
                    .font(.poppinsBold(size: 16))
                    .shadow(radius: 4)
                    .foregroundColor(.white)
            }
            .padding([.leading, .bottom], 8)
        }
    }
}

#Preview {
    HomeView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
