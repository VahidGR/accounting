//
//  SelectedCollectionListScreen.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/3/24.
//

import SwiftUI

struct SelectedCollectionListScreen: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject var containerIntent: ContentIntent
    @StateObject private var intent: SelectedCollectionIntent
    
    @State private var selection: ListItemModel? = nil
    @State private var list: [ListItemModel] = []
    @State private var networkDescription: SelectedCollectionIntent.State = .loading
    
    init(
        collection: Binding<Collection>
    ) {
        self._intent = .init(wrappedValue: .init(collection: collection.wrappedValue))
    }
    
    var body: some View {
        ZStack {
            List(list, id: \.self, selection: $selection) { item in
                NavigationLink {
                    SelectedExpenseScreen(state: .constant(.expense(item: item.expense)))
                        .environmentObject(intent)
                } label: {
                    ListItem(item: item)
                }
            }
            .animation(.linear, value: list)
            NavigationLink {
                SelectedExpenseScreen(state: .constant(.add))
                    .environmentObject(intent)
            } label: {
                ContentUnavailableView {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 44, height: 44)
                    .padding()
                } description: {
                    Text("Add \(intent.collection.title) expense")
                }
                    .tint(intent.collection.tint)
                    .opacity(list.isEmpty ? 1 : 0)
            }
        }
        .navigationTitle(intent.collection.title)
        .listRowSeparatorTint(intent.collection.tint)
        .toolbarRole(.editor)
        .toolbar {
            if horizontalSizeClass == .compact && list.isEmpty == false {
                NavigationLink {
                    SelectedExpenseScreen(state: .constant(.add))
                        .environmentObject(intent)
                } label: {
                    Image(systemName: "plus")
                        .font(.title3)
                        .foregroundColor(Color.blue)
                }
            }
        }
        .onReceive(intent.state) { state in
            networkDescription = state
            switch state {
            case .content(let items):
                list = items
            default:
                break
            }
            
        }
        .task {
            await intent.fetchList()
        }
        .onChange(of: selection) { oldValue, newValue in
            guard let expense = newValue?.expense else { return }
            containerIntent.select(expense: expense)
        }
        .modifier(RemoteResponderView(_intent))
        .onAppear {
            containerIntent.select(collection: intent.collection)
            containerIntent.select(expense: nil)
        }
    }
}
