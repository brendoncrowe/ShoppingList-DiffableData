//
//  DataSource.swift
//  ShoppingList-DiffableData
//
//  Created by Brendon Crowe on 5/23/23.
//

import UIKit

class DataSource: UITableViewDiffableDataSource<Category, Item> {
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if Category.allCases[section] == .shoppingCart {
            return "🛒 " + Category.allCases[section].rawValue
        } else {
            return Category.allCases[section].rawValue
        }
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            var snapshot = self.snapshot()
            if let item = itemIdentifier(for: indexPath) {
                snapshot.deleteItems([item])
                apply(snapshot, animatingDifferences: true)
            }
        }
    }
    
    // reordering rows
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        // get the source item
        guard let sourceItem = itemIdentifier(for: sourceIndexPath) else { return }
        
        // guard against attempting to move to self
        guard sourceIndexPath != destinationIndexPath else { return }
        
        // get the destination item
        let destinationItem = itemIdentifier(for: destinationIndexPath)
        
        // get current snapshot
        var snapshot = self.snapshot()
        
        if let destinationItem = destinationItem {
            
            // get the source index and the destination index
            if let sourceIndex = snapshot.indexOfItem(sourceItem), let destinationIndex = snapshot.indexOfItem(destinationItem) {
                
                let isAfter = destinationIndex > sourceIndex && snapshot.sectionIdentifier(containingItem: sourceItem) == snapshot.sectionIdentifier(containingItem: destinationItem)
                // first delete the source item from the snapshot
                snapshot.deleteItems([sourceItem])
                
                // SCENARIO 2
                if isAfter {
                    print("after destination")
                    snapshot.insertItems([sourceItem], afterItem: destinationItem)
                }
                
                // SCENARIO 3
                else {
                    print("before destination")
                    snapshot.insertItems([sourceItem], beforeItem: destinationItem)
                }
            }
            
        }
        
        // handle SCENARIO 4
        // no index path at destination section
        else {
            print("new index path")
            // get the section for the destination index path
            let destinationSection = snapshot.sectionIdentifiers[destinationIndexPath.section]
            
            // delete the source item before reinserting it
            snapshot.deleteItems([sourceItem])
            
            // append the source item at the new section
            snapshot.appendItems([sourceItem], toSection: destinationSection)
        }
        
        // apply changes to the data source
        apply(snapshot, animatingDifferences: false)
    }
}
