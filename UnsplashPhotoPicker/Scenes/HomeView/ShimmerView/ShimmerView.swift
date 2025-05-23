//
//  ShimmerView.swift
//  UnsplashPhotoPicker
//
//  Created by MacBook on 23.05.25.
//

import SwiftUI

struct ShimmerView: ViewModifier {
    @State private var phase: CGFloat = 0
    
    func body(content: Content) -> some View {
        content
            .overlay(
                LinearGradient(gradient: Gradient(colors: [Color.clear, Color.white.opacity(0.4), Color.clear]),
                               startPoint: .leading,
                               endPoint: .trailing)
                .rotationEffect(.degrees(30))
                .offset(x: phase)
                .mask(content)
            )
            .onAppear {
                withAnimation(.linear(duration: 1.0).repeatForever(autoreverses: false)) {
                    phase = 350
                }
            }
    }
}

extension View {
    func shimmering() -> some View {
        self.modifier(ShimmerView())
    }
}
