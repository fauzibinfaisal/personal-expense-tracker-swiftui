//
//  EmptyStateView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import SwiftUI

/// Empty state message with modern Liquid Glass styling.
public struct EmptyStateView: View {
    private let onAction: () -> Void
    
    public init(onAction: @escaping () -> Void) {
        self.onAction = onAction
    }
    
    public var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard.and.123")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(.secondary)
                .symbolEffect(.bounce, options: .repeating)
            
            VStack(spacing: 8) {
                Text("No Transactions Yet")
                    .font(.title3.bold())
                    .foregroundColor(.primary)
                Text("Your logged expenses will appear here. Start tracking today!")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
            .padding(.horizontal, 24)
            
            Button(action: onAction) {
                Text("Log First Expense")
                    .font(.headline)
                    .foregroundColor(.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(.ultraThinMaterial)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .stroke(.white.opacity(0.4), lineWidth: 1)
                    )
            }
        }
        .padding(32)
        .background(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(.thinMaterial)
                .shadow(color: .black.opacity(0.03), radius: 15, x: 0, y: 10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(.white.opacity(0.2), lineWidth: 1)
        )
        .padding(24)
    }
}
