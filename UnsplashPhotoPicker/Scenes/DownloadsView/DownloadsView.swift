//
//  DownloadsView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

struct DownloadsView: View {
    @EnvironmentObject var appSettings: UnsplashPhotoPickerAppSettings
    @Environment(\.dismiss) private var dismiss
    
    @State private var downloadHistory: [DownloadHistory] = []
    
    var body: some View {
        NavigationStack {
            if downloadHistory.isEmpty {
                emptyStateView
            } else {
                downloadHistoryList
            }
        }
        .onAppear {
            downloadHistory = appSettings.photoDownloadTracker.getDownloadHistory()
        }
    }
    
    private var emptyStateView: some View {
        VStack {
            Image(systemName: "arrow.down.circle")
                .font(.system(size: 48))
                .foregroundColor(.primaryGrey)
            Text("No downloads yet")
                .font(.poppinsMedium(size: 18))
                .foregroundColor(.primaryGrey)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var downloadHistoryList: some View {
        List(downloadHistory) { item in
            HStack(spacing: 12) {
                AsyncImage(url: URL(string: item.photoURL)) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .scaledToFill()
                    } else if phase.error != nil {
                        Color.primaryGrey
                    } else {
                        Color.gray.opacity(0.3)
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                            .redacted(reason: .placeholder)
                            .shimmering()
                    }
                }
                .frame(width: 60, height: 60)
                .cornerRadius(8)
                .clipped()
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.photographerName)
                        .font(.poppinsMedium(size: 16))
                        .foregroundColor(appSettings.isDarkMode ? .white : .primaryBlack)
                    
                    Text(item.date.formatted(date: .abbreviated, time: .shortened))
                        .font(.poppinsRegular(size: 12))
                        .foregroundColor(.primaryGrey)
                }
                
                Spacer()
            }
            .padding(.vertical, 4)
        }
        .listStyle(.plain)
    }
}

#Preview {
    DownloadsView()
        .environmentObject(UnsplashPhotoPickerAppSettings())
}
