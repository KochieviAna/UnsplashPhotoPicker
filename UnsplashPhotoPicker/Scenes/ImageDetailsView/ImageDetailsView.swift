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
    
    @State private var imageScale: CGFloat = 1.0
    
    let photo: Photo
    
    @State private var showSaveSuccess = false
    @State private var showSaveErrorAlert = false
    @State private var saveErrorMessage = ""
    @State private var isBookmarked = false
    
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
                        .scaleEffect(imageScale)
                        .gesture(
                            MagnificationGesture()
                                .onChanged { value in
                                    imageScale = min(max(value, 1.0), 4.0)
                                }
                                .onEnded { _ in
                                    withAnimation(.spring()) {
                                        imageScale = 1.0
                                    }
                                }
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure:
                    Color.primaryGrey.opacity(0.3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 24, weight: .bold))
                            .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    }
                    
                    Spacer()
                    
                    HStack(spacing: 12) {
                        Button(action: {
                            isBookmarked.toggle()
                        }) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                                .font(.system(size: 24))
                                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                        }
                        
                        Button(action: {
                            downloadImageToPhotoLibrary(from: photo.urls.full)
                        }) {
                            Image(systemName: "arrow.down.to.line")
                                .font(.system(size: 24))
                                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
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
            
            if showSaveSuccess {
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
        .alert("Error Saving Photo", isPresented: $showSaveErrorAlert) {
            Button("OK", role: .cancel) { }
        } message: {
            Text(saveErrorMessage)
        }
    }
    
    private func downloadImageToPhotoLibrary(from urlString: String) {
        guard let url = URL(string: urlString) else { return }
        
        Task {
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                guard let image = UIImage(data: data) else {
                    print("Failed to create UIImage from data")
                    throw NSError(domain: "Invalid image data", code: -1)
                }
                
                let status = await PHPhotoLibrary.requestAuthorization(for: .addOnly)
                guard status == .authorized || status == .limited else {
                    throw NSError(domain: "Photo Library access denied", code: -1)
                }
                
                try await PHPhotoLibrary.shared().performChanges {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
                
                await MainActor.run {
                    withAnimation {
                        showSaveSuccess = true
                    }
                }
                
                try await Task.sleep(nanoseconds: 2_500_000_000)
                
                await MainActor.run {
                    withAnimation {
                        showSaveSuccess = false
                    }
                }
                
            } catch {
                await MainActor.run {
                    saveErrorMessage = error.localizedDescription
                    showSaveErrorAlert = true
                }
            }
        }
    }
}
