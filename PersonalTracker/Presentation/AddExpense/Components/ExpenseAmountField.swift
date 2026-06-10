//
//  ExpenseAmountField.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Reusable amount input with numeric keyboard and currency-oriented styling.
public struct ExpenseAmountField: View {
    private let title: String
    private let placeholder: String
    private let amountText: Binding<String>
    
    public init(title: String, placeholder: String, amountText: Binding<String>) {
        self.title = title
        self.placeholder = placeholder
        self.amountText = amountText
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: "dollarsign.circle")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            
            HStack(spacing: 8) {
                Text("$")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.secondary)
                    .accessibilityHidden(true)
                
                TextField(placeholder, text: amountText)
                    .keyboardType(.decimalPad)
                    .font(.system(.title3, design: .rounded).weight(.semibold))
                    .accessibilityLabel(title)
            }
            .padding(14)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(.white.opacity(0.26), lineWidth: 1)
            )
        }
    }
}
