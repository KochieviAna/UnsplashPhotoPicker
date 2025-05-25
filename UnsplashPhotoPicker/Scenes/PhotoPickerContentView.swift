//
//  PhotoPickerContentView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct PhotoPickerContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
            }
            
            NavigationStack {
                SearchView()
            }
            .tabItem {
                Image(systemName: "magnifyingglass")
            }
            
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person")
            }
        }
        .tint(.primaryBlack)
    }
}

#Preview {
    PhotoPickerContentView()
        .environmentObject(UnsplashPhotoPickerAppSettings( ))
}
