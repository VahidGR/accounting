//
//  SelectedExpenseView.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/2/24.
//

import SwiftUI

struct SelectedExpenseScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject private var containerIntent: SelectedCollectionIntent
    @StateObject private var intent: ExpenseIntent
    
    @State private var name: String = ""
    @State private var total: String = ""
    @State private var currency: String = ""
    @Binding var state: ContentState
    
    init(
        state: Binding<ContentState>
    ) {
        self._state = state
        switch state.wrappedValue {
        case .expense(let item):
            _intent = .init(wrappedValue: .init(snapshot: item))
        default:
            _intent = .init(wrappedValue: .init(snapshot: nil))
        }
    }
    
    var body: some View {
        ScrollView {
            switch state {
            case .unavailable:
                ContentUnavailableView("Add an expense record", systemImage: "plus")
                    .onTapGesture { state = .add }
            default:
                VStack {
                    TextField("Groceries, night out ...", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .padding()
                    HStack {
                        TextField("￡＄€", text: $currency)
                            .frame(width: 64)
                            .textFieldStyle(.roundedBorder)
                            .padding(.leading)
                        
                        TextField("99.90", text: $total)
                            .textFieldStyle(.roundedBorder)
                            .keyboardType(.decimalPad)
                            .padding(.trailing)
                    }
                    .toolbar {
                        Button {
                            Task {
                                await intent.addExpense(
                                    name: name,
                                    totalPrice: total,
                                    currency: currency,
                                    category: containerIntent.collection.title
                                )
                                await containerIntent.fetchList()
                                dismiss()
                            }
                        } label: {
                            Text("Save")
                                .font(.title3)
                                .foregroundColor(Color.blue)
                        }
                    }
                    Spacer()
                }
                .padding(.horizontal)
            }
        }
        .onChange(of: state) { oldValue, newValue in
            switch newValue {
            case .expense(let item): 
                name = item.name
                currency = item.currency
                total = .init(item.total)
            default: name = .init()
            }
        }
        .onReceive(intent.expenseSnapshot, perform: { item in
            guard let item else { return }
            name = item.name
            total = .init(item.total)
            currency = item.currency
        })
        .modifier(RemoteResponderView(_intent))
    }
}

enum ContentState: Hashable {
    case add
    case unavailable
    case expense(item: Expense)
}

