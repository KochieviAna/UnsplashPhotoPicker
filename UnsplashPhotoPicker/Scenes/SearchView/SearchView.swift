//
//  SearchView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 20.05.25.
//

import SwiftUI

struct SearchView: View {
    @State private var searchText: String = ""
    let placeholders = (1...20).map { _ in CGFloat.random(in: 100...250) }
    
    let categories = ["Nature", "People", "Architecture", "Animals", "Food", "Travel", "Fashion", "Sports", "Technology", "Art"]
    
    var columnData: ([CGFloat], [CGFloat]) {
        var left: [CGFloat] = []
        var right: [CGFloat] = []
        for (index, height) in placeholders.enumerated() {
            if index % 2 == 0 {
                left.append(height)
            } else {
                right.append(height)
            }
        }
        return (left, right)
    }
    
    var body: some View {
        ScrollView(.vertical) {
            categoryGrid
            
            adaptiveGrid
        }
        .searchable(text: $searchText, prompt: "Search photos, collections, users")
    }
    
    private var categoryGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Browse by Category")
                .font(.headline)
                .padding(.horizontal)
            
            ScrollView(.horizontal, showsIndicators: false) {
                VStack(spacing: 8) {
                    HStack(spacing: 8) {
                        ForEach(0..<categories.count/2, id: \.self) { index in
                            categoryItem(name: categories[index])
                        }
                    }
                    
                    HStack(spacing: 8) {
                        ForEach(categories.count/2..<categories.count, id: \.self) { index in
                            categoryItem(name: categories[index])
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.bottom)
    }
    
    private func categoryItem(name: String) -> some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 100, height: 100)
            .overlay(
                VStack {
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                    
                    Text(name)
                        .font(.caption)
                        .foregroundColor(.primary)
                }
            )
            .cornerRadius(8)
    }
    
    private var adaptiveGrid: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Discover")
                .font(.headline)
                .padding(.horizontal)
            
            HStack(alignment: .top, spacing: 2) {
                VStack(spacing: 2) {
                    ForEach(columnData.0.indices, id: \.self) { i in
                        NavigationLink(destination: ImageDetailsView(height: columnData.0[i])) {
                            PlaceholderImageView(height: columnData.0[i])
                        }
                    }
                }
                
                VStack(spacing: 2) {
                    ForEach(columnData.1.indices, id: \.self) { i in
                        NavigationLink(destination: ImageDetailsView(height: columnData.1[i])) {
                            PlaceholderImageView(height: columnData.1[i])
                        }
                    }
                }
            }
            .padding(.horizontal, 5)
        }
    }
}

struct PlaceholderImageView: View {
    let height: CGFloat
    
    var body: some View {
        Rectangle()
            .fill(Color.gray.opacity(0.3))
            .frame(height: height)
            .overlay(
                Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)
            )
            .shadow(radius: 2)
    }
}

#Preview {
    SearchView()
}
