//
//  RemoteResponderView.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import SwiftUI

struct RemoteResponderView<Intent: RemoteIntentProtocol>: ViewModifier {
    @StateObject private var intent: Intent
    @State private var contentState: Intent.State = .custom(text: "")
    
    init(_ intent: StateObject<Intent>) {
        self._intent = intent
    }

    func body(content: Content) -> some View {
        content
            .toolbar {
                ToolbarItemGroup(placement: .bottomBar) {
                    Text(contentState.description)
                        .font(.footnote)
                        .foregroundStyle(contentState.tint)
                        .animation(.spring, value: contentState)
                }
            }
            .onReceive(intent.state) { state in
                contentState = state
            }
    }
}
