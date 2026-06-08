//
//  ExpenseUseCaseTests.swift
//  PersonalTrackerTests
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Testing
import Foundation
@testable import PersonalTracker

struct ExpenseUseCaseTests {
    
    /// Stub repository implementation to support testing without importing external libraries.
    final class StubExpenseRepository: ExpenseRepository, @unchecked Sendable {
        var expenses: [Expense] = []
        var didCallGetExpenses = false
        var didCallAddExpense = false
        var lastAddedExpense: Expense?
        var shouldThrowError = false
        
        func getExpenses() async throws -> [Expense] {
            didCallGetExpenses = true
            if shouldThrowError {
                throw AppError.database(.fetchFailed)
            }
            return expenses
        }
        
        func addExpense(_ expense: Expense) async throws {
            didCallAddExpense = true
            lastAddedExpense = expense
            expenses.append(expense)
        }
        
        func deleteExpense(id: UUID) async throws {
            expenses.removeAll { $0.id == id }
        }
    }
    
    @Test func testAddExpenseValidationSucceedsForValidInput() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: stubRepository)
        let validExpense = Expense(title: "Valid Expense", amount: 19.99)
        
        try await useCase.execute(expense: validExpense)
        
        #expect(stubRepository.didCallAddExpense)
        #expect(stubRepository.lastAddedExpense?.title == "Valid Expense")
        #expect(stubRepository.lastAddedExpense?.amount == 19.99)
    }
    
    @Test func testAddExpenseValidationFailsForZeroOrNegativeAmount() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: stubRepository)
        
        let invalidExpense = Expense(title: "Invalid Expense", amount: 0.0)
        
        await #expect(throws: AppError.self) {
            try await useCase.execute(expense: invalidExpense)
        }
    }
    
    @Test func testAddExpenseValidationFailsForEmptyTitle() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultAddExpenseUseCase(repository: stubRepository)
        
        let invalidExpense = Expense(title: "  ", amount: 5.0)
        
        await #expect(throws: AppError.self) {
            try await useCase.execute(expense: invalidExpense)
        }
    }
    
    @Test func testGetExpensesReturnsList() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultGetExpensesUseCase(repository: stubRepository)
        let sampleExpense = Expense(title: "Coffee", amount: 4.50)
        stubRepository.expenses = [sampleExpense]
        
        let result = try await useCase.execute()
        
        #expect(stubRepository.didCallGetExpenses)
        #expect(result.count == 1)
        #expect(result.first?.title == "Coffee")
    }
    
    @Test func testViewModelInitialStateIsIdle() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultGetExpensesUseCase(repository: stubRepository)
        let viewModel = await ExpenseListViewModel(getExpensesUseCase: useCase)
        
        let initialState = await viewModel.state
        #expect(initialState == .idle)
    }
    
    @Test func testViewModelStateTransitionsToLoadedWhenExpensesExist() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultGetExpensesUseCase(repository: stubRepository)
        let viewModel = await ExpenseListViewModel(getExpensesUseCase: useCase)
        
        let sampleExpense = Expense(title: "Gas bill", amount: 45.0)
        stubRepository.expenses = [sampleExpense]
        
        await viewModel.send(.load)
        
        let finalState = await viewModel.state
        #expect(finalState == .loaded([sampleExpense]))
    }
    
    @Test func testViewModelStateTransitionsToEmptyWhenNoExpenses() async throws {
        let stubRepository = StubExpenseRepository()
        let useCase = DefaultGetExpensesUseCase(repository: stubRepository)
        let viewModel = await ExpenseListViewModel(getExpensesUseCase: useCase)
        
        await viewModel.send(.load)
        
        let finalState = await viewModel.state
        #expect(finalState == .empty)
    }
    
    @Test func testViewModelStateTransitionsToErrorWhenRepositoryThrows() async throws {
        let stubRepository = StubExpenseRepository()
        stubRepository.shouldThrowError = true
        let useCase = DefaultGetExpensesUseCase(repository: stubRepository)
        let viewModel = await ExpenseListViewModel(getExpensesUseCase: useCase)
        
        await viewModel.send(.load)
        
        let finalState = await viewModel.state
        switch finalState {
        case .error(let message):
            #expect(!message.isEmpty)
        default:
            Issue.record("Expected state to be error, but got \(finalState)")
        }
    }
}
