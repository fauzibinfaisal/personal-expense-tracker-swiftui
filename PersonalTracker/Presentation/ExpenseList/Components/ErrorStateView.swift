//
//  ErrorStateView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import SwiftUI

/// Error visual state container with modern Liquid Glass borders and retry button.
public struct ErrorStateView: View {
    private let errorMessage: String
    private let onRetry: () -> Void
    
    public init(errorMessage: String, onRetry: @escaping () -> Void) {
        self.errorMessage = errorMessage
        self.onRetry = onRetry
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.system(size: 40))
                .foregroundColor(.red.opacity(0.8))
            
            VStack(spacing: 8) {
                Text("Something went wrong")
                    .font(.headline)
                    .foregroundColor(.primary)
                Text(errorMessage)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 16)
            
            Button(action: onRetry) {
                HStack(spacing: 8) {
                    Image(systemName: "arrow.clockwise")
                    Text("Retry")
                }
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .fill(.ultraThinMaterial)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.white.opacity(0.4), lineWidth: 1)
                )
            }
        }
        .padding(28)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .red.opacity(0.05), radius: 20, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.15), lineWidth: 1)
        )
        .padding(24)
    }
}
