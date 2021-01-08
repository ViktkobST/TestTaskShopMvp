//
//  MainPresenter.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import Foundation

protocol MainPresenterProtocol: class {
    var products: [Product]? { get set }
    var basketService: BasketServiceProtocol { get }
    init(view: MainViewProtocol, basketService: BasketServiceProtocol)
    func getProducts()
}

class MainPresenter: MainPresenterProtocol {
    
    weak var view: MainViewProtocol?
    let basketService: BasketServiceProtocol
    var products: [Product]?
    
    required init(view: MainViewProtocol, basketService: BasketServiceProtocol) {
        self.view = view
        self.basketService = basketService
        self.getProducts()
    }
    
    func getProducts() {
        self.products = [
            Product(icon: "shoes", name: "Кросовки", price: 999.99),
            Product(icon: "short", name: "Шорты", price: 1999.99),
            Product(icon: "lamp", name: "Лампа в гостиную", price: 9999.99),
            Product(icon: "shkaf", name: "Шкаф для вещей", price: 1234),
            Product(icon: "imac", name: "Imac", price: 7841)
        ]
        guard let view = self.view else { return }
        view.success()
    }
    
}


