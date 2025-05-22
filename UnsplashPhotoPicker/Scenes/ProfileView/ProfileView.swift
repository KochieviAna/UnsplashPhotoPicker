//
//  ProfileView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

struct ProfileView: View {
    @State private var selectedSegment: ProfileSegment = .bookmarks
    @Environment(\.colorScheme) private var colorScheme
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    
    enum ProfileSegment: String, CaseIterable {
        case bookmarks = "Bookmarks"
        case downloads = "Downloads"
    }
    
    var body: some View {
        VStack(spacing: 20) {
            profileHeader
            
            segmentedPicker
            
            contentView
            
            Spacer()
        }
        .padding(.top, 20)
        .overlay(themeToggleButton, alignment: .topLeading)
        .preferredColorScheme(appSettings.isDarkMode ? .dark : .light)
    }
    
    private var themeToggleButton: some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.3)) {
                appSettings.isDarkMode.toggle()
            }
        }) {
            Image(systemName: appSettings.isDarkMode ? "sun.max.fill" : "moon.fill")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                .padding()
                .clipShape(Circle())
        }
        .padding(.leading, 20)
        .padding(.top, 10)
    }
    
    private var profileHeader: some View {
        VStack(spacing: 8) {
            profilePictureImage
            nameText
            usernameText
        }
    }
    
    private var profilePictureImage: some View {
        ZStack {
            Circle()
                .stroke(style: StrokeStyle(lineWidth: 4))
                .foregroundColor(.primaryBlack)
                .frame(width: 90, height: 90)
                .shadow(radius: 5)
            
            Image(appSettings.isDarkMode ? "light_unsplash_icon" : "dark_unsplash_icon")
                .resizable()
                .frame(width: 80, height: 80)
                .clipShape(Circle())
        }
    }
    
    private var nameText: some View {
        Text("Ana Kochievi")
            .font(.poppinsMedium(size: 20))
            .foregroundStyle(.primaryBlack)
    }
    
    private var usernameText: some View {
        Text("ana.kochievi")
            .font(.poppinsLight(size: 18))
            .foregroundStyle(.primaryBlack)
    }
    
    private var segmentedPicker: some View {
        HStack(spacing: 0) {
            ForEach(ProfileSegment.allCases, id: \.self) { segment in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedSegment = segment
                    }
                }) {
                    Text(segment.rawValue)
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(selectedSegment == segment ?(appSettings.isDarkMode ? .black : .white) : .primaryBlack)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(selectedSegment == segment ?(appSettings.isDarkMode ? Color.white : Color.primaryBlack) : Color.clear))
                }
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 8)
                .stroke(Color.primaryBlack, lineWidth: 1)
        )
        .padding(.horizontal, 24)
    }
    
    @ViewBuilder
    private var contentView: some View {
        switch selectedSegment {
        case .bookmarks:
            BookmarksView()
        case .downloads:
            DownloadsView()
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
