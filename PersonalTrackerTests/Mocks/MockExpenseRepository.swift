//
//  MockExpenseRepository.swift
//  PersonalTrackerTests
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation
@testable import PersonalTracker

/// In-memory repository test double that avoids SwiftData and supports deterministic unit tests.
final class MockExpenseRepository: ExpenseRepository, @unchecked Sendable {
    private(set) var didCallGetExpenses = false
    private(set) var didCallAddExpense = false
    private(set) var didCallDeleteExpense = false
    private(set) var lastAddedExpense: Expense?
    private(set) var lastDeletedExpenseId: UUID?
    
    var expenses: [Expense]
    var errorToThrow: Error?
    
    init(expenses: [Expense] = [], errorToThrow: Error? = nil) {
        self.expenses = expenses
        self.errorToThrow = errorToThrow
    }
    
    /// Returns configured expenses or throws a configured error.
    func getExpenses() async throws -> [Expense] {
        didCallGetExpenses = true
        if let errorToThrow {
            throw errorToThrow
        }
        return expenses
    }
    
    /// Stores the provided expense in memory or throws a configured error.
    func addExpense(_ expense: Expense) async throws {
        didCallAddExpense = true
        lastAddedExpense = expense
        if let errorToThrow {
            throw errorToThrow
        }
        expenses.append(expense)
    }
    
    /// Deletes an expense from memory by identifier or throws a configured error.
    func deleteExpense(id: UUID) async throws {
        didCallDeleteExpense = true
        lastDeletedExpenseId = id
        if let errorToThrow {
            throw errorToThrow
        }
        expenses.removeAll { $0.id == id }
    }
}
