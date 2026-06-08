//
//  LoadingView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import SwiftUI

/// Modern Liquid Glass loading indicator overlay.
public struct LoadingView: View {
    public init() {}
    
    public var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .scaleEffect(1.2)
                .tint(.primary)
            
            Text("Loading expenses...")
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 5)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
    }
}
