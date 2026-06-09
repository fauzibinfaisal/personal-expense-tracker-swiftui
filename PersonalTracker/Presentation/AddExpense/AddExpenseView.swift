//
//  AddExpenseView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 10/06/26.
//

import SwiftUI

/// Form view for creating a new expense using Liquid Glass visual styling.
public struct AddExpenseView: View {
    @StateObject private var viewModel: AddExpenseViewModel
    private let onSuccess: () -> Void
    
    public init(viewModel: AddExpenseViewModel, onSuccess: @escaping () -> Void) {
        _viewModel = StateObject(wrappedValue: viewModel)
        self.onSuccess = onSuccess
    }
    
    public var body: some View {
        ZStack {
            background
            
            ScrollView {
                VStack(spacing: 20) {
                    formSection
                    validationSection
                    saveButton
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 32)
            }
        }
        .navigationTitle("Add Expense")
        .navigationBarTitleDisplayMode(.inline)
        .disabled(!viewModel.state.isInteractionEnabled)
        .overlay {
            if case .loading = viewModel.state {
                ProgressView("Saving")
                    .font(.headline)
                    .padding(24)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    .accessibilityLabel("Saving expense")
            }
        }
        .alert("Unable to Save Expense", isPresented: errorBinding) {
            Button("OK") {
                viewModel.send(.clearError)
            }
        } message: {
            Text(viewModel.state.errorMessage ?? "Please try again.")
        }
        .onChange(of: viewModel.state) { _, newState in
            if case .success = newState {
                onSuccess()
            }
        }
    }
    
    private var background: some View {
        LinearGradient(
            colors: [
                Color(.systemBackground),
                Color(.systemBackground),
                Color.cyan.opacity(0.07),
                Color.indigo.opacity(0.06)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }
    
    private var formSection: some View {
        VStack(spacing: 16) {
            ExpenseTextField(
                title: "Title",
                placeholder: "Coffee, lunch, groceries",
                text: titleBinding,
                systemImage: "text.cursor"
            )
            
            ExpenseAmountField(
                title: "Amount",
                placeholder: "0.00",
                amountText: amountBinding
            )
            
            ExpenseDatePicker(
                title: "Date",
                date: dateBinding
            )
        }
        .padding(18)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .stroke(.white.opacity(0.28), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    private var validationSection: some View {
        let messages = viewModel.state.validationMessages
        if !messages.isEmpty {
            VStack(spacing: 8) {
                ForEach(messages, id: \.self) { message in
                    ValidationMessageView(message: message)
                }
            }
        }
    }
    
    private var saveButton: some View {
        PrimaryGlassButton(
            title: "Save Expense",
            systemImage: "checkmark.circle.fill"
        ) {
            viewModel.send(.save)
        }
        .accessibilityHint("Validates and saves the new expense")
    }
    
    private var titleBinding: Binding<String> {
        Binding {
            viewModel.state.formData.title
        } set: { value in
            viewModel.send(.updateTitle(value))
        }
    }
    
    private var amountBinding: Binding<String> {
        Binding {
            viewModel.state.formData.amountText
        } set: { value in
            viewModel.send(.updateAmount(value))
        }
    }
    
    private var dateBinding: Binding<Date> {
        Binding {
            viewModel.state.formData.date
        } set: { value in
            viewModel.send(.updateDate(value))
        }
    }
    
    private var errorBinding: Binding<Bool> {
        Binding {
            viewModel.state.errorMessage != nil
        } set: { isPresented in
            if !isPresented {
                viewModel.send(.clearError)
            }
        }
    }
}
