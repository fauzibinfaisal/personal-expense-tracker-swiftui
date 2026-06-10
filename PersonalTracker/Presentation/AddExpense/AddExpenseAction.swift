//
//  AddExpenseAction.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation

/// Explicit actions triggered by the user while adding a new expense.
public enum AddExpenseAction: Sendable {
    case updateTitle(String)
    case updateAmount(String)
    case updateDate(Date)
    case save
    case clearError
}
