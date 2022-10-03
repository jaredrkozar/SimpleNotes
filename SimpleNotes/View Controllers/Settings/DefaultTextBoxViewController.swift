//
//  DefaultTextBoxViewController.swift
//  SimpleNotes
//
<<<<<<< HEAD
//  Created by Jared Kozar on 5/31/22.
=======
//  Created by JaredKozar on 6/30/22.
>>>>>>> ios-16
//

import UIKit

class DefaultTextBoxViewController: UITableViewController, UIFontPickerViewControllerDelegate, UIColorPickerViewControllerDelegate {
    var textBoxSettings = [Sections]()
    
    var fontSize: UITextField = {
        let textfield = UITextField()
        textfield.keyboardType = .numberPad
        textfield.backgroundColor = .secondarySystemFill
        textfield.layer.cornerRadius = Constants.cornerRadius
<<<<<<< HEAD
=======
        textfield.addTarget(nil, action: #selector(finishedPickingFontSize), for: .editingDidEnd)
        textfield.text = UserDefaults.standard.string(forKey: "defaultFontSize")
>>>>>>> ios-16
        return textfield
    }()
    
    var colorCircle: UIView = {
        let view = UIView()
        view.sizeToFit()
        view.layer.cornerRadius = Constants.cornerRadius
<<<<<<< HEAD
        view.backgroundColor = .green
=======
        view.backgroundColor = UIColor(hex: UserDefaults.standard.string(forKey: "defaultTextColor")!)
>>>>>>> ios-16
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
<<<<<<< HEAD
=======
    var optionLabel: UILabel = {
        let view = UILabel()
        view.numberOfLines = 1
        return view
    }()
    
>>>>>>> ios-16
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Text Box Defaults"
        self.tableView = UITableView(frame: self.tableView.frame, style: .insetGrouped)
 
        tableView.register(TableRowCell.self, forCellReuseIdentifier: TableRowCell.identifier)
        self.tableView.backgroundColor = .systemGroupedBackground
        
       configureTextBoxSettings()
    }

    // MARK: - Table view data source
<<<<<<< HEAD

    func configureTextBoxSettings() {
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Font", option: "HELLO", icon: nil, iconBGColor: nil, detailViewType: .text(string: "DDD"), handler: {
=======
    func configureTextBoxSettings() {
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Font", option: "HELLO", rowIcon: nil, control: .text(string: "DDD")) {
>>>>>>> ios-16
                
                let fontPicker = UIFontPickerViewController()
                fontPicker.delegate = self
                self.present(fontPicker, animated: true)
<<<<<<< HEAD
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Color", option: "", icon: nil, iconBGColor: nil, detailViewType: .color(color: colorCircle), handler: {
                
               let colorPicker = UIColorPickerViewController()
                colorPicker.delegate = self
                self.present(colorPicker, animated: true)
=======
            }
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
            SettingsOptions(title: "Text Color", option: "", rowIcon: nil, control: .color(color: colorCircle), handler: {
                
                self.showColorPicker(popoverPresenter: self.colorCircle, saveTo: "defaultTextColor", vcTitle: "Text Color")
>>>>>>> ios-16
            })
        ]))
        
        textBoxSettings.append(Sections(title: nil, settings: [
<<<<<<< HEAD
            SettingsOptions(title: "Font SIze", option: "", icon: nil, iconBGColor: nil, detailViewType: .control(controls: [fontSize]), handler: {
                
               
            })
=======
            SettingsOptions(title: "Font Size", option: "", rowIcon: nil, control: .control(controls: [fontSize], width: 100), handler: nil)
>>>>>>> ios-16
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
<<<<<<< HEAD
        print(indexPath.section)
        print(indexPath.row)
        let model = textBoxSettings[indexPath.section].settings[indexPath.row]
        model.handler!()
=======

        let model = textBoxSettings[indexPath.section].settings[indexPath.row]
        model.handler?()
>>>>>>> ios-16
    }

    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let descriptor = viewController.selectedFontDescriptor!
        let font = UIFont(descriptor: descriptor, size: 60)
           
        let cell = tableView.cellForRow(at: IndexPath(item: 0, section: 0)) as! TableRowCell
        
        cell.optionLabel.text = font.familyName
<<<<<<< HEAD
=======
        UserDefaults.standard.set(font.familyName, forKey: "defaultFont")
>>>>>>> ios-16
        self.tableView.reloadRows(at: [IndexPath(item: 0, section: 1)], with: .automatic)
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        if continuously == false {
            colorCircle.backgroundColor = color
<<<<<<< HEAD
        }
    }
=======
            UserDefaults.standard.set(color.toHex, forKey: "defaultTextColor")
        }
    }
    
    func showColorPicker(popoverPresenter: UIView, saveTo: String, vcTitle: String) {
        let vc = SelectColorPopoverViewController()
        let navigationController = UINavigationController(rootViewController: vc)
        
        if currentDevice == .iphone || self.splitViewController?.traitCollection.horizontalSizeClass == .compact {
            if let picker = navigationController.presentationController as? UISheetPresentationController {
                picker.detents = [.medium()]
                picker.prefersGrabberVisible = true
                picker.preferredCornerRadius = 5.0
            }
        } else if currentDevice == .ipad {
            navigationController.modalPresentationStyle = UIModalPresentationStyle.popover
            navigationController.preferredContentSize = CGSize(width: 270, height: 250)
            navigationController.popoverPresentationController?.sourceItem = popoverPresenter
        } else {
            return
        }
        vc.vcTitle = vcTitle
        present(navigationController, animated: true)
        vc.returnColor = { color in
            popoverPresenter.backgroundColor = UIColor(hex: color)
            UserDefaults.standard.set(color, forKey: saveTo)
        }
    }
    
    @objc func finishedPickingFontSize() {
        UserDefaults.standard.set(fontSize.text, forKey: "defaultFontSize")
    }
>>>>>>> ios-16
}
