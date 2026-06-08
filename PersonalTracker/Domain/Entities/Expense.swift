//
//  Expense.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Pure domain entity representing an Expense transaction.
/// Completely decoupled from persistence frameworks like SwiftData or CoreData.
public struct Expense: Identifiable, Codable, Equatable, Sendable {
    public let id: UUID
    public let title: String
    public let amount: Decimal
    public let currency: String
    public let date: Date
    public let categoryId: UUID?
    public let syncStatus: SyncStatus
    
    /// Sync states used for tracking local vs remote status in future cloud-sync integrations.
    public enum SyncStatus: String, Codable, Sendable {
        case localOnly
        case synced
        case pendingUpdate
        case pendingDelete
    }
    
    public init(
        id: UUID = UUID(),
        title: String,
        amount: Decimal,
        currency: String = "USD",
        date: Date = Date(),
        categoryId: UUID? = nil,
        syncStatus: SyncStatus = .localOnly
    ) {
        self.id = id
        self.title = title
        self.amount = amount
        self.currency = currency
        self.date = date
        self.categoryId = categoryId
        self.syncStatus = syncStatus
    }
}
