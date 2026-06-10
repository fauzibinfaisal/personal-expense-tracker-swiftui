//
//  ExpenseDatePicker.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Reusable date picker for expense transaction dates.
public struct ExpenseDatePicker: View {
    private let title: String
    private let date: Binding<Date>
    
    public init(title: String, date: Binding<Date>) {
        self.title = title
        self.date = date
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label(title, systemImage: "calendar")
                .font(.subheadline.weight(.semibold))
                .foregroundColor(.secondary)
            
            DatePicker(title, selection: date, displayedComponents: .date)
                .labelsHidden()
                .datePickerStyle(.compact)
                .frame(maxWidth: .infinity, alignment: .leading)
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
