//
//  BasketViewController.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import UIKit

protocol BasketViewProtocol: class {
    func success()
    func orderSuccess(_ basketString: String)
}

class BasketViewController: UIViewController {

    private let reuseIdentitfier = "basketCell"
    
    private lazy var basketTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    lazy var footerView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100))
        return view
    }()
    
    var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "Итого:"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var resultPriceLabel: UILabel = {
        var label = UILabel()
        label.text = "\(self.presenter.basketService.totalPrice) рублей"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendOrderButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 100, y: 400, width: 100, height: 50))
        button.backgroundColor = UIColor.orange
        button.layer.cornerRadius = 10
        button.setTitle("Отправить заказ", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(self.sendOrder), for: .touchDown)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var presenter: BasketPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Корзина"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let nibName = UINib(nibName: "BasketViewCell", bundle: nil)
        self.basketTableView.register(nibName, forCellReuseIdentifier: reuseIdentitfier)
        self.setupLayout()
        self.basketTableView.tableFooterView = footerView
    }
    
    private func setupLayout() {
        view.addSubview(basketTableView)
        footerView.addSubview(resultLabel)
        footerView.addSubview(resultPriceLabel)
        footerView.addSubview(sendOrderButton)
        
        NSLayoutConstraint.activate([
            //Основные констрейты
            basketTableView.topAnchor.constraint(equalTo: view.topAnchor),
            basketTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            basketTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            basketTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            //Констрейты футера
            resultLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            resultLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10),
            resultPriceLabel.topAnchor.constraint(equalTo: footerView.topAnchor, constant: 10),
            resultPriceLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
            sendOrderButton.bottomAnchor.constraint(equalTo: footerView.bottomAnchor, constant: -10),
            sendOrderButton.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -10),
            sendOrderButton.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 10),
            sendOrderButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    @objc private func sendOrder() {
        self.presenter.sendOrder()
    }

}

extension BasketViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.basket?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.reuseIdentitfier, for: indexPath) as! BasketViewCell
        
        let product = self.presenter.basket?[indexPath.row]
        cell.configureCell(product!, presenter: self.presenter)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 150
    }
    
}

extension BasketViewController: BasketViewProtocol {
    
    func orderSuccess(_ basketString: String) {
        let alert = UIAlertController(title: "Успешно", message: basketString, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: {(action:UIAlertAction!) in
            DispatchQueue.main.async {
                self.resultPriceLabel.text = "\(String(format: "%.2f", self.presenter.basketService.totalPrice) ) рублей"
                self.basketTableView.reloadData()
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func success() {
        DispatchQueue.main.async {
            self.resultPriceLabel.text = "\(String(format: "%.2f", self.presenter.basketService.totalPrice) ) рублей"
            self.basketTableView.reloadData()
        }
    }
    
}
