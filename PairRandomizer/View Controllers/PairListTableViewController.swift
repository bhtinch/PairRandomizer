//
//  PairListTableViewController.swift
//  PairRandomizer
//
//  Created by Benjamin Tincher on 2/12/21.
//

import UIKit

class PairListTableViewController: UITableViewController {
    
    //  MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        PersonController.shared.loadFromPersistenceStore()
        randomize()
    }
    
    //  MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddPersonAlert()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        randomize()
        tableView.reloadData()
    }
    
    //  MARK: - Properties
    var shuffled: [Person] = []
    
    //  MARK: - Methods
    func randomize(){
        shuffled = PersonController.shared.persons.shuffled()
    }
    
    func presentAddPersonAlert(){
        let alertController = UIAlertController(title: "Add Person", message: "Add someone new to the list.", preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            alertController.dismiss(animated: true, completion: nil)
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Add person name..."
            textField.autocapitalizationType = .words
        }
        
                
        let addAction = UIAlertAction(title: "Add", style: .default) { (_) in
            
            guard let name = alertController.textFields?.first?.text, !name.isEmpty else { return }
            PersonController.shared.createPersonWith(name: name)
            self.randomize()
            self.tableView.reloadData()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(addAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if shuffled.count % 2 == 0 {
            return shuffled.count / 2
        } else {
            return shuffled.count / 2 + 1
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        let index = indexPath.section * 2 + indexPath.row
        
        if (shuffled.count % 2) == 1 && index == shuffled.count {
            cell.textLabel?.text = ""
        } else {
            cell.textLabel?.text = shuffled[index].name
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let index = indexPath.section * 2 + indexPath.row
            
            PersonController.shared.delete(person: shuffled[index])
            randomize()
            tableView.reloadData()
        }
    }
}
