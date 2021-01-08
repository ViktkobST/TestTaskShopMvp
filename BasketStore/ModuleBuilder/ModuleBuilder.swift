//
//  ModuleBuilder.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import UIKit

protocol ModuleBuilderProtocol: class {
    static var basketServices: BasketServiceProtocol { get }
    static func createMainModule() -> UIViewController
    static func createBasketModule() -> UIViewController
}

class ModuleBuilder: ModuleBuilderProtocol {
    
    static var basketServices: BasketServiceProtocol = BasketService()
    
    static func createMainModule() -> UIViewController {
        let view = MainViewController()
        let presenter = MainPresenter(view: view, basketService: self.basketServices)
        view.presenter = presenter
        return view
    }
    
    static func createBasketModule() -> UIViewController {
        let view = BasketViewController()
        let presenter = BasketPresenter(view: view, basketService: self.basketServices)
        view.presenter = presenter
        return view
    }
    
}
