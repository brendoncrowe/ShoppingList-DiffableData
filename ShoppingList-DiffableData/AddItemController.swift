//
//  AddItemController.swift
//  ShoppingList-DiffableData
//
//  Created by Brendon Crowe on 5/24/23.
//

import UIKit

protocol AddItemControllerDelegate: AnyObject {
  func didAddNewItem(_ addItemController: AddItemController, item: Item)
}

class AddItemController: UIViewController {
    
    public lazy var itemNameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "enter item name"
        tf.autocapitalizationType = .none
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    public lazy var itemPriceTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "enter item price"
        tf.keyboardType = .decimalPad
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    public lazy var pickerView: UIPickerView = {
       let pv = UIPickerView()
        pv.translatesAutoresizingMaskIntoConstraints = false
        pv.dataSource = self
        pv.delegate = self
        return pv
    }()
    
    weak var delegate: AddItemControllerDelegate?
    private let categories = Category.allCases
    private var selectedCategory: Category?


    override func viewDidLoad() {
        super.viewDidLoad()
        configureUIElements()
        view.backgroundColor = .systemBackground
        pickerView.dataSource = self
        pickerView.delegate = self
        configureNavBar()
        selectedCategory = Category.allCases.first
    }
    
    func configureNavBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(handleAdd))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    func configureUIElements() {
        view.addSubview(itemNameTextField)
        view.addSubview(itemPriceTextField)
        view.addSubview(pickerView)
        
        NSLayoutConstraint.activate([
            itemNameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemNameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemNameTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            itemPriceTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            itemPriceTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            itemPriceTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            itemPriceTextField.topAnchor.constraint(equalTo: itemNameTextField.bottomAnchor, constant: 16),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerView.topAnchor.constraint(equalTo: itemPriceTextField.bottomAnchor, constant: 20),
            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        
        ])
        
    }
    @objc
    func handleAdd() {
        guard let name = itemNameTextField.text, !name.isEmpty,
              let priceText = itemPriceTextField.text, !priceText.isEmpty,
              let price = Double(priceText),
              let selectedCategory = selectedCategory else {
            print("missing fields")
            return
        }
        let item = Item(name: name, price: price, category: selectedCategory)
        delegate?.didAddNewItem(self, item: item)
        dismiss(animated: true)
    }
    
    @objc
    func handleCancel() {
        dismiss(animated: true)
    }
}

extension AddItemController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCategory = categories[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].rawValue
    }
}
