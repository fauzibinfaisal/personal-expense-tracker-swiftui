//
//  ValidationMessageView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Inline validation message presented beneath the form.
public struct ValidationMessageView: View {
    private let message: String
    
    public init(message: String) {
        self.message = message
    }
    
    public var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "exclamationmark.circle.fill")
                .foregroundColor(.red)
                .accessibilityHidden(true)
            
            Text(message)
                .font(.subheadline)
                .foregroundColor(.primary)
            
            Spacer(minLength: 0)
        }
        .padding(12)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(.red.opacity(0.24), lineWidth: 1)
        )
        .accessibilityElement(children: .combine)
    }
}
