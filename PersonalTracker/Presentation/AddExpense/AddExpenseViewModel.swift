//
//  AddExpenseViewModel.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation
import Combine

/// MainActor-isolated ViewModel responsible for form state, validation, and save orchestration.
@MainActor
public final class AddExpenseViewModel: ObservableObject {
    /// Explicit, single-source-of-truth UI state.
    @Published public private(set) var state: AddExpenseState = .editing(AddExpenseFormData(), validationMessages: [])
    
    private let addExpenseUseCase: any AddExpenseUseCase
    
    public init(addExpenseUseCase: any AddExpenseUseCase) {
        self.addExpenseUseCase = addExpenseUseCase
    }
    
    /// Processes inbound user intents and system actions.
    /// - Parameter action: The action to execute.
    public func send(_ action: AddExpenseAction) {
        switch action {
        case .updateTitle(let title):
            updateForm { $0.title = title }
        case .updateAmount(let amount):
            updateForm { $0.amountText = sanitizedAmountInput(amount) }
        case .updateDate(let date):
            updateForm { $0.date = date }
        case .save:
            Task {
                await saveExpense()
            }
        case .clearError:
            state = .editing(state.formData, validationMessages: state.validationMessages)
        }
    }
    
    private func updateForm(_ mutate: (inout AddExpenseFormData) -> Void) {
        var formData = state.formData
        mutate(&formData)
        state = .editing(formData, validationMessages: [])
    }
    
    private func saveExpense() async {
        let formData = state.formData
        let validationMessages = validate(formData)
        
        guard validationMessages.isEmpty, let amount = decimalAmount(from: formData.amountText) else {
            state = .editing(formData, validationMessages: validationMessages)
            return
        }
        
        state = .loading(formData)
        
        do {
            let expense = Expense(
                title: formData.title.trimmingCharacters(in: .whitespacesAndNewlines),
                amount: amount,
                date: formData.date
            )
            try await addExpenseUseCase.execute(expense: expense)
            state = .success
        } catch {
            state = .error(
                formData,
                message: error.localizedDescription,
                validationMessages: []
            )
        }
    }
    
    private func validate(_ formData: AddExpenseFormData) -> [String] {
        var messages: [String] = []
        
        if formData.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            messages.append("Title is required.")
        }
        
        guard let amount = decimalAmount(from: formData.amountText), amount > 0 else {
            messages.append("Amount must be greater than zero.")
            return messages
        }
        
        return messages
    }
    
    private func decimalAmount(from text: String) -> Decimal? {
        let normalizedText = text
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: ",", with: ".")
        
        return Decimal(string: normalizedText, locale: Locale(identifier: "en_US_POSIX"))
    }
    
    private func sanitizedAmountInput(_ text: String) -> String {
        let decimalSeparators = CharacterSet(charactersIn: ".,")
        let allowedCharacters = CharacterSet.decimalDigits.union(decimalSeparators)
        let filteredScalars = text.unicodeScalars.filter { allowedCharacters.contains($0) }
        let filteredText = String(String.UnicodeScalarView(filteredScalars))
        
        var hasSeparator = false
        return filteredText.reduce(into: "") { result, character in
            if character == "." || character == "," {
                guard !hasSeparator else { return }
                hasSeparator = true
            }
            result.append(character)
        }
    }
}
