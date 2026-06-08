//
//  CoreInterfaces.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import Foundation

/// Defines the protocol for logging application events and user analytics.
public protocol AnalyticsServiceProtocol: Sendable {
    /// Logs a specific event with relevant metadata.
    /// - Parameters:
    ///   - name: The name of the event (e.g., "expense_added").
    ///   - parameters: Key-value metadata describing the event context.
    func logEvent(_ name: String, parameters: [String: Any]?)
}

/// Defines the protocol for managing user authentication sessions.
public protocol AuthServiceProtocol: Sendable {
    /// Returns a boolean indicating if a user is authenticated.
    var isAuthenticated: Bool { get }
    
    /// Retrieves the current user's unique identifier.
    /// - Returns: A unique user identifier string.
    func getCurrentUserId() async throws -> String
}

/// Defines the protocol for backing up and synchronizing local data to a remote cloud source.
public protocol SyncEngineProtocol: Sendable {
    /// Initiates a background synchronization pass.
    func synchronize() async throws
}
