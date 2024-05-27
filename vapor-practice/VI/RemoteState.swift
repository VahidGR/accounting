//
//  RemoteState.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/4/24.
//

import SwiftUI

enum RemoteState<Content: Equatable>: Equatable {
    static func == (lhs: RemoteState<Content>, rhs: RemoteState<Content>) -> Bool {
        switch (lhs, rhs) {
        case (.loading, .loading):
            return true
        case (.content(let lhs_content), .content(let rhs_content)):
            return lhs_content == rhs_content
        case (.failure(let lhs_error), .failure(let rhs_error)):
            return lhs_error?.localizedDescription == rhs_error?.localizedDescription
        default:
            return false
        }
    }
    
    case loading
    case content(content: Content)
    case failure(error: Error?)
    case custom(text: String)
    
    var description: String {
        switch self {
        case .loading:
            "Downloading updates ..."
        case .failure(let error):
            error?.localizedDescription ?? "You're offline"
        case .content:
            "Synced"
        case .custom(let text):
            text
        }
    }
    
    var tint: Color {
        switch self {
        case .loading, .custom:
            Color.gray
        case .failure:
            Color.red
        case .content:
            Color.green
        }
    }
}
