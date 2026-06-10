//
//  ExpenseEntity.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation
import SwiftData

/// SwiftData-backed persistence entity for storing expense transactions locally.
/// Mapping helpers keep the Domain Expense model independent from SwiftData.
@Model
public final class ExpenseEntity {
    @Attribute(.unique) public var id: UUID
    public var title: String
    public var amountValue: String
    public var currency: String
    public var date: Date
    public var categoryId: UUID?
    public var syncStatusValue: String
    
    public init(
        id: UUID,
        title: String,
        amountValue: String,
        currency: String,
        date: Date,
        categoryId: UUID?,
        syncStatusValue: String
    ) {
        self.id = id
        self.title = title
        self.amountValue = amountValue
        self.currency = currency
        self.date = date
        self.categoryId = categoryId
        self.syncStatusValue = syncStatusValue
    }
}

public extension ExpenseEntity {
    /// Maps this SwiftData entity to a pure Domain model.
    /// - Returns: A Domain Expense value.
    func toDomain() throws -> Expense {
        guard let amount = Decimal(string: amountValue, locale: Locale(identifier: "en_US_POSIX")) else {
            throw PersistenceError.mappingFailed
        }
        
        let syncStatus = Expense.SyncStatus(rawValue: syncStatusValue) ?? .localOnly
        
        return Expense(
            id: id,
            title: title,
            amount: amount,
            currency: currency,
            date: date,
            categoryId: categoryId,
            syncStatus: syncStatus
        )
    }
    
    /// Maps a pure Domain model to a SwiftData entity.
    /// - Parameter expense: The Domain Expense value to persist.
    static func fromDomain(_ expense: Expense) -> ExpenseEntity {
        ExpenseEntity(
            id: expense.id,
            title: expense.title,
            amountValue: NSDecimalNumber(decimal: expense.amount).stringValue,
            currency: expense.currency,
            date: expense.date,
            categoryId: expense.categoryId,
            syncStatusValue: expense.syncStatus.rawValue
        )
    }
}

/// Backward-compatible alias for the initial scaffolded SwiftData model name.
public typealias ExpenseSDModel = ExpenseEntity
