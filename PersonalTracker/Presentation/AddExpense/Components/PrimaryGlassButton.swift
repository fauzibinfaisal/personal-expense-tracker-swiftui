//
//  PrimaryGlassButton.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Reusable primary action button using modern glass material treatment.
public struct PrimaryGlassButton: View {
    private let title: String
    private let systemImage: String
    private let action: () -> Void
    
    public init(title: String, systemImage: String, action: @escaping () -> Void) {
        self.title = title
        self.systemImage = systemImage
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.headline)
                .foregroundColor(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.34), lineWidth: 1)
                )
                .shadow(color: .black.opacity(0.04), radius: 14, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(title)
    }
}
