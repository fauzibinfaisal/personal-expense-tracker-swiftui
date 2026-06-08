//
//  ExpenseListAction.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import Foundation

/// Explicit actions triggered by the user or system to request updates on the Expense List screen.
public enum ExpenseListAction: Sendable {
    case load
    case refresh
    case selectExpense(Expense)
    case addExpensePlaceholder
}
