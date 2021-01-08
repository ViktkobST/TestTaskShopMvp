//
//  Basket.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import Foundation

struct Basket: Codable, Equatable {
    
    let product: Product
    var count: Int
    
    init(_ product: Product, count: Int) {
        self.product = product
        self.count = count
    }
    
    static func == (lhs: Basket, rhs: Basket) -> Bool {
        if lhs.product == rhs.product {
            return true
        }
        return false
    }
    
}
