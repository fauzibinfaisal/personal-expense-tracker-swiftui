//
//  PersistenceError.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation

/// Errors produced by the local persistence layer.
/// Keeps SwiftData-specific failures isolated from the Domain layer.
public enum PersistenceError: LocalizedError, Sendable, Equatable {
    case containerInitializationFailed
    case fetchFailed
    case saveFailed
    case deleteFailed
    case expenseNotFound
    case mappingFailed
    
    public var errorDescription: String? {
        switch self {
        case .containerInitializationFailed:
            return "Unable to initialize the local expense database."
        case .fetchFailed:
            return "Unable to load saved expenses."
        case .saveFailed:
            return "Unable to save the expense."
        case .deleteFailed:
            return "Unable to delete the expense."
        case .expenseNotFound:
            return "The requested expense could not be found."
        case .mappingFailed:
            return "Unable to read the saved expense data."
        }
    }
}
