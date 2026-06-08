//
//  DefaultExpenseRepository.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation
import SwiftData

/// Concrete implementation of the ExpenseRepository protocol, backed by SwiftData persistence.
public final class DefaultExpenseRepository: ExpenseRepository {
    private let modelContainer: ModelContainer
    
    public init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }
    
    @MainActor
    public func getExpenses() async throws -> [Expense] {
        let context = modelContainer.mainContext
        let descriptor = FetchDescriptor<ExpenseSDModel>(sortBy: [SortDescriptor(\.date, order: .reverse)])
        do {
            let records = try context.fetch(descriptor)
            return records.map { $0.toDomain() }
        } catch {
            throw AppError.database(.fetchFailed)
        }
    }
    
    @MainActor
    public func addExpense(_ expense: Expense) async throws {
        let context = modelContainer.mainContext
        let record = ExpenseSDModel.fromDomain(expense)
        context.insert(record)
        do {
            try context.save()
        } catch {
            throw AppError.database(.saveFailed)
        }
    }
    
    @MainActor
    public func deleteExpense(id: UUID) async throws {
        let context = modelContainer.mainContext
        let recordId = id
        let descriptor = FetchDescriptor<ExpenseSDModel>(predicate: #Predicate { $0.id == recordId })
        do {
            if let record = try context.fetch(descriptor).first {
                context.delete(record)
                try context.save()
            } else {
                throw AppError.database(.notFound)
            }
        } catch {
            throw AppError.database(.deletionFailed)
        }
    }
}
