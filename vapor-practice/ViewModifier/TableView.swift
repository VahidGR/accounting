//
//  TableView.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/1/24.
//

import SwiftUI

struct TableView<RowView: TableViewCell>: ViewModifier {
    @Binding var items: [ListItemModel]
    func body(content: Content) -> some View {
        ScrollView {
            VStack {
                ForEach(items) { item in
                    RowView(item: item)
                }
            }
        }
    }
}

protocol TableViewCell: View {
    init(item: ListItemModel)
    var item: ListItemModel { get }
}
