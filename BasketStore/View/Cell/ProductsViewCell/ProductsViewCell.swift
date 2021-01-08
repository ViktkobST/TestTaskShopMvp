//
//  ProductsViewCell.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import UIKit

class ProductsViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var addBasketButton: UIButton!
    
    private var basketService: BasketServiceProtocol?
    private var product: Product?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addBasketButton.layer.cornerRadius = 10
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    public func configureCell(_ product: Product, basketService: BasketServiceProtocol) {
        self.product = product
        self.basketService = basketService
        self.buildCell()
    }
    
    private func buildCell() {
        guard let product = self.product else { return }
        guard let basketService = self.basketService else { return }
        self.productImage?.image = UIImage(named: product.icon)
        self.productNameLabel?.text = product.name
        self.productPriceLabel?.text = "\(product.price) руб"
        if basketService.findProduct(product.name) {
            self.addBasketButton.backgroundColor = UIColor.orange
            self.addBasketButton.setTitle("Удалить из корзины", for: .normal)
        } else {
            self.addBasketButton.backgroundColor = UIColor.systemIndigo
            self.addBasketButton.setTitle("Добавить в корзину", for: .normal)
        }
    }
    
    @IBAction func addBasket(_ sender: Any) {
        guard let basketService = self.basketService else { return }
        guard let product = self.product else { return }
        let checkProduct = basketService.findProduct(product.name)
        if checkProduct {
            let success = self.basketService?.deleteProduct(product.name) ?? false
            if success {
                self.addBasketButton.backgroundColor = UIColor.systemIndigo
                self.addBasketButton.setTitle("Добавить в корзину", for: .normal)
            }
        } else {
            let success = self.basketService?.addProduct(product, count: 1) ?? false
            if success {
                self.addBasketButton.backgroundColor = UIColor.orange
                self.addBasketButton.setTitle("Удалить из корзины", for: .normal)
            }
        }
    }
    
}
