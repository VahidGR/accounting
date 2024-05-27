//
//  CurrencyFormatter.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/3/24.
//

import Foundation

struct Currency {
    internal static func format(amount: Double, symbol: String) -> String {
        let price = amount as NSNumber

        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        // formatter.locale = NSLocale.currentLocale() // This is the default
        // In Swift 4, this ^ was renamed to simply NSLocale.current
        formatter.string(from: price) // "$123.44"

        // formatter.locale = Locale(identifier: "es_CL")
        // formatter.string(from: price) // $123"
        formatter.currencySymbol = symbol
        formatter.alwaysShowsDecimalSeparator = true
        
        return formatter.string(from: price) ?? "\(price) \(symbol)" // "123,44 €"
    }
}
