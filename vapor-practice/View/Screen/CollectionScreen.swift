//
//  CollectionScreen.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/3/24.
//

import SwiftUI

struct CollectionScreen: View {
    @EnvironmentObject var containerIntent: ContentIntent
    let intent: CollectionIntent = .init()
    @State private var selection: Collection?
    @State private var shouldNavigate: Bool = false
    var body: some View {
        List(intent.list, selection: $selection) { item in
            NavigationLink {
                SelectedCollectionListScreen(collection: .constant(item))
                    .environmentObject(containerIntent)
            } label: {
                CollectionItem(item: item)
            }
        }
    }
}

#Preview {
    CollectionScreen()
}

struct CollectionItem: View {
    let item: Collection
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                ZStack {
                    Circle()
                        .fill(item.tint)
                    Image(systemName: item.icon)
                        .font(.title2)
                        .foregroundStyle(.primary)
                }
                .frame(width: 44, height: 44)
                Spacer()
                Text(item.total)
                    .font(.headline)
            }
            Text(item.title)
                .font(.subheadline)
        }
        .padding()
        //        .background(Color.secondary)
        .shadow(radius: 10)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .scaledToFit()
    }
}

struct Collection: Hashable, Identifiable {
    var id: String {
        title
    }
    let title: String
    let icon: String
    let total: String
    let tint: Color
    
    init(
        title: String,
        icon: String,
        total: Double,
        tint: Color
    ) {
        self.title = title
        self.icon = icon
        self.total = Currency.format(amount: total, symbol: "$")
        self.tint = tint
    }
}
