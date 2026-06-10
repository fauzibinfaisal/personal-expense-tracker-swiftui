//
//  AppRootView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Root screen composition that connects app navigation, routing, and dependency injection.
public struct AppRootView: View {
    @StateObject private var router: AppRouter
    private let container: DependencyContainer
    
    @MainActor
    public init(
        container: DependencyContainer,
        router: AppRouter? = nil
    ) {
        self.container = container
        _router = StateObject(wrappedValue: router ?? AppRouter())
    }
    
    public var body: some View {
        NavigationStack(path: $router.path) {
            makeExpenseListView()
                .navigationDestination(for: AppRouter.Route.self) { route in
                    makeDestination(for: route)
                }
        }
        .environmentObject(router)
    }
    
    /// Composes the root expense list screen.
    private func makeExpenseListView() -> ExpenseListView {
        ExpenseListView(viewModel: container.makeExpenseListViewModel())
    }
    
    /// Composes a routed destination screen.
    /// - Parameter route: The route requested by AppRouter.
    @ViewBuilder
    private func makeDestination(for route: AppRouter.Route) -> some View {
        switch route {
        case .expenseList:
            makeExpenseListView()
        case .addExpense:
            AddExpenseView(
                viewModel: container.makeAddExpenseViewModel(),
                onSuccess: {
                    router.navigateBack()
                }
            )
        case .settings:
            ContentUnavailableView {
                Label("Settings", systemImage: "gearshape")
            } description: {
                Text("Configuration options coming soon.")
            }
        }
    }
}
