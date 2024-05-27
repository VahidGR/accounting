//
//  ContentIntent.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import Foundation
import Combine

final class ContentIntent: ObservableObject {
    
    private let client: APIClient
    
    internal var selectedCollection: CurrentValueSubject<Collection, Never>
    internal var selectedExpense: CurrentValueSubject<Expense?, Never> = .init(nil)
    
    init(
        client: APIClient = .init()
    ) {
        self.client = client
        selectedCollection = .init(CollectionIntent().list[0])
    }
    
    func select(expense: Expense?) {
        selectedExpense.send(expense)
    }
    
    func select(collection: Collection) {
        selectedCollection.send(collection)
    }
}

protocol RemoteIntentProtocol: ObservableObject {
    associatedtype Content: Equatable
    typealias State = RemoteState<Content>
    var state: PassthroughSubject<State, Never> { get }
    func retry() async
}

extension RemoteIntentProtocol {
    internal func update(state: State) {
        DispatchQueue.main.async { [weak self] in
            self?.state.send(state)
        }
    }
}
