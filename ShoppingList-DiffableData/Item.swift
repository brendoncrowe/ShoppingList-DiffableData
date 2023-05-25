//
//  Item.swift
//  ShoppingList-DiffableData
//
//  Created by Brendon Crowe on 5/23/23.
//

import Foundation

struct Item: Hashable {
    let name: String
    let price: Double
    let category: Category
    let identifier = UUID().uuidString
    
    // implement the hashable property for the item identifier. Only making one property hashable
    // Hasher is the (has function) in Swift
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    // test data
    static func testData() -> [Item] {
        return [
            Item(name: "Corn", price: 3.45, category: .vegetables),
            Item(name: "Apple", price: 1.45, category: .fruit),
            Item(name: "Fish", price: 7.67, category: .meat),
            Item(name: "Soap", price: 2.45, category: .homeGoods),
            Item(name: "Dog Food", price: 49.78, category: .pet),
            Item(name: "Oil", price: 15.15, category: .automotive),
            Item(name: "Camping Chair", price: 78.89, category: .outdoors),
            Item(name: "Cheeze Its", price: 6.89, category: .snacks),
            Item(name: "Beans", price: 5.61, category: .vegetables),
        ]
    }
}
