//
//  AddExpenseState.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import Foundation

/// Immutable form data entered on the Add Expense screen.
public struct AddExpenseFormData: Equatable, Sendable {
    public var title: String
    public var amountText: String
    public var date: Date
    
    public init(title: String = "", amountText: String = "", date: Date = Date()) {
        self.title = title
        self.amountText = amountText
        self.date = date
    }
}

/// Explicit state representation for the Add Expense screen.
/// Keeps loading, validation, success, and error states mutually exclusive.
public enum AddExpenseState: Equatable, Sendable {
    case editing(AddExpenseFormData, validationMessages: [String])
    case loading(AddExpenseFormData)
    case success
    case error(AddExpenseFormData, message: String, validationMessages: [String])
    
    /// Current form values preserved across state transitions.
    public var formData: AddExpenseFormData {
        switch self {
        case .editing(let formData, _),
             .loading(let formData),
             .error(let formData, _, _):
            return formData
        case .success:
            return AddExpenseFormData()
        }
    }
    
    /// Validation messages currently visible to assist the user.
    public var validationMessages: [String] {
        switch self {
        case .editing(_, let validationMessages),
             .error(_, _, let validationMessages):
            return validationMessages
        case .loading, .success:
            return []
        }
    }
    
    /// Error message currently visible after a failed save attempt.
    public var errorMessage: String? {
        switch self {
        case .error(_, let message, _):
            return message
        case .editing, .loading, .success:
            return nil
        }
    }
    
    /// Indicates whether the save flow is in progress.
    public var isInteractionEnabled: Bool {
        switch self {
        case .loading, .success:
            return false
        case .editing, .error:
            return true
        }
    }
}
