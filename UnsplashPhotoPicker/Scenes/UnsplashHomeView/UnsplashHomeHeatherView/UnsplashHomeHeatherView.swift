//
//  UnsplashHomeHeatherView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct UnsplashHomeHeatherView: View {
    var body: some View {
        VStack {
            unsplashImage
            
            HStack {
                bookmarkButton
                
                downloadedPicturesButton
            }
            .frame(maxWidth: .infinity)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(Color.primaryBackground)
    }
    
    private var unsplashImage: some View {
        Image("dark_unsplash_icon")
            .resizable()
            .scaledToFill()
            .frame(width: 100, height: 100)
            .padding(.top, 50)
    }
    
    private var bookmarkButton: some View {
        Button(action: {
            print("Bookmark tapped")
        }) {
            HStack(spacing: 8) {
                Image("bookmark")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 18, height: 24)
                Text("Bookmarks")
                    .foregroundColor(.primaryGrey)
                    .font(.poppinsRegular(size: 16))
            }
            .padding()
        }
    }
    
    private var downloadedPicturesButton: some View {
        Button(action: {
            print("Saved pictures tapped")
        }) {
            HStack(spacing: 8) {
                Image("downloads")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 24)
                Text("Downloads")
                    .foregroundColor(.primaryGrey)
                    .font(.poppinsRegular(size: 16))
            }
            .padding()
        }
    }
}

#Preview {
    UnsplashHomeHeatherView()
}
