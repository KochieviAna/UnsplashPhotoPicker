//
//  HomeHeaherView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct HomeHeaherView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @State private var showDownloads = false

    var body: some View {
        HStack {
            unsplashIconButton

            Spacer()

            unsplashText

            Spacer()

            downloadsButton
        }
        .background(Color(.systemBackground))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
        .sheet(isPresented: $showDownloads) {
            DownloadsView()
                .environmentObject(appSettings)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        }
    }

    private var unsplashIconButton: some View {
        Button(action: {
            print("Unsplash button tapped")
        }) {
            Image(appSettings.isDarkMode ? "light_unsplash_icon" : "dark_unsplash_icon")
                .resizable()
                .frame(width: 35, height: 40)
        }
        .background(Color(.systemBackground))
    }

    private var unsplashText: some View {
        Text("Unsplash")
            .font(.poppinsMedium(size: 24))
    }

    private var downloadsButton: some View {
        Button(action: {
            if !showDownloads {
                showDownloads = true
            }
        }) {
            Image(systemName: "arrow.down.circle")
                .resizable()
                .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                .frame(width: 24, height: 24)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeHeaherView()
        .preferredColorScheme(.dark)
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
