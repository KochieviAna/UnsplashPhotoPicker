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
        NavigationView {
            ScrollView {
                staggeredGrid
            }
            .searchable(text: $viewModel.searchText, prompt: "Search photos, collections, users")
            .scrollDismissesKeyboard(.interactively)
            .onAppear {
                if viewModel.unsplashServiceIsPlaceholder {
                    viewModel.setUnsplashService(appSettings.unsplashService)
                }
                Task {
                    await viewModel.loadInitialPhotos()
                }
            }
            .refreshable {
                await viewModel.performSearch(reset: true)
            }
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
                        asyncPhotoView(photo)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentPhoto: photo)
                            }
                    }
                }
                
                VStack(spacing: 2) {
                    ForEach(viewModel.splitColumns.1) { photo in
                        asyncPhotoView(photo)
                            .onAppear {
                                viewModel.loadMoreIfNeeded(currentPhoto: photo)
                            }
                    }
                }
            }
            .padding(.horizontal, 5)
        }
    }
    
    private func asyncPhotoView(_ photo: Photo) -> some View {
        let aspectRatio = CGFloat(photo.height) / CGFloat(photo.width)
        let height = 180 * aspectRatio
        
        return ZStack(alignment: .bottomLeading) {
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
}

#Preview {
    SearchView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
