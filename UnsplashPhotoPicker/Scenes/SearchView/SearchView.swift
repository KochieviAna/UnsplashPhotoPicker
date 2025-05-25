//
//  SearchView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct SearchView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @StateObject private var viewModel: SearchViewModel
    
    init() {
        _viewModel = StateObject(wrappedValue: SearchViewModel(unsplashService: UnsplashService(accessKey: "")))
    }
    
    var body: some View {
        NavigationStack {
            Group {
                if viewModel.shouldShowError {
                    searchFailedView
                } else {
                    searchGridView
                }
            }
            .searchable(text: $viewModel.searchText,
                        prompt: "Search photos, users...")
            .scrollDismissesKeyboard(.interactively)
            .onAppear(perform: handleOnAppear)
        }
    }
    
    private var staggeredGrid: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Discover")
                .font(.poppinsMedium(size: 16))
                .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 2) {
                VStack(spacing: 2) {
                    ForEach(viewModel.splitColumns.0) { photo in
                        photoCell(photo)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentPhoto: photo)
                            }
                    }
                }
                
                VStack(spacing: 2) {
                    ForEach(viewModel.splitColumns.1) { photo in
                        photoCell(photo)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentPhoto: photo)
                            }
                    }
                }
            }
            .padding(.horizontal, 5)
        }
    }
    
    private var searchFailedView: some View {
        VStack(spacing: 12) {
            Text("Search failed. Try again.")
                .foregroundColor(.primaryGrey)
                .font(.poppinsMedium(size: 20))
            Button("Retry") {
                Task {
                    await viewModel.performSearch(reset: true)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.primaryGrey)
            .foregroundColor(.white)
            .font(.poppinsMedium(size: 20))
            .padding(.horizontal)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var searchGridView: some View {
        VStack(spacing: 0) {
            Text("Discover")
                .font(.poppinsMedium(size: 16))
                .padding(.horizontal)
                .padding(.vertical, 6)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color(.systemBackground))
            
            ScrollView {
                VStack(alignment: .leading, spacing: 2) {
                    HStack(alignment: .top, spacing: 2) {
                        photoColumn(viewModel.splitColumns.0)
                        photoColumn(viewModel.splitColumns.1)
                    }
                    .padding(.horizontal, 5)
                }
                if !viewModel.hasMorePages {
                    Text("No more results")
                        .foregroundColor(.primaryGrey)
                        .font(.poppinsMedium(size: 16))
                        .padding()
                }
            }
        }
    }
    
    
    private func photoColumn(_ photos: [Photo]) -> some View {
        VStack(spacing: 2) {
            ForEach(photos) { photo in
                photoCell(photo)
                    .onAppear {
                        viewModel.loadMoreIfNeeded(currentPhoto: photo)
                    }
            }
            
            if viewModel.isLoading {
                shimmeringPlaceholderColumn()
            }
        }
    }
    
    private func handleOnAppear() {
        if viewModel.unsplashServiceIsPlaceholder {
            viewModel.setUnsplashService(appSettings.unsplashService)
        }
        Task {
            await viewModel.loadInitialPhotos()
        }
    }
    
    private func photoCell(_ photo: Photo) -> some View {
        NavigationLink(destination: {
            ImageDetailsView(photo: photo)
                .navigationBarHidden(true)
        }) {
            let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
            let height = 180 * aspectRatio
            
            ZStack(alignment: .bottomLeading) {
                AsyncImage(url: URL(string: photo.urls.small)) { phase in
                    switch phase {
                    case .empty:
                        Color.primaryGrey.opacity(0.2)
                            .frame(height: height)
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(height: height)
                            .clipped()
                    case .failure:
                        Color.primaryGrey.opacity(0.2)
                            .frame(height: height)
                            .overlay(Text("Load failed").foregroundColor(.primaryGrey))
                    @unknown default:
                        EmptyView()
                    }
                }
                
                Text(photo.user.name)
                    .font(.poppinsBold(size: 14))
                    .shadow(radius: 4)
                    .foregroundColor(.white)
                    .padding(.horizontal, 4)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
    
    private func shimmeringPlaceholderColumn() -> some View {
        VStack(spacing: 2) {
            ForEach(0..<2, id: \.self) { _ in
                Color.primaryGrey.opacity(0.3)
                    .frame(height: 180)
                    .redacted(reason: .placeholder)
                    .shimmering()
            }
        }
    }
}

#Preview {
    SearchView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
