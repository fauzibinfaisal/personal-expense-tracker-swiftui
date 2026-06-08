//
//  ExpenseSDModel.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation
import SwiftData

/// SwiftData persistent database model representing an Expense transaction record.
/// Contains converters to isolate SwiftData types from the Domain layer.
@Model
public final class ExpenseSDModel {
    @Attribute(.unique) public var id: UUID
    public var title: String
    /// Mapped as a String to ensure precision loss does not occur with floating-point structures.
    public var amountString: String
    public var currency: String
    public var date: Date
    public var categoryId: UUID?
    public var syncStatus: String
    
    public init(
        id: UUID,
        title: String,
        amount: Decimal,
        currency: String,
        date: Date,
        categoryId: UUID?,
        syncStatus: String
    ) {
        self.id = id
        self.title = title
        self.amountString = NSDecimalNumber(decimal: amount).stringValue
        self.currency = currency
        self.date = date
        self.categoryId = categoryId
        self.syncStatus = syncStatus
    }
}

public extension ExpenseSDModel {
    /// Maps this SwiftData model record to a clean Domain Entity instance.
    func toDomain() -> Expense {
        let decimalAmount = Decimal(string: amountString) ?? 0
        let status = Expense.SyncStatus(rawValue: syncStatus) ?? .localOnly
        return Expense(
            id: id,
            title: title,
            amount: decimalAmount,
            currency: currency,
            date: date,
            categoryId: categoryId,
            syncStatus: status
        )
    }
    
    /// Maps a pure Domain Entity instance to a SwiftData model record.
    static func fromDomain(_ domain: Expense) -> ExpenseSDModel {
        ExpenseSDModel(
            id: domain.id,
            title: domain.title,
            amount: domain.amount,
            currency: domain.currency,
            date: domain.date,
            categoryId: domain.categoryId,
            syncStatus: domain.syncStatus.rawValue
        )
    }
}
