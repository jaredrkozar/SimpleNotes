//
//  AccountSettingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/21/22.
//

import UIKit

class AccountSettingsViewController: UITableViewController {
    
    var models = [Sections]()
    
    var logButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = Constants.cornerRadius
        return button
    }()
    
    override func viewDidLoad() {
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        
        configure()
        
        title = "Account Settings"
        
        tableView.rowHeight = 70
    }
    
    func configure() {
        models.append(Sections(title: "Advanced", settings: [
            SettingsOptions(title: "Google Drive", option: "", icon: UIImage(named: "GoogleDrive"), iconBGColor: UIColor(named: "Blue")!, viewController: nil, control: .control(controls: [logButton])),
            SettingsOptions(title: "Dropbox", option: "", icon: UIImage(named: "Dropbox"), iconBGColor: UIColor(named: "LightBlue")!, viewController: nil, control: .control(controls: [logButton]))
        ])
        )
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
    
    @objc func logOutOfService(_ sender: UIButton) {
        guard let cell = sender.superview?.superview as? TableRowCell else {
            return // or fatalError() or whatever
        }

        let indexPath = tableView.indexPath(for: cell)
        
        
    }
}

