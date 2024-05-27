//
//  SelectedCollectionIntent.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/4/24.
//

import Foundation
import Combine

final class SelectedCollectionIntent: RemoteIntentProtocol {
    typealias Content = [ListItemModel]
    
    let collection: Collection
    private let client: APIClient
    private var cancellables: Set<AnyCancellable> = .init()
    
    internal let state: PassthroughSubject<State, Never>
    internal let failure: PassthroughSubject<Error?, Never>
    
    init(
        collection: Collection,
        client: APIClient = .init(),
        state: PassthroughSubject<State, Never> = .init(),
        failure: PassthroughSubject<Error?, Never> = .init()
    ) {
        self.collection = collection
        self.client = client
        self.state = state
        self.failure = failure
    }
    
    func fetchList() async {
        update(state: .loading)
        let publisher: PassthroughSubject<[Expense], Never> = .init()
        publisher.receive(on: DispatchQueue.main)
            .sink { [weak self] expenses in
                self?.update(state: .content(content: expenses.compactMap({ .init(expense: $0) })))
            }
            .store(in: &cancellables)
        do {
            try await client.smartFetch(
                request: .get(.expenseList(category: collection.title)),
                publisher: publisher
            )
        } catch {
            failure.send(error)
        }
    }
    
    func retry() async {
        state.send(.loading)
        await fetchList()
    }
    
    private func update(state: State) {
        DispatchQueue.main.async { [weak self] in
            self?.state.send(state)
        }
    }
    
}
