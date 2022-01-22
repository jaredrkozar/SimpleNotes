//
//  SettiingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

struct Sections {
    let title: String
    var settings: [SettingsOptions]
}

struct SettingsOptions {
    let title: String
    var option: String
    let icon: UIImage?
    let iconBGColor: UIColor
    let handler: (() -> Void)
}

class SettingsViewController: UITableViewController {
    
    var models = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 65
        configure()
        
        let nib = UINib(nibName: "TableRowCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "TableRowCell")
        
        title = "Settings"
        
    }

    func configure() {
        models.append(Sections(title: "Appearance", settings: [
            SettingsOptions(title: "Accounts", option: "", icon: UIImage(systemName: "cloud"), iconBGColor: UIColor(named: "Blue")!) {
               
                let accountSettings = self.storyboard!.instantiateViewController(withIdentifier: "accountSettings") as! AccountSettingsViewController
                self.show(accountSettings, sender: true)
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
        let model = models[indexPath.section].settings[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.logOutButton.isHidden = true
        
        cell.icon.image = model.icon
        cell.background.backgroundColor = model.iconBGColor
        
        cell.name.text = model.title
        
        cell.background.layer.cornerRadius = 9.0
        cell.icon.tintColor = UIColor.white
        
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = models[indexPath.section].settings[indexPath.row]
        model.handler()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
