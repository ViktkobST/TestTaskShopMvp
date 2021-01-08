//
//  BasketService.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import Foundation

protocol BasketServiceProtocol {
    var totalPrice: Double { get set } 
    func getAllProduct() -> [Basket] //Для удобства работы с UITableView возвращаем массив
    func addProduct(_ product: Product, count: Int) -> Bool // Добавляем товар в корзину
    func deleteProduct(_ productName: String) -> Bool // Удаляем товар из корзины
    func findProduct(_ productName: String) -> Bool // Проверяем есть ли товар в корзине
    func editCount(_ productName: String, count: Int) -> Bool // Редактируем количество товара в корзине
    func deleteAllProducts() //Удаляем все товары из корзины
}

class BasketService: BasketServiceProtocol {
    
    /*
    Хранение товаров в корзине реализовано через Dictionary
    для того, что бы время выполнения функции составляло O(1)
    а не O(n) как в случае с массивом
    */
    
    private var basket: Dictionary<String, Basket> = [:] {
        didSet {
            var totalPrice: Double = 0.0
            for product in basket {
                totalPrice += Double(product.value.count) * product.value.product.price
            }
            self.totalPrice = totalPrice
        }
    }
    
    public var totalPrice: Double = 0
    
    public func addProduct(_ product: Product, count: Int) -> Bool {
        guard let _ = self.basket[product.name] else {
            self.basket[product.name] = Basket(product, count: count)
            return true
        }
        return false
    }
    
    public func deleteProduct(_ productName: String) -> Bool {
        guard let _ = self.basket[productName] else {
            return false
        }
        self.basket.removeValue(forKey: productName)
        return true
    }
    
    public func getAllProduct() -> [Basket] {
        var result: [Basket] = []
        
        for product in self.basket {
            result.append(product.value)
        }
        
        return result
    }
    
    public func findProduct(_ productName: String) -> Bool {
        guard let _ = self.basket[productName] else {
            return false
        }
        return true
    }
    
    public func editCount(_ productName: String, count: Int) -> Bool {
        guard let _ = self.basket[productName] else {
            return false
        }
        self.basket[productName]?.count = count
        return true
    }
    
    public func deleteAllProducts() {
        self.basket = [:]
    }

}
