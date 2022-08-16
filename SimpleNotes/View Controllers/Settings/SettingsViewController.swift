//
//  SettiingsViewController.swift
//  SimpleNotes
//
//  Created by JaredKozar on 1/11/22.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    private var models = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .insetGrouped)
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        configure()
        
        title = "Settings"
        
    }

    func configure() {
        models.append(Sections(title: "Cloud", settings: [
            SettingsOptions(title: "Accounts", option: "", rowIcon: Icon(icon: UIImage(systemName: "cloud"), iconBGColor: .systemCyan, iconTintColor: nil), control: nil) {
                
                self.showSettingsPage(viewController: AccountSettingsViewController())
            }
        ]))
        
        models.append(Sections(title: "Appearance", settings: [
            SettingsOptions(title: "App Icon", option: "", rowIcon: Icon(icon: UIImage(systemName: "square.grid.2x2"), iconBGColor: .systemGreen, iconTintColor: nil), control: nil) {
                
                self.showSettingsPage(viewController: AccountSettingsViewController())
             },
            SettingsOptions(title: "Tint Color", option: "", rowIcon: Icon(icon: UIImage(systemName: "paintbrush"), iconBGColor: .systemRed, iconTintColor: nil), control: nil) {
                
                self.showSettingsPage(viewController: TintPickerViewController())
             },
        ]))
        
        models.append(Sections(title: "Defaults", settings: [
            SettingsOptions(title: "Text Box", option: "", rowIcon: Icon(icon: UIImage(systemName: "character.textbox"), iconBGColor: .systemRed, iconTintColor: nil), control: nil) {
                   
                self.showSettingsPage(viewController: DefaultTextBoxViewController())
             },
            SettingsOptions(title: "Note", option: "",rowIcon: Icon(icon: UIImage(systemName: "doc"), iconBGColor: .systemOrange, iconTintColor: nil), control: nil) {
                
                self.showSettingsPage(viewController: AccountSettingsViewController())
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableRowCell.identifier, for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: model)
        
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
        
        model.handler!()
    }

    func showSettingsPage(viewController: UIViewController) {
        switch currentDevice {
        case .iphone:
            show(viewController, sender: true)
        case .ipad, .mac:
            splitViewController?.setViewController(viewController, for: .secondary)
        case .none:
            return
        }
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
