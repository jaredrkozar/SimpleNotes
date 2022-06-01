//
//  DefaultTextBoxViewController.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/31/22.
//

import UIKit

class DefaultTextBoxViewController: UITableViewController {
    var textBoxSettings = [Sections]()
    
    var fontSize: UIStepper = {
        let stepper = UIStepper()
        stepper.autorepeat = true
        stepper.minimumValue = 10
        stepper.maximumValue = 30
        stepper.stepValue = 1
        return stepper
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
 
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
       
       configureTextBoxSettings()
    }

    // MARK: - Table view data source

    func configureTextBoxSettings() {
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Font", option: "HELLO", icon: nil, iconBGColor: nil, detailViewType: .text(string: "DDD"), handler: {
                
                let fontPicker = UIFontPickerViewController()
                
                self.present(fontPicker, animated: true)
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Color", option: "", icon: nil, iconBGColor: nil, detailViewType: .control(control: [fontSize]), handler: {
                
                let fontPicker = UIFontPickerViewController()
                
                self.present(fontPicker, animated: true)
            })
        ]))
    }
                               
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return textBoxSettings.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return textBoxSettings[section].settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let setting = textBoxSettings[indexPath.section].settings[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TableRowCell", for: indexPath) as? TableRowCell else {
            fatalError("Unable to dequeue the settings cell.")
        }
        
        cell.configureCell(with: setting)
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = textBoxSettings[indexPath.section].settings[indexPath.row]
        model.handler!()
    }

}
