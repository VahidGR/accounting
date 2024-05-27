//
//  Expense.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import Foundation

struct Expense: Codable, Identifiable, Equatable, Hashable {
    let id: String
    let name: String
    let label: String
    let total: Double
    let currency: String
    let created_at: Date
    
    enum CodingKeys: String, CodingKey {
        case id, name, label, total, currency, created_at
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        label = try container.decode(String.self, forKey: .label)
        total = try container.decode(Double.self, forKey: .total)
        currency = try container.decode(String.self, forKey: .currency)
        
        // Custom decoding for created_at
        let createdAtString = try container.decode(String.self, forKey: .created_at)
        if let date = DateFormatter.iso8601.date(from: createdAtString) {
            created_at = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .created_at, in: container, debugDescription: "Date string does not match format expected by formatter.")
        }
    }
}

extension DateFormatter {
    static let iso8601: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = .current
        return formatter
    }()
}
