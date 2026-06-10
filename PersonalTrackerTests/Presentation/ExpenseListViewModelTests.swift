//
//  ExpenseListViewModelTests.swift
//  PersonalTrackerTests
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import XCTest
@testable import PersonalTracker

/// Unit tests covering ExpenseListViewModel state transitions through dependency injection.
@MainActor
final class ExpenseListViewModelTests: XCTestCase {
    func testInitialStateIsIdle() {
        let viewModel = makeViewModel()
        
        XCTAssertEqual(viewModel.state, .idle)
    }
    
    func testLoadTransitionsToLoadedWhenExpensesExist() async {
        let expense = Expense(title: "Dinner", amount: 24.99)
        let viewModel = makeViewModel(expenses: [expense])
        
        await viewModel.perform(.load)
        
        XCTAssertEqual(viewModel.state, .loaded([expense]))
    }
    
    func testLoadTransitionsToEmptyWhenRepositoryReturnsNoExpenses() async {
        let viewModel = makeViewModel()
        
        await viewModel.perform(.load)
        
        XCTAssertEqual(viewModel.state, .empty)
    }
    
    func testRefreshTransitionsToErrorWhenRepositoryThrows() async {
        let viewModel = makeViewModel(errorToThrow: PersistenceError.fetchFailed)
        
        await viewModel.perform(.refresh)
        
        switch viewModel.state {
        case .error(let message):
            XCTAssertFalse(message.isEmpty)
        default:
            XCTFail("Expected error state, got \(viewModel.state).")
        }
    }
    
    /// Creates a ViewModel with an in-memory repository and no SwiftData dependency.
    private func makeViewModel(
        expenses: [Expense] = [],
        errorToThrow: Error? = nil
    ) -> ExpenseListViewModel {
        let repository = MockExpenseRepository(
            expenses: expenses,
            errorToThrow: errorToThrow
        )
        let useCase = DefaultGetExpensesUseCase(repository: repository)
        return ExpenseListViewModel(getExpensesUseCase: useCase)
    }
}
