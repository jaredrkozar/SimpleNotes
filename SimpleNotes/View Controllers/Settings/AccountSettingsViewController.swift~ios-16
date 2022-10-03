//
//  AccountSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/21/22.
//

import UIKit

class AccountSettingsViewController: UITableViewController {
    
    var models = [Sections]()
    
    override func viewDidLoad() {
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        
        configure()
        
        title = "Account Settings"
        
        tableView.rowHeight = 70
    }
    
    func configure() {
        models.append(Sections(title: "", settings: [
            SettingsOptions(title: "Google Drive", option: "", rowIcon: Icon(icon: UIImage(systemName: "pin"), iconBGColor: .systemRed, iconTintColor: .systemYellow), control: nil) {
                
                let textboxSettings = DefaultTextBoxViewController()
                self.show(textboxSettings, sender: true)
            }
        ]))
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return  models.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return models[section].settings.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableRowCell.identifier, for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        let model = models[indexPath.section].settings[indexPath.row]
        
        cell.configureCell(with: model)
        return cell
    }
}


