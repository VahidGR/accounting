//
//  ContentScreen.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import SwiftUI

struct MainScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    @StateObject private var intent: ContentIntent
    @State private var path: NavigationPath = .init()
    @State private var selectedCollection: Collection
    @State private var detailState: ContentState = .unavailable
    
    init(
        intent: ContentIntent = .init(),
        selectedCollection: Collection? = nil
    ) {
        self._intent = .init(wrappedValue: intent)
        self.selectedCollection = selectedCollection ?? intent.selectedCollection.value
    }
    
    var body: some View {
        Navigation(
            sidebar: {
                CollectionScreen()
            }, content: {
                SelectedCollectionListScreen(collection: $selectedCollection)
            }, detail: {
                SelectedExpenseScreen(state: $detailState)
            }, path: $path)
        .environmentObject(intent)
        .onReceive(intent.selectedExpense, perform: { expense in
            guard let expense else {
                detailState = .unavailable
                return
            }
            detailState = .expense(item: expense)
        })
//        .modifier(RemoteResponderView(_intent))
    }
}
