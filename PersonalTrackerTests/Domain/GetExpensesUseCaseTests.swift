//
//  GetExpensesUseCaseTests.swift
//  PersonalTrackerTests
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import XCTest
@testable import PersonalTracker

/// Unit tests covering GetExpensesUseCase repository delegation.
final class GetExpensesUseCaseTests: XCTestCase {
    func testExecuteReturnsRepositoryExpenses() async throws {
        let expectedExpenses = [
            Expense(title: "Groceries", amount: 38.20),
            Expense(title: "Transit", amount: 2.75)
        ]
        let repository = MockExpenseRepository(expenses: expectedExpenses)
        let useCase = DefaultGetExpensesUseCase(repository: repository)
        
        let result = try await useCase.execute()
        
        XCTAssertTrue(repository.didCallGetExpenses)
        XCTAssertEqual(result, expectedExpenses)
    }
    
    func testExecutePropagatesRepositoryError() async {
        let repository = MockExpenseRepository(errorToThrow: PersistenceError.fetchFailed)
        let useCase = DefaultGetExpensesUseCase(repository: repository)
        
        do {
            _ = try await useCase.execute()
            XCTFail("Expected repository error to propagate.")
        } catch {
            XCTAssertTrue(repository.didCallGetExpenses)
        }
    }
}
