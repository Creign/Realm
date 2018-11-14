//
//  ItemViewController.swift
//  RealmEx
//
//  Created by Excell on 14/11/2018.
//  Copyright © 2018 Excell. All rights reserved.
//

import Foundation
import RealmSwift

class ItemViewController: UIViewController {
    
    let realm = try! Realm()
    var items: Results<Item>?
    var selectedCategory: Category?
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self
        searchBar.delegate = self
        
        load()
    }
    
    //MARK: - Add item
    @IBAction func didTapAdd(_ sender: Any) {
        var txtItem = UITextField()
        let alert = UIAlertController(title: "Add Item", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            action in
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = txtItem.text!
                        currentCategory.items.append(newItem)
                    }
                } catch {
                    print("Error adding an item, \(error)")
                }
            }
            
            self.tableView.reloadData()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: {
            txt in
            
            txt.placeholder = "Add new item"
            txtItem = txt
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Load items
    func load() {
        items = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    func toggleDone(item: Item) {
        do {
            try realm.write {
                item.done = !item.done
            }
        } catch {
            print("Error updating item, \(error)")
        }
    }
    
    func delete(item: Item) {
        do {
            try realm.write {
                realm.delete(item)
            }
        } catch {
            print("Error in deleting the item, \(error)")
        }
    }
}

extension ItemViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let item = items?[indexPath.row] {
            
            let alert = UIAlertController(title: "Update item", message: "", preferredStyle: .alert)
            
            let msg = item.done ? "Mark as not Done" : "Mark as Done"
            let toggleAction = UIAlertAction(title: msg, style: .default, handler: {
                action in
                self.toggleDone(item: item)
                self.tableView.reloadData()
            })
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: {
                action in
                self.delete(item: item)
                self.tableView.reloadData()
            })
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(toggleAction)
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            
            present(alert, animated: true, completion: nil)
        }
    }
}

extension ItemViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        
        if let item = items?[indexPath.row] {
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        
        return cell
    }
}

extension ItemViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        items = items?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            load()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
    }
}
