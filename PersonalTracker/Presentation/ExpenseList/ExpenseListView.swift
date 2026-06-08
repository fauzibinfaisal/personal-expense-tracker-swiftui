//
//  ExpenseListView.swift
//  PersonalTracker
//
//  Created by Staff iOS Engineer on 09/06/26.
//

import SwiftUI

/// Layout displaying tracked expenses and providing action entry points, wrapped in a Liquid Glass theme.
public struct ExpenseListView: View {
    @StateObject private var viewModel: ExpenseListViewModel
    @EnvironmentObject private var router: AppRouter
    
    public init(viewModel: ExpenseListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    public var body: some View {
        ZStack {
            // Premium background: soft gradient flow
            LinearGradient(
                colors: [
                    Color(.systemBackground),
                    Color(.systemBackground),
                    Color.blue.opacity(0.06),
                    Color.purple.opacity(0.06)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            content
        }
        .navigationTitle("Expenses")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    viewModel.send(.addExpensePlaceholder)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                        .padding(8)
                        .background(.ultraThinMaterial)
                        .clipShape(Circle())
                        .overlay(
                            Circle()
                                .stroke(.white.opacity(0.3), lineWidth: 1)
                        )
                }
            }
        }
        .task {
            viewModel.send(.load)
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            Color.clear
        case .loading:
            LoadingView()
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
        case .empty:
            VStack {
                Spacer()
                EmptyStateView {
                    viewModel.send(.addExpensePlaceholder)
                }
                Spacer()
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        case .error(let message):
            VStack {
                Spacer()
                ErrorStateView(errorMessage: message) {
                    viewModel.send(.refresh)
                }
                Spacer()
            }
            .transition(.opacity.combined(with: .scale(scale: 0.95)))
        case .loaded(let expenses):
            ScrollView {
                LazyVStack(spacing: 12) {
                    ForEach(expenses) { expense in
                        Button {
                            viewModel.send(.selectExpense(expense))
                        } label: {
                            ExpenseCard(expense: expense)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
            }
            .refreshable {
                viewModel.send(.refresh)
            }
        }
    }
}
