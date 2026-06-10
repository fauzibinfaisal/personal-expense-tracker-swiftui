//
//  ExpenseRepositoryImpl.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation
import SwiftData

/// SwiftData implementation of ExpenseRepository for local expense persistence.
public final class ExpenseRepositoryImpl: ExpenseRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    /// Retrieves all saved expenses sorted by newest transaction date first.
    public func getExpenses() async throws -> [Expense] {
        try await MainActor.run {
            let context = modelContainer.mainContext
            let descriptor = FetchDescriptor<ExpenseEntity>(
                sortBy: [SortDescriptor(\.date, order: .reverse)]
            )
            
            do {
                let entities = try context.fetch(descriptor)
                return try entities.map { try $0.toDomain() }
            } catch let error as PersistenceError {
                throw error
            } catch {
                throw PersistenceError.fetchFailed
            }
        }
    }
    
    /// Persists a new expense entity to the local SwiftData store.
    public func addExpense(_ expense: Expense) async throws {
        try await MainActor.run {
            let context = modelContainer.mainContext
            let entity = ExpenseEntity.fromDomain(expense)
            context.insert(entity)
            
            do {
                try context.save()
            } catch {
                throw PersistenceError.saveFailed
            }
        }
    }
    
    /// Deletes an expense from the local SwiftData store by identifier.
    public func deleteExpense(id: UUID) async throws {
        try await MainActor.run {
            let context = modelContainer.mainContext
            let expenseId = id
            let descriptor = FetchDescriptor<ExpenseEntity>(
                predicate: #Predicate { entity in
                    entity.id == expenseId
                }
            )
            
            do {
                guard let entity = try context.fetch(descriptor).first else {
                    throw PersistenceError.expenseNotFound
                }
                
                context.delete(entity)
                try context.save()
            } catch let error as PersistenceError {
                throw error
            } catch {
                throw PersistenceError.deleteFailed
            }
        }
    }
}

/// Backward-compatible alias for the initial scaffolded repository name.
public typealias DefaultExpenseRepository = ExpenseRepositoryImpl
