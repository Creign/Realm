//
//  CategoryViewController.swift
//  RealmEx
//
//  Created by Excell on 14/11/2018.
//  Copyright © 2018 Excell. All rights reserved.
//

import UIKit
import RealmSwift

class CategoryViewController: UIViewController {
    
    let realm = try! Realm()
    
    var categories: Results<Category>?

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        load()
    }
    
    @IBAction func didAddCategory(_ sender: Any) {
        var txtCategory = UITextField()
        
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "Add", style: .default, handler: {
            action in
            
            let category = Category()
            category.name = txtCategory.text!
            
            self.save(category: category)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(cancelAction)
        alert.addAction(addAction)
        alert.addTextField(configurationHandler: {
            txt in
            txt.placeholder = "Add new category"
            txtCategory = txt
        })
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Save category
    func save(category: Category) {
        do {
            try realm.write {
                realm.add(category)
            }
        } catch {
            print("Error saving category: \(error)")
        }
        
        load()
    }
    
    //MARK: - Load categories
    func load() {
        categories = realm.objects(Category.self)
        tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let vc = segue.destination as! ItemViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            vc.selectedCategory = categories?[indexPath.row]
        }
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemsSegue", sender: self)
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        
        cell.textLabel?.text = categories?[indexPath.row].name
        
        return cell
    }
}

