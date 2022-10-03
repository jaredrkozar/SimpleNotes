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
<<<<<<< HEAD:SimpleNotes/View Controllers/SettingsViewController.swift
        tableView.rowHeight = 65
        configure()
        self.tableView.backgroundColor = .systemGroupedBackground
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
       
=======
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .insetGrouped)
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        configure()
        
>>>>>>> ios-16:SimpleNotes/View Controllers/Settings/SettingsViewController.swift
        title = "Settings"
        self.navigationController?.navigationBar.tintColor = UIColor(hex: (UserDefaults.standard.string(forKey: "defaultTintColor")!))
        
    }

    func configure() {
<<<<<<< HEAD:SimpleNotes/View Controllers/SettingsViewController.swift
        tableView.sectionHeaderTopPadding = 1.0
        models.append(Sections(title: "Appearance", settings: [
            SettingsOptions(title: "Accounts", option: "", icon: UIImage(systemName: "cloud")?.withTintColor(UIColor.white, renderingMode: .alwaysOriginal), iconBGColor: .systemBlue, detailViewType: nil) {
               
                let accountSettings = self.storyboard!.instantiateViewController(withIdentifier: "accountSettings") as! AccountSettingsViewController
                self.show(accountSettings, sender: true)
=======
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
                
                self.showSettingsPage(viewController: DefaultNoteViewController())
>>>>>>> ios-16:SimpleNotes/View Controllers/Settings/SettingsViewController.swift
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

        guard let cell = tableView.dequeueReusableCell(withIdentifier: TableRowCell.identifier, for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: model)
<<<<<<< HEAD:SimpleNotes/View Controllers/SettingsViewController.swift
        cell.backgroundColor = .secondarySystemGroupedBackground
=======
        
>>>>>>> ios-16:SimpleNotes/View Controllers/Settings/SettingsViewController.swift
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = models[section]
        return section.title
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let model = models[indexPath.section].settings[indexPath.row]
<<<<<<< HEAD:SimpleNotes/View Controllers/SettingsViewController.swift
=======
        
>>>>>>> ios-16:SimpleNotes/View Controllers/Settings/SettingsViewController.swift
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
