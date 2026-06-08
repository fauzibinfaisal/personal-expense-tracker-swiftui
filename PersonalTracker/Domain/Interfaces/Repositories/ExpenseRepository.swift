//
//  ExpenseRepository.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Protocol specifying the data store operations for Expenses, adhering to the Repository Pattern.
public protocol ExpenseRepository: Sendable {
    /// Retrieves all logged expenses.
    /// - Returns: An array of Domain Expense models.
    func getExpenses() async throws -> [Expense]
    
    /// Persists a new or modified expense.
    /// - Parameter expense: The Domain Expense model to add.
    func addExpense(_ expense: Expense) async throws
    
    /// Removes an expense by its unique identifier.
    /// - Parameter id: The UUID of the expense to delete.
    func deleteExpense(id: UUID) async throws
}
