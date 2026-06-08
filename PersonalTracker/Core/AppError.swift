//
//  AppError.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Represents core application errors categorized by domain, designed for robust error handling.
public enum AppError: LocalizedError, Sendable {
    case database(DatabaseError)
    case network(NetworkError)
    case authentication(AuthenticationError)
    case validation(ValidationError)
    case unknown(Error)
    
    public enum DatabaseError: Sendable {
        case migrationFailed
        case saveFailed
        case fetchFailed
        case deletionFailed
        case notFound
    }
    
    public enum NetworkError: Sendable {
        case badURL
        case requestFailed
        case invalidResponse
        case unauthorized
        case serverError
    }
    
    public enum AuthenticationError: Sendable {
        case unauthenticated
        case sessionExpired
        case keychainError
    }
    
    public enum ValidationError: Sendable {
        case invalidAmount
        case invalidTitle
        case invalidCategory
    }
    
    public var errorDescription: String? {
        switch self {
        case .database(let error):
            return "Database failure: \(error)"
        case .network(let error):
            return "Network failure: \(error)"
        case .authentication(let error):
            return "Authentication failure: \(error)"
        case .validation(let error):
            return "Validation failure: \(error)"
        case .unknown(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
