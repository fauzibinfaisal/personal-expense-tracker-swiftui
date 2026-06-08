//
//  ExpenseCard.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import SwiftUI

/// Item row displaying expense transaction details using Liquid Glass style tokens.
public struct ExpenseCard: View {
    private let expense: Expense
    
    public init(expense: Expense) {
        self.expense = expense
    }
    
    public var body: some View {
        HStack(spacing: 16) {
            // Visual Indicator for Category (Liquid Circle icon background)
            ZStack {
                Circle()
                    .fill(.white.opacity(0.12))
                    .frame(width: 44, height: 44)
                
                Image(systemName: categoryIcon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(.primary)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(expense.title)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(expense.date, style: .date)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            // Amount
            Text(expense.amount, format: .currency(code: expense.currency))
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
                .foregroundColor(.primary)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(.ultraThinMaterial)
                .shadow(color: .black.opacity(0.03), radius: 8, x: 0, y: 4)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.3), lineWidth: 1)
        )
    }
    
    private var categoryIcon: String {
        let title = expense.title.lowercased()
        if title.contains("coffee") || title.contains("starbucks") || title.contains("cafe") {
            return "cup.and.saucer"
        } else if title.contains("food") || title.contains("restaurant") || title.contains("dinner") || title.contains("lunch") || title.contains("pizza") {
            return "fork.knife"
        } else if title.contains("uber") || title.contains("taxi") || title.contains("lyft") || title.contains("gas") || title.contains("train") {
            return "car.fill"
        } else if title.contains("movie") || title.contains("netflix") || title.contains("cinema") || title.contains("show") {
            return "play.tv.fill"
        } else if title.contains("grocery") || title.contains("groceries") || title.contains("supermarket") {
            return "cart.fill"
        } else {
            return "bag.fill"
        }
    }
}
