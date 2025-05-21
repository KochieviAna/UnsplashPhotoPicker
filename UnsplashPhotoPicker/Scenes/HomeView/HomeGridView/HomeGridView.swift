//
//  HomeGridView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 21.05.25.
//

import SwiftUI

struct HomeGridView: View {
    @State private var selectedCategory: String = "All"
    @State private var buttonFrames: [CGRect] = Array(repeating: .zero, count: 8)
    private let categories = ["All", "Nature", "People", "Architecture", "Animals", "Food", "Travel", "Fashion"]
    
    let allImages = (1...20).map { _ in CGFloat.random(in: 150...300) }
    let natureImages = (1...15).map { _ in CGFloat.random(in: 200...350) }
    let peopleImages = (1...12).map { _ in CGFloat.random(in: 180...320) }
    
    private let columns = [GridItem(.flexible())]
    
    var currentImages: [CGFloat] {
        switch selectedCategory {
        case "All": return allImages
        case "Nature": return natureImages
        case "People": return peopleImages
        default: return allImages
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            categoryPicker
            
            ScrollView {
                LazyVGrid(columns: columns, spacing: 2) {
                    ForEach(currentImages.indices, id: \.self) { index in
                        NavigationLink(destination: ImageDetailsView(height: currentImages[index])) {
                            PlaceholderImageView(height: currentImages[index])
                        }
                    }
                }
                .padding(.horizontal, 5)
            }
        }
    }
    
    private var categoryPicker: some View {
        VStack(spacing: 0) {
            GeometryReader { geometry in
                ScrollViewReader { proxy in
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 20) {
                            ForEach(Array(categories.enumerated()), id: \.element) { index, category in
                                categoryButton(category: category, index: index)
                                    .background(
                                        GeometryReader { buttonGeometry in
                                            Color.clear
                                                .preference(
                                                    key: ButtonFramesPreferenceKey.self,
                                                    value: [index: buttonGeometry.frame(in: .global)]
                                                )
                                        }
                                    )
                            }
                        }
                        .padding(.horizontal, 16)
                        .onPreferenceChange(ButtonFramesPreferenceKey.self) { frames in
                            for (index, frame) in frames {
                                buttonFrames[index] = frame
                            }
                        }
                    }
                    .frame(height: 50)
                    .onChange(of: selectedCategory) {
                        withAnimation {
                            proxy.scrollTo(selectedCategory, anchor: .center)
                        }
                    }
                }
            }
            .frame(height: 50)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(.gray.opacity(0.3))
                
                if let selectedIndex = categories.firstIndex(of: selectedCategory),
                   selectedIndex < buttonFrames.count {
                    Rectangle()
                        .frame(width: buttonFrames[selectedIndex].width, height: 2)
                        .foregroundColor(.primaryBlack)
                        .offset(x: buttonFrames[selectedIndex].minX - 16)
                        .animation(.easeInOut(duration: 0.3), value: selectedCategory)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
    }
    
    private func categoryButton(category: String, index: Int) -> some View {
        Button(action: {
            withAnimation {
                selectedCategory = category
            }
        }) {
            Text(category)
                .font(.system(size: 16, weight: selectedCategory == category ? .bold : .regular))
                .foregroundColor(selectedCategory == category ? .primaryBlack : .gray)
                .padding(.vertical, 8)
                .id(category)
        }
    }
}


struct ButtonFramesPreferenceKey: PreferenceKey {
    static var defaultValue: [Int: CGRect] = [:]
    
    static func reduce(value: inout [Int: CGRect], nextValue: () -> [Int: CGRect]) {
        value.merge(nextValue(), uniquingKeysWith: { $1 })
    }
}

#Preview {
    HomeGridView()
}
