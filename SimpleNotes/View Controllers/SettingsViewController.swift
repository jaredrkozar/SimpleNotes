//
//  SettiingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    var models = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 65
        configure()
        self.tableView.backgroundColor = .systemGroupedBackground
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
       
        title = "Settings"
        
    }

    func configure() {
        tableView.sectionHeaderTopPadding = 1.0
        models.append(Sections(title: "Appearance", settings: [
            SettingsOptions(title: "Accounts", option: "", icon: UIImage(systemName: "cloud")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), iconBGColor: .systemBlue, detailViewType: nil) {
               
                let accountSettings = self.storyboard!.instantiateViewController(withIdentifier: "accountSettings") as! AccountSettingsViewController
                self.show(accountSettings, sender: true)
            }
        ]))
        
        models.append(Sections(title: "Defaults", settings: [
            SettingsOptions(title: "Text Box", option: "", icon: UIImage(systemName: "rectangle")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), iconBGColor: .systemRed, detailViewType: nil) {
               
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
        let model = models[indexPath.section].settings[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: model)
        cell.backgroundColor = .secondarySystemGroupedBackground
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.section].settings[indexPath.row]
        model.handler!()
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
