//
//  DependencyContainer.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation
import SwiftData

/// MainActor-isolated dependency injection container.
/// Handles instantiation and lifetime management of app-wide services, data sources, and use cases.
@MainActor
public final class DependencyContainer {
    /// Singleton access point for dependency resolution.
    public static let shared = DependencyContainer()
    
    private let swiftDataStack: SwiftDataStack
    public let modelContainer: ModelContainer
    private let expenseRepository: any ExpenseRepository
    
    private init() {
        do {
            self.swiftDataStack = try SwiftDataStack()
            self.modelContainer = swiftDataStack.modelContainer
            self.expenseRepository = ExpenseRepositoryImpl(modelContainer: modelContainer)
        } catch {
            fatalError("Failed to initialize local persistence: \(error.localizedDescription)")
        }
    }
    
    /// Resolves and provides the use case for loading expense listings.
    public func makeGetExpensesUseCase() -> any GetExpensesUseCase {
        DefaultGetExpensesUseCase(repository: expenseRepository)
    }
    
    /// Resolves and provides the use case for adding new expenses.
    public func makeAddExpenseUseCase() -> any AddExpenseUseCase {
        DefaultAddExpenseUseCase(repository: expenseRepository)
    }
    
    /// Resolves and provides the ViewModel driving the Expense List presentation interface.
    public func makeExpenseListViewModel() -> ExpenseListViewModel {
        ExpenseListViewModel(
            getExpensesUseCase: makeGetExpensesUseCase()
        )
    }
    
    /// Resolves and provides the ViewModel driving the Add Expense presentation interface.
    public func makeAddExpenseViewModel() -> AddExpenseViewModel {
        AddExpenseViewModel(
            addExpenseUseCase: makeAddExpenseUseCase()
        )
    }
}
