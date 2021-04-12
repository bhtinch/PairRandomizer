//
//  PairListTableViewController.swift
//  PairRandomizer
//
//  Created by Benjamin Tincher on 2/12/21.
//

import UIKit

class PairListTableViewController: UITableViewController {
    //  MARK: - Outlets
    @IBOutlet weak var randomizeButton: UIButton!
    @IBOutlet weak var changeGroupNumbersButton: UIButton!
    
    //  MARK: - Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        PersonController.shared.loadFromPersistenceStore()
        presentGroupNumberAlert()
        configureButtons()
    }
    
    //  MARK: - Actions
    @IBAction func addButtonTapped(_ sender: Any) {
        presentAddPersonAlert()
    }
    
    @IBAction func changeGroupNumbersButtonTapped(_ sender: Any) {
        presentGroupNumberAlert()
    }
    
    @IBAction func randomizeButtonTapped(_ sender: Any) {
        randomize()
        tableView.reloadData()
    }
    
    //  MARK: - Properties
    var shuffled: [Person] = []
    var shuffledAndGrouped: [[Person]] = []
    var groupNumber: Int = 2
    
    //  MARK: - Methods
    func randomize(){
        shuffled = PersonController.shared.persons.shuffled()
        shuffledAndGrouped = []
        var index = 1
        
        for _ in shuffled {
            var array: [Person] = []
            
            if index <= shuffled.count && index % groupNumber == 1 || index == 1 {
                
                for num in 0..<groupNumber {
                    if shuffled.indices.contains(index - 1 + num) { array.append(shuffled[index - 1 + num]) }
                }
                
                shuffledAndGrouped.append(array)
                index += groupNumber
            }
        }
    }
    
    func presentGroupNumberAlert() {
        let alertController = UIAlertController(title: "How many members per group?", message: nil, preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter number of members..."
            textField.keyboardType = .numberPad
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let valueText = alertController.textFields?.first?.text, !valueText.isEmpty,
                  let value = Int(valueText) else { return }
            self.groupNumber = value
            self.randomize()
            self.tableView.reloadData()
        }
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
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
        shuffledAndGrouped.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return shuffledAndGrouped[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section + 1)"
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "personCell", for: indexPath)
        
        cell.textLabel?.text = shuffledAndGrouped[indexPath.section][indexPath.row].name
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            PersonController.shared.delete(person: shuffledAndGrouped[indexPath.section][indexPath.row])
            
            randomize()
            tableView.reloadData()
        }
    }
    
    //  MARK: - Styling Functions
    func configureButtons() {
        let buttons = [randomizeButton, changeGroupNumbersButton]
        
        for button in buttons {
            guard let button = button else { return }
            button.layer.cornerRadius = 8
            button.layer.masksToBounds = true
        }
    }
}
