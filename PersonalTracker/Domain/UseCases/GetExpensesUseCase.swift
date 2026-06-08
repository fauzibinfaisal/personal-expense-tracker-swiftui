//
//  GetExpensesUseCase.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Interface defining the contract for retrieving stored expenses.
public protocol GetExpensesUseCase: Sendable {
    /// Executes the business logic to retrieve all expenses.
    /// - Returns: An array of Domain Expense models.
    func execute() async throws -> [Expense]
}

/// Concrete execution engine for retrieving expenses.
public final class DefaultGetExpensesUseCase: GetExpensesUseCase {
    private let repository: any ExpenseRepository
    
    public init(repository: any ExpenseRepository) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Expense] {
        try await repository.getExpenses()
    }
}
