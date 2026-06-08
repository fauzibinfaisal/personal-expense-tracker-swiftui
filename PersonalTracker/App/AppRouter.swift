//
//  AppRouter.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import SwiftUI
import Combine

/// Thread-safe MainActor-isolated router managing app-wide navigation pathways and stack states.
@MainActor
public final class AppRouter: ObservableObject {
    @Published public var path = NavigationPath()
    
    /// Enumerated navigation targets supporting type-safe routing.
    public enum Route: Hashable, Sendable {
        case expenseList
        case addExpense
        case settings
    }
    
    public init() {}
    
    /// Navigates to a designated destination route.
    /// - Parameter route: The destination Route.
    public func navigate(to route: Route) {
        path.append(route)
    }
    
    /// Navigates back one step in stack hierarchy.
    public func navigateBack() {
        if !path.isEmpty {
            path.removeLast()
        }
    }
    
    /// Clears the navigation stack, returning to the root view.
    public func navigateToRoot() {
        if !path.isEmpty {
            path.removeLast(path.count)
        }
    }
}
