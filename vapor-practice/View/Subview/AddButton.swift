//
//  AddButton.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/2/24.
//

import SwiftUI

struct AddButton: View {
    
    let onTap: () -> Void
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            Image(systemName: "plus")
                .font(.title3)
                .foregroundColor(Color.blue)
        }
    }
}
