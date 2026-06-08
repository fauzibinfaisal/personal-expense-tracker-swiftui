//
//  ExpenseListState.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import Foundation

/// Explicit state representation for the Expense List screen.
/// Prevents conflicting states and eliminates boolean flags.
public enum ExpenseListState: Equatable, Sendable {
    case idle
    case loading
    case loaded([Expense])
    case empty
    case error(String)
}
