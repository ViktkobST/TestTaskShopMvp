//
//  BasketPresenter.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import Foundation

protocol BasketPresenterProtocol: class {
    var basket: [Basket]? { get set }
    var basketService: BasketServiceProtocol { get }
    init(view: BasketViewProtocol, basketService: BasketServiceProtocol)
    func getBasketProduct()
    func deleteProductInBasket(_ productName: String)
    func editCountProduct(_ productName: String, count: Int)
    func sendOrder()
}

class BasketPresenter: BasketPresenterProtocol {
    
    weak var view: BasketViewProtocol?
    var basket: [Basket]?
    let basketService: BasketServiceProtocol
    
    required init(view: BasketViewProtocol, basketService: BasketServiceProtocol) {
        self.view = view
        self.basketService = basketService
        self.getBasketProduct()
    }
    
    func getBasketProduct() {
        self.basket = self.basketService.getAllProduct()
        self.view?.success()
    }
    
    func deleteProductInBasket(_ productName: String) {
        let successDeleteProduct = self.basketService.deleteProduct(productName)
        if successDeleteProduct {
            guard let view = self.view else { return }
            self.getBasketProduct()
            view.success()
        }
    }
    
    func editCountProduct(_ productName: String, count: Int) {
        let successEditCount = self.basketService.editCount(productName, count: count)
        if successEditCount {
            guard let view = view  else { return }
            self.getBasketProduct()
            view.success()
        }
    }
    
    func sendOrder() {
        guard let view = self.view else { return }
        guard let basket = self.basket else { return }
        var orderJson: [String: Any] = [:]
        for order in basket {
            orderJson[order.product.name] = order.count
        }
        view.orderSuccess(json(array: orderJson) ?? "Тут должен быть заказ")
        self.basketService.deleteAllProducts()
        self.basket = self.basketService.getAllProduct()
        
    }
    
    func json(array: [String: Any]) -> String? {
        guard let data = try? JSONSerialization.data(withJSONObject: array, options: []) else {
            return nil
        }
        return String(data: data, encoding: String.Encoding.utf8)
    }
    
}
