//
//  BasketViewCell.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import UIKit

class BasketViewCell: UITableViewCell {

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productPriceLabel: UILabel!
    @IBOutlet weak var countTextField: UITextField!
    @IBOutlet weak var plusCountButton: UIButton!
    @IBOutlet weak var minusCountButton: UIButton!
    @IBOutlet weak var deleteProductButton: UIButton!
    
    private var basket: Basket!
    private var presenter: BasketPresenterProtocol!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addDoneButtonOnKeyboard()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(false, animated: false)
    }
    
    public func configureCell(_ basket: Basket, presenter: BasketPresenterProtocol) {
        self.basket = basket
        self.presenter = presenter
        self.buildCell()
    }
    
    private func buildCell() {
        guard let basket = self.basket else { return }
        self.productImage?.image = UIImage(named: basket.product.icon)
        self.productNameLabel?.text = basket.product.name
        self.productPriceLabel?.text = "\(basket.product.price) руб"
        self.countTextField?.text = "\(basket.count)"
    }
    
    @IBAction func minusButtonTap(_ sender: Any) {
        guard let basket = basket else { return }
        guard let presenter = presenter else { return }
        if basket.count > 1 {
            let count: Int = basket.count - 1
            presenter.editCountProduct(basket.product.name, count: count)
        } else {
            let alert = UIAlertController(title: "Ошибка", message: "Количество не может быть меньше одного", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Понятно", style: .cancel, handler: nil))
            UIApplication.shared.delegate?.window??.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func plusButtonTap(_ sender: Any) {
        guard let basket = basket else { return }
        guard let presenter = presenter else { return }
        let count: Int = basket.count + 1
        presenter.editCountProduct(basket.product.name, count: count)
    }
    
    @IBAction func deleteProductInBasket(_ sender: Any) {
        guard let basket = basket else { return }
        guard let presenter = presenter else { return }
        presenter.deleteProductInBasket(basket.product.name)
    }
    
    @IBAction func editingCountField(_ sender: Any) {
        guard let basket = basket else { return }
        guard let presenter = presenter else { return }
        let count: Int = Int(self.countTextField?.text ?? "0") ?? 0
        presenter.editCountProduct(basket.product.name, count: count)
    }
    
    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 50))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Готово", style: UIBarButtonItem.Style.done, target: self, action: #selector(self.doneButtonAction))

        let items = NSMutableArray()
        items.add(flexSpace)
        items.add(done)

        doneToolbar.items = items as? [UIBarButtonItem]
        doneToolbar.sizeToFit()

        self.countTextField.inputAccessoryView = doneToolbar
        self.countTextField.inputAccessoryView = doneToolbar

    }

    @objc func doneButtonAction() {
        self.contentView.endEditing(true)
    }
    
}
