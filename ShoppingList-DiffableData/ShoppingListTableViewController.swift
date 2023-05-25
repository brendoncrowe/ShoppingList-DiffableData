//
//  ViewController.swift
//  ShoppingList-DiffableData
//
//  Created by Brendon Crowe on 5/23/23.
//

import UIKit


class ShoppingListTableViewController: UIViewController {
    
    private var tableView: UITableView!
    private var dataSource: DataSource!
    let cellId = "itemCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTV()
        configureDataSource()
        configNavBar()
    }
    
    private func configureTV() {
        tableView = UITableView(frame: view.bounds, style: .insetGrouped)
        tableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "itemCell")
        tableView.backgroundColor = .systemGroupedBackground
        view.addSubview(tableView)
    }
    
    private func configNavBar() {
        navigationItem.title = "Shopping List"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Edit", style: .plain, target: self, action: #selector(handleEdit))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(handleAdd))
    }
    
    @objc
    private func handleEdit() {
        tableView.setEditing(!tableView.isEditing, animated: true)
        navigationItem.leftBarButtonItem?.title =
        tableView.isEditing ? "Done" : "Edit"
    }
    
    @objc
    private func handleAdd() {
        let viewController = AddItemController()
        viewController.delegate = self
        navigationController?.present(UINavigationController(rootViewController: viewController), animated: true)
    }
    
    private func configureDataSource() {
        dataSource = DataSource(tableView: tableView, cellProvider: { tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(withIdentifier: self.cellId, for: indexPath)
            var content = cell.defaultContentConfiguration()
            content.text = "\(item.name)"
            let formattedPrice = String(format: "%.2f", item.price)
            content.secondaryText = "$\(formattedPrice)"
            cell.contentConfiguration = content
            return cell
        })
        dataSource.defaultRowAnimation = .fade
        
        // setup snapshot
        var snapshot = NSDiffableDataSourceSnapshot<Category, Item>()
        
        // populate snapshot with sections and items for each section
        for category in Category.allCases {
            let items = Item.testData().filter { $0.category == category }
            snapshot.appendSections([category])
            snapshot.appendItems(items)
        }
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ShoppingListTableViewController: AddItemControllerDelegate {
    func didAddNewItem(_ addItemController: AddItemController, item: Item) {
        var snapshot = dataSource.snapshot()
        snapshot.appendItems([item], toSection: item.category)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}
