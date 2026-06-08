//
//  ExpenseListViewModel.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import Foundation
import Combine

/// MainActor-isolated ViewModel managing the state machine and actions of the Expense List display.
@MainActor
public final class ExpenseListViewModel: ObservableObject {
    /// Explicit, single-source-of-truth UI state.
    @Published public private(set) var state: ExpenseListState = .idle
    
    private let getExpensesUseCase: any GetExpensesUseCase
    
    public init(getExpensesUseCase: any GetExpensesUseCase) {
        self.getExpensesUseCase = getExpensesUseCase
    }
    
    /// Processes inbound user intents or system actions.
    /// - Parameter action: The Action to execute.
    public func send(_ action: ExpenseListAction) {
        switch action {
        case .load, .refresh:
            Task {
                await fetchExpenses()
            }
        case .selectExpense:
            // Intent placeholder for future details navigation
            break
        case .addExpensePlaceholder:
            // Intent placeholder for future creation flow
            break
        }
    }
    
    private func fetchExpenses() async {
        state = .loading
        do {
            let list = try await getExpensesUseCase.execute()
            if list.isEmpty {
                state = .empty
            } else {
                state = .loaded(list)
            }
        } catch {
            state = .error(error.localizedDescription)
        }
    }
}
