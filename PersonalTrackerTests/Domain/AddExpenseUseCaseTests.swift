//
//  AddExpenseUseCaseTests.swift
//  PersonalTrackerTests
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import XCTest
@testable import PersonalTracker

/// Unit tests covering AddExpenseUseCase validation and repository delegation.
final class AddExpenseUseCaseTests: XCTestCase {
    func testExecutePersistsValidExpense() async throws {
        let repository = MockExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: repository)
        let expense = Expense(title: "Coffee", amount: 4.50)
        
        try await useCase.execute(expense: expense)
        
        XCTAssertTrue(repository.didCallAddExpense)
        XCTAssertEqual(repository.lastAddedExpense, expense)
        XCTAssertEqual(repository.expenses, [expense])
    }
    
    func testExecuteRejectsEmptyTitle() async {
        let repository = MockExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: repository)
        let expense = Expense(title: "   ", amount: 10)
        
        do {
            try await useCase.execute(expense: expense)
            XCTFail("Expected empty title validation to throw.")
        } catch {
            XCTAssertFalse(repository.didCallAddExpense)
        }
    }
    
    func testExecuteRejectsZeroAmount() async {
        let repository = MockExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: repository)
        let expense = Expense(title: "Lunch", amount: 0)
        
        do {
            try await useCase.execute(expense: expense)
            XCTFail("Expected zero amount validation to throw.")
        } catch {
            XCTAssertFalse(repository.didCallAddExpense)
        }
    }
}
