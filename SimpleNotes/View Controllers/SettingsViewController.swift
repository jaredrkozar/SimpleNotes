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
    let viewController: UIViewController?
    let control: DetailViewType?
}

class SettingsViewController: UITableViewController {
    
    var models = [Sections]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height), style: .insetGrouped)
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        configure()
        
        title = "Settings"
        
    }

    func configure() {
        models.append(Sections(title: "Appearance", settings: [
            SettingsOptions(title: "Accounts", option: "", icon: UIImage(systemName: "cloud"), iconBGColor: UIColor(named: "Blue")!, viewController: AccountSettingsViewController(), control: nil),
            SettingsOptions(title: "Tint COlor", option: "", icon: UIImage(systemName: "cloud"), iconBGColor: UIColor(named: "Blue")!, viewController: TintPickerViewController(), control: nil)
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
        
        switch currentDevice {
        case .iphone:
            show(model.viewController!, sender: true)
        case .ipad, .mac:
            splitViewController?.setViewController(model.viewController, for: .secondary)
        case .none:
            return
        }
    }

    @IBAction func doneButtonTapped(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
}
