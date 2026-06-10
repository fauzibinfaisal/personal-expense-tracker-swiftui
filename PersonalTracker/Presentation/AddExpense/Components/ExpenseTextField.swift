//
//  ExpenseTextField.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Reusable text input styled for expense form fields.
public struct ExpenseTextField: View {
    private let title: String
    private let placeholder: String
    private let text: Binding<String>
    private let systemImage: String
    
    public init(title: String, placeholder: String, text: Binding<String>, systemImage: String) {
        self.title = title
        self.placeholder = placeholder
        self.text = text
        self.systemImage = systemImage
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: systemImage)
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            
            TextField(placeholder, text: text)
                .textInputAutocapitalization(.words)
                .submitLabel(.next)
                .padding(14)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(.white.opacity(0.26), lineWidth: 1)
                )
                .accessibilityLabel(title)
        }
    }
}
