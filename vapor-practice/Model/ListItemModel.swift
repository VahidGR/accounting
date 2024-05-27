//
//  ListItemModel.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import Foundation

struct ListItemModel: Identifiable, Equatable, Hashable {
    let id: String
    let title: String
    let subtitle: String
    var expense: Expense
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    init(expense: Expense) {
        self.id = expense.id
        self.title = expense.name
        self.subtitle = Currency.format(amount: expense.total, symbol: expense.currency)
        self.expense = expense
    }
    
}
