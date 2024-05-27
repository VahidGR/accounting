//
//  Navigation.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/2/24.
//

import SwiftUI

struct Navigation<SidebarScreen: View, ContentScreen: View, DetailScreen: View>: View {
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    @EnvironmentObject private var intent: ContentIntent
    
    @ViewBuilder let sidebar: SidebarScreen
    @ViewBuilder let content: ContentScreen
    @ViewBuilder let detail: DetailScreen
    
    @Binding var path: NavigationPath
    @State private var tintColor: Color = .black
    
    var body: some View {
        Group {
            if horizontalSizeClass == .compact {
                NavigationStack(path: $path, root: {
                    sidebar
                })
                .onReceive(intent.selectedCollection, perform: { collection in
                    tintColor = collection.tint
                })
                .tint(tintColor)
            } else {
                NavigationSplitView(
                    columnVisibility: .constant(.doubleColumn),
                    preferredCompactColumn: .constant(.detail)) {
                        sidebar
                            .environmentObject(intent)
                    } content: {
                        content
                            .environmentObject(intent)
                    } detail: {
                        detail
                            .environmentObject(intent)
                    }
                    .navigationSplitViewStyle(.balanced)
            }
        }
    }
}
