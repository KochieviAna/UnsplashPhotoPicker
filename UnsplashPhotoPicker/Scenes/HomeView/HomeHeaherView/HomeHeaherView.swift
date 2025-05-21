//
//  HomeHeaherView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct HomeHeaherView: View {
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
    }
    
    private var unsplashIconButton: some View {
        Button(action: {
            print("Unsplash button tapped")
        }) {
            Image("dark_unsplash_icon")
                .resizable()
                .foregroundColor(.primaryBlack)
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
            print("Downloads tapped")
        }) {
            Image(systemName: "arrow.down.circle")
                .resizable()
                .foregroundColor(.primaryBlack)
                .frame(width: 24, height: 24)
        }
        .background(Color(.systemBackground))
    }
}

#Preview {
    HomeHeaherView()
}
