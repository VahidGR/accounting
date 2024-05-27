//
//  ExpenseIntent.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/2/24.
//

import Foundation
import Combine

final class ExpenseIntent: RemoteIntentProtocol {
    typealias Content = [String: String]
    var state: PassthroughSubject<State, Never> = .init()
    private let client: APIClient
    internal let expenseSnapshot: CurrentValueSubject<CreateExpense?, Never>
    private var cancellables: Set<AnyCancellable>
    
    init(
        client: APIClient = .init(),
        snapshot: Expense?
    ) {
        self.client = client
        expenseSnapshot = .init(.init(expense: snapshot))
        cancellables = .init()
    }
    
    @MainActor
    func addExpense(
        name: String,
        totalPrice: String,
        currency: String,
        category: String
    ) async {
        let payload: CreateExpense = .init(
            name: name,
            label: category,
            total: totalPrice,
            currency: currency
        )
        
        expenseSnapshot.send(payload)
        await sendExpense(payload: payload)
    }
    
    private func sendExpense(payload: CreateExpense?) async {
        guard let payload else { return }
        let publisher: PassthroughSubject<[String: String], Never> = .init()
        
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] expense in
                self?.update(state: .content(content: expense))
            }
            .store(in: &cancellables)
        
        do {
            let data = try JSONEncoder().encode(payload)
            
            try await client.cacheFirstPostFetch(
                request: .post(
                    .expenseList(category: payload.label),
                    payload: data
                ),
                payload: data,
                publisher: publisher
            )
        }
        catch {
            update(state: .failure(error: error))
        }
    }
    
    func retry() async {
        update(state: .loading)
        await sendExpense(payload: expenseSnapshot.value)
    }
}

internal struct CreateExpense: Codable {
    let date: Date
    let name: String
    let label: String
    let total: Double
    let currency: String
    
    init(
        name: String,
        label: String,
        total: String,
        currency: String
    ) {
        self.date = .init()
        self.name = name
        self.label = label
        self.total = Double(total)!
        self.currency = currency
    }
    
    init?(expense: Expense?) {
        guard let expense else { return nil }
        date = expense.created_at
        self.name = expense.name
        self.label = expense.label
        self.total = expense.total
        self.currency = expense.currency
    }
}
