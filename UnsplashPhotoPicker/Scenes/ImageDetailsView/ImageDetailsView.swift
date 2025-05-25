//
//  ImageDetailsView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct ImageDetailsView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @Environment(\.dismiss) private var dismiss
    
    let photo: Photo
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            AsyncImage(url: URL(string: photo.urls.regular)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                case .failure:
                    Color.primaryGrey.opacity(0.3)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                @unknown default:
                    EmptyView()
                }
            }
            
            Button(action: {
                dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    .padding(12)
            }
            .padding(.leading, 12)
            .padding(.top, 60)
            
            VStack(alignment: .leading) {
                Spacer()
                Text(photo.user.name)
                    .font(.poppinsBold(size: 16))
                    .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    .padding(12)
            }
            .padding(.leading, 12)
            .padding(.bottom, 30)
        }
        .navigationBarBackButtonHidden(true)
        .ignoresSafeArea()
        .toolbar(.hidden, for: .tabBar)
    }
}
