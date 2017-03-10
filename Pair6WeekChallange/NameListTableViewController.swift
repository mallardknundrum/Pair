//
//  NameListTableViewController.swift
//  Pair6WeekChallange
//
//  Created by Jeremiah Hawks on 3/10/17.
//  Copyright © 2017 Jeremiah Hawks. All rights reserved.
//

import UIKit

class NameListTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NameController.shared.fetchAllNames { 
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - ShuffleSwitch
    
    @IBAction func shuffleSwitchToggled(_ sender: UISwitch) {
        if sender.isOn == false {
            NameController.shared.isRandom = false
        } else {
            NameController.shared.isRandom = true
            NameController.shared.shuffleNamesAndBreakIntoPairs()
        }
        tableView.reloadData()
    }
    
    
    // MARK: - Add Name
    
    @IBAction func addButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a name", message: "Enter a name to add to the list", preferredStyle: .alert)
        var nameTextField: UITextField!
        alertController.addTextField { (textField) in
            nameTextField = textField
        }
        let addAction = UIAlertAction(title: "Add a name", style: .default) { (_) in
            guard let name = nameTextField.text, !name.isEmpty else { return }
            NameController.shared.createName(withName: name)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if NameController.shared.isRandom {
            return NameController.shared.shuffledArrays.count
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if NameController.shared.isRandom {
            return "Pair \(section + 1)"
        } else {
            return "Name List"
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if NameController.shared.isRandom {
            return NameController.shared.shuffledArrays[section].count
        } else {
            return NameController.shared.nameArray.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath)
        if NameController.shared.isRandom {
            let name = NameController.shared.shuffledArrays[indexPath.section][indexPath.row]
            cell.textLabel?.text = name.name
        } else {
            let name = NameController.shared.nameArray[indexPath.row]
            cell.textLabel?.text = name.name
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if NameController.shared.isRandom {
                let name = NameController.shared.shuffledArrays[indexPath.section][indexPath.row]
                NameController.shared.deleteName(name: name)
                tableView.deleteRows(at: [indexPath], with: .fade)
                tableView.reloadData()
            } else {
                let name = NameController.shared.nameArray[indexPath.row]
                NameController.shared.deleteName(name: name)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        }
    }
}









