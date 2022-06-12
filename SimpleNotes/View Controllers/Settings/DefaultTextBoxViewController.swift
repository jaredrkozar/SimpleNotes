//
//  DefaultTextBoxViewController.swift
//  SimpleNotes
//
//  Created by Jared Kozar on 5/31/22.
//

import UIKit

class DefaultTextBoxViewController: UITableViewController, UIFontPickerViewControllerDelegate, UIColorPickerViewControllerDelegate {
    var textBoxSettings = [Sections]()
    
    var fontSize: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.backgroundColor = .secondarySystemFill
        textfield.layer.cornerRadius = Constants.cornerRadius
        return textfield
    }()
    
    var colorCircle: UIView = {
        let view = UIView()
        view.sizeToFit()
        view.layer.cornerRadius = Constants.cornerRadius
        view.backgroundColor = .green
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Text Box Defaults"
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
 
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        self.tableView.backgroundColor = .systemGroupedBackground
        
       configureTextBoxSettings()
    }

    // MARK: - Table view data source

    func configureTextBoxSettings() {
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Font", option: "HELLO", icon: nil, iconBGColor: nil, detailViewType: .text(string: "DDD"), handler: {
                
                let fontPicker = UIFontPickerViewController()
                fontPicker.delegate = self
                self.present(fontPicker, animated: true)
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Color", option: "", icon: nil, iconBGColor: nil, detailViewType: .color(color: colorCircle), handler: {
                
               let colorPicker = UIColorPickerViewController()
                colorPicker.delegate = self
                self.present(colorPicker, animated: true)
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Font SIze", option: "", icon: nil, iconBGColor: nil, detailViewType: .control(controls: [fontSize]), handler: {
                
               
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
        cell.backgroundColor = .secondarySystemGroupedBackground
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.section)
        print(indexPath.row)
        let model = textBoxSettings[indexPath.section].settings[indexPath.row]
        model.handler!()
    }

    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let descriptor = viewController.selectedFontDescriptor!
        let font = UIFont(descriptor: descriptor, size: 60)
           
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! TableRowCell
        
        cell.optionLabel.text = font.familyName
        self.tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if continuously == false {
            colorCircle.backgroundColor = color
        }
    }
}
