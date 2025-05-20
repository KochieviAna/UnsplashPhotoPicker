//
//  UnsplashHomeHeaherView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct UnsplashHomeHeaherView: View {
    var body: some View {
        HStack {
            bookmarkButton
            
            Spacer()
            
            usplashIcon
            
            Spacer()
            
            downloadsButton
        }
        .background(Color(.systemBackground))
        .frame(maxWidth: .infinity)
        .padding(.horizontal, 24)
    }
    
    private var bookmarkButton: some View {
        Button(action: {
            print("Bookmark tapped")
        }) {
            Image(systemName: "bookmark")
                .resizable()
                .foregroundColor(.primaryBlack)
                .frame(width: 20, height: 30)
                .padding(.leading, 10)
        }
        .background(Color(.systemBackground))
    }
    
    private var usplashIcon: some View {
        Image("dark_unsplash_icon")
            .resizable()
            .scaledToFit()
            .background(Color(.systemBackground))
            .frame(width: 100, height: 100)
    }
    
    private var downloadsButton: some View {
        Button(action: {
            print("Downloads tapped")
        }) {
            Image(systemName: "arrow.down.circle")
                .resizable()
                .foregroundColor(.primaryBlack)
                .frame(width: 30, height: 30)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    UnsplashHomeHeaherView()
}
