//
//  Products.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import Foundation

struct Product: Codable, Equatable {
    var icon: String
    var name: String
    var price: Double
    
    init(icon: String, name: String, price: Double) {
        self.icon = icon
        self.name = name
        self.price = price
    }
    
    static func == (lhs: Product, rhs: Product) -> Bool {
        if lhs.name == rhs.name {
            return true
        }
        return false
    }
}
