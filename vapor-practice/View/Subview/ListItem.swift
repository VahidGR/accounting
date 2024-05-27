//
//  ListItem.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/2/24.
//

import SwiftUI

struct ListItem: TableViewCell {
    let item: ListItemModel
    
    init(item: ListItemModel) {
        self.item = item
    }
    
    var body: some View {
        HStack(alignment: .center) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.headline)
                Text(item.subtitle)
                    .font(.subheadline)
            }
            .padding(6)
        }
        
        .swipeActions(edge: .leading, allowsFullSwipe: false) {
            Button {
                print("Muting conversation")
            } label: {
                Label("Mute", systemImage: "bell.slash.fill")
            }
            .tint(.indigo)
        }
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                print("Deleting conversation")
            } label: {
                Label("Delete", systemImage: "trash.fill")
            }
        }
        
    }
}
