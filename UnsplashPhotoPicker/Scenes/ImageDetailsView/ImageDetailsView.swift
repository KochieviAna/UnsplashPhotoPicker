//
//  ImageDetailsView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI
import Photos

struct ImageDetailsView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @Environment(\.dismiss) private var dismiss
    
    let photo: Photo
    
    @State private var viewModel: ImageDetailsViewModel
    
    init(photo: Photo) {
        self.photo = photo
        _viewModel = State(wrappedValue: ImageDetailsViewModel(unsplashService: UnsplashService(accessKey: "_V60u3Frokty_NCzK83YlKGIj1HIfwLzqciub6nlYHA")))
    }
    
    var body: some View {
        ZStack {
            AsyncImage(url: URL(string: photo.urls.regular)) { phase in
                switch phase {
                case .empty:
                    Color.primaryGrey.opacity(0.3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .redacted(reason: .placeholder)
                        .shimmering()
                    
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .scaleEffect(viewModel.imageScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { viewModel.updateImageScale(to: $0) }
                                .onEnded { _ in viewModel.resetImageScaleWithAnimation() }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                case .failure:
                    Color.primaryGrey.opacity(0.3)
                @unknown default:
                    EmptyView()
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: { viewModel.toggleBookmark() }) {
                            Image(systemName: viewModel.isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 24))
                                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                        }
                        
                        Button(action: {
                            viewModel.downloadImageToPhotoLibrary(for: photo)
                        }) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 24))
                                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.top, 20)
                
                Spacer()
                
                HStack {
                    Text(photo.user.name)
                        .font(.poppinsBold(size: 20))
                        .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    Spacer()
                }
                .padding()
            }
            
            if viewModel.showSaveSuccess {
                VStack(spacing: 12) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 48))
                        .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    
                    Text("Photo saved")
                        .font(.poppinsMedium(size: 18))
                        .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                }
                .padding(30)
                .background(appSettings.isDarkMode ? .primaryBlack.opacity(0.75) : .white.opacity(0.75))
                .cornerRadius(16)
                .transition(.opacity)
                .zIndex(1)
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .tabBar)
        .alert("Error Saving Photo", isPresented: $viewModel.showSaveErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(viewModel.saveErrorMessage)
        }
    }
}
