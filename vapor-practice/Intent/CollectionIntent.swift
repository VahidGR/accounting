//
//  CollectionIntent.swift
//  vapor-practice
//
//  Created by Vahid Ghanbarpour on 5/3/24.
//

import Foundation

struct CollectionIntent {
    let list: [Collection] = [
        .init(
            title: "Groceries",
            icon: "house.fill",
            total: 421.78,
            tint: .blue
        ),
        .init(
            title: "Entertainment",
            icon: "film",
            total: 248.34,
            tint: .red
        ),
        .init(
            title: "Subscriptions",
            icon: "star.circle.fill",
            total: 99.98,
            tint: .yellow
        ),
        .init(
            title: "Personal",
            icon: "person.fill",
            total: 600.00,
            tint: .green
        )
    ]
    
    internal func sectionedList() -> [[Collection]] {
        /// calculate number of sections
        let linearList: [Collection] = list
        let count = linearList.count
        let numberOfItemsInSection: Int = 2
        let mod = count % numberOfItemsInSection
        let numberOfSections = mod == 0 ? count / numberOfItemsInSection : (count + numberOfItemsInSection - mod) / numberOfItemsInSection
        /// create sectioned list
        var list: [[Collection]] = .init(repeating: [], count: numberOfSections)
        var currentIndex = 0
        
        // Populate the sections
        for item in linearList {
            list[currentIndex / numberOfItemsInSection].append(item)
            currentIndex += 1
        }
        
        return list
    }
}
