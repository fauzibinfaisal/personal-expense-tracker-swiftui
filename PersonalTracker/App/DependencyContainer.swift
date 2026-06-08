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
    
    public let modelContainer: ModelContainer
    private let expenseRepository: any ExpenseRepository
    
    private init() {
        do {
            let schema = Schema([ExpenseSDModel.self])
            let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
            self.modelContainer = try ModelContainer(for: schema, configurations: [config])
            self.expenseRepository = DefaultExpenseRepository(modelContainer: modelContainer)
        } catch {
            fatalError("Failed to initialize SwiftData ModelContainer: \(error)")
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
}
