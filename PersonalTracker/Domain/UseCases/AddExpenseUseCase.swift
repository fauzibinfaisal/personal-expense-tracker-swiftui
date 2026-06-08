//
//  AddExpenseUseCase.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Interface defining the contract for inserting a new expense transaction.
public protocol AddExpenseUseCase: Sendable {
    /// Executes the business logic for adding a new expense.
    /// - Parameter expense: The Domain Expense model to add.
    func execute(expense: Expense) async throws
}

/// Concrete execution engine for adding expenses, validating content integrity before persistence.
public final class DefaultAddExpenseUseCase: AddExpenseUseCase {
    private let repository: any ExpenseRepository
    
    public init(repository: any ExpenseRepository) {
        self.repository = repository
    }
    
    public func execute(expense: Expense) async throws {
        // Enforce basic business validation rules
        guard expense.amount > 0 else {
            throw AppError.validation(.invalidAmount)
        }
        guard !expense.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw AppError.validation(.invalidTitle)
        }
        try await repository.addExpense(expense)
    }
}
