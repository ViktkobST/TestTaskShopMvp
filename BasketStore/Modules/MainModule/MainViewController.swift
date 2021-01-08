//
//  MainViewController.swift
//  BasketStore
//
//  Created by Виктор Кобыхно on 1/8/21.
//

import UIKit

protocol MainViewProtocol: class {
    func success()
}

class MainViewController: UIViewController {
    
    private let reuseIdentifier = "productCell"
    
    private lazy var productTableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private lazy var basketButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.frame = CGRect(x: view.frame.width - 60, y: view.frame.height - 60, width: 50, height: 50)
        btn.setImage(UIImage(systemName: "cart"), for: .normal)
        btn.backgroundColor = UIColor.white
        btn.clipsToBounds = true
        btn.layer.cornerRadius = 25
        btn.layer.borderColor = UIColor.systemIndigo.cgColor
        btn.layer.borderWidth = 1.0
        btn.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        btn.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
        btn.layer.shadowOpacity = 1.0
        btn.layer.shadowRadius = 2.5
        btn.layer.masksToBounds = false
        btn.addTarget(self, action: #selector(self.pushBasketModule), for: .touchDown)
        return btn
    }()
    
    var presenter: MainPresenterProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Товары"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        let nibName = UINib(nibName: "ProductsViewCell", bundle: nil)
        self.productTableView.register(nibName, forCellReuseIdentifier: reuseIdentifier)
        self.productTableView.tableFooterView = UIView()
        setupLayout()
        addBasketButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        addBasketButton()
        DispatchQueue.main.async {
            self.productTableView.reloadData()
        }
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        basketButton.removeFromSuperview()
    }
    
    private func setupLayout() {
        view.addSubview(productTableView)
        NSLayoutConstraint.activate([
            productTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            productTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            productTableView.topAnchor.constraint(equalTo: view.topAnchor),
            productTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func addBasketButton() {
        if let window = UIApplication.shared.windows.filter({ $0.isKeyWindow }).first {
            window.addSubview(self.basketButton)
        }
    }
    
    @objc private func pushBasketModule() {
        let basketController = ModuleBuilder.createBasketModule()
        self.navigationController?.pushViewController(basketController, animated: true)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.presenter.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ProductsViewCell
        
        let product = self.presenter.products?[indexPath.row]
        cell.configureCell(product!, basketService: self.presenter.basketService)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
}

extension MainViewController: MainViewProtocol {
    func success() {
        DispatchQueue.main.async {
            self.productTableView.reloadData()
        }
    }
}
