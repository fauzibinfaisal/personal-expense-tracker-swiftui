//
//  PersonalTrackerApp.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 08/06/26.
//

import SwiftUI
import SwiftData

@main
struct PersonalTrackerApp: App {
    @StateObject private var router = AppRouter()
    private let container = DependencyContainer.shared
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                ExpenseListView(viewModel: container.makeExpenseListViewModel())
                    .navigationDestination(for: AppRouter.Route.self) { route in
                        switch route {
                        case .expenseList:
                            ExpenseListView(viewModel: container.makeExpenseListViewModel())
                        case .addExpense:
                            // Ready for future presentation view integration
                            ContentUnavailableView {
                                Label("Add Expense", systemImage: "plus.circle")
                            } description: {
                                Text("Feature coming soon.")
                            }
                        case .settings:
                            ContentUnavailableView {
                                Label("Settings", systemImage: "gearshape")
                            } description: {
                                Text("Configuration options coming soon.")
                            }
                        }
                    }
            }
            .environmentObject(router)
        }
        .modelContainer(container.modelContainer)
    }
}
